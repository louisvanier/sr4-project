class GameState
  attr_accessor :current_actor

  attr_reader :nodes,
    :personas,
    :player_personas,
    :current_initiative_pass,
    :extended_actions,
    :known_data_pieces

  def initialize
    @object_counter = 0
    @nodes = []
    @personas = []
    @current_actor = nil
    @player_personas = []
    @known_data_pieces = {}
  end

  def add_node(node)
    add_game_object(node)
    node.icons.each { |icon| add_game_object(icon) }
    node.subscriptions_to_others.each { |subscription| add_game_object(subscription)}
    node.subscriptions_to_self.each { |subscription| add_game_object(subscription)}
    nodes << node
  end

  def add_persona(persona:, known_data: {})
    add_game_object(persona)
    persona.programs.each { |prog| add_game_object(prog) }
    persona.subscriptions.each { |subscription| add_game_object(subscription)}
    personas << persona
    known_data_pieces[persona] = known_data
  end

  def add_player(player:, known_data: {})
    add_game_object(player)
    player.programs.each { |prog| add_game_object(prog) }
    player.subscriptions.each { |subscription| add_game_object(subscription)}
    player_personas << player
    known_data_pieces[player] = known_data
  end

  def as_json(_options)
    {
      nodes: nodes.as_json(_options),
      personas: personas.as_json(_options),
      player_personas: player_personas.as_json(_options),
      current_initiative_pass: current_initiative_pass,
      subscriptions: all_subscriptions,
      current_actor: current_actor.game_id,
      extended_actions: extended_actions&.map { |actor, actions| { actor.game_id => actions }},
      known_data_pieces: known_data_pieces&.map { |actor, nodes| { actor.game_id => nodes.map { |node, data_pieces| [node.game_id, data_pieces]}.to_h }}
    }
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
  end

  private

  def add_game_object(game_object)
    return unless game_object.game_id.nil?
    game_object.game_id = ++@object_counter
  end

  def all_subscriptions
    nodes.map(&:subscriptions_to_self).concat(nodes.map(&:subscriptions_to_others)).concat(personas.map(&:subscriptions)).concat(player_personas.map(&:subscriptions))
  end
end
