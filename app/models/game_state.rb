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

  def actions_available
    ### for client side performance might be interesting to create a hash with actions available by target ###
    # return a hash with key = action_grouping, values is an array of key = target, value = action with details
    ActionProvider.registered_providers.each_with_object({}) do |action_type, h|
      h[action_type] = "ActionProvider::#{action_type}".constantize.new(game_state: self).actions
    end
    # TODO => unsubscribe_to provider
    # TODO => load_program provider
  end
end
