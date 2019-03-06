class GameState
  attr_reader :nodes,
    :personas,
    :current_actor,
    :player_personas,
    :current_initiative_pass,
    :extended_actions,
    :known_data_pieces

  def initialize
  end

  def initiative_order
    raise InitiativeNotSetError if personas.any? { |k, v| v.nil? }

    personas.select { |k, v| k.matrix_initiative_passes >= @current_initiative_pass }
      .sort_by { |k, v| -v }
      .map { |v| v[0] }
  end

  def available_nodes
    available_nodes = current_actor.nodes_present_in
    available_nodes.concat(current_actor.nodes_present_in.subscriptions_to_self.select { |sub| !sub.hidden_access? }.map(&:originating_node))
    available_nodes.concat(current_actor.nodes_present_in.subscriptions_to_others.select { |sub| !sub.hidden_access? }.map(&:destination_node))
    available_nodes.uniq!
  end

  def connectable_nodes(actor: current_actor)
    nodes_in_mutual_range(origin_node: actor.home_node).select do |node|
      node.device_mode != MatrixNode::HIDDEN_MODE || known_data_pieces[actor][node].include?(PerceptionData::NODE_PRESENCE)
    end

    actor.nodes_present_in.map do |node|
      node.subscriptions_to_others.select do |sub|
        !sub.hidden_access? || known_data_pieces[actor][sub.destination_node].include?(PerceptionData::NODE_PRESENCE)
      end.map(&:destination_node)
    end.concat(
      node.subscriptions_to_self.select do |sub|
          !sub.hidden_access? || known_data_pieces[actor][sub.originating_node].include?(PerceptionData::NODE_PRESENCE)
        end.map(&:originating_node)
      end
    ).uniq!
  end

  def actions_available
    ### for client side performance might be interesting to create a hash with actions available by target ###
    # return a hash with key = action_grouping, values is an array of key = target, value = action with details
    ActionProvider.registered_providers.each_with_object({}) do |action_type, h|
      h[action_type] = "ActionProvider::#{action_type}".constantize.new(game_state: self).actions
    end
    # TODO => unsubscribe_to provider
    # TODO => load_program provider
  end

  def hidden_nodes_in_range
    return [] unless current_actor.is_a?(Decker)
    nodes_in_mutual_range(origin_node: current_actor.home_node).select do |node|
      node.interface_mode == InterfaceMode::HIDDEN_MODE
    end

    # TODO => this should be implemented in action resolving where it adds the NODE_PRESENCE data.
    # TODO => Action resolvers for cybercombat can include revealing personas and agent programs ICON_TYPE
  end

  private

  def nodes_in_mutual_range(origin_node:)
    node_list.select do |node|
      origin_node.in_mutual_range?(node: node)
    end
  end
end
