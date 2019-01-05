class GameState
  attr_reader :nodes, :personas, :current_actor, :player_personas, :current_initiative_pass
  def initialize
  end

  def gamemaster_turn?
    return false if player_personas.include?(current_actor)
    true
  end

  def available_nodes
    return nodes if gamemaster_turn?
    available_nodes = current_actor.nodes_present_in
    # nodes in mutual signal range not hidden
    # nodes_present_in.each slaved_nodes
    # nodes_present_in.each sub_to_others.destination_node && !node.hidden?
    # nodes_present_in.each sub_to_self.destination_node && !node.hidden?
  end

  def actions_available
    return {} if gamemaster_turn? # TODO => gamemaster will be implemented further in time

    ### for client side performance might be interesting to create a hash with actions available by target ###
    # return a hash with key = action_grouping, values is an array of key = target, value = action with details
    # build by calling exploit_actions
    #                 + analyze_actions
    #                 + cybercombat_actions
    #                 + run_program (if any unloaded program on home_node)
    #                 + deactive_program_actions
    #                 + detect_hidden_nodes
    #                 + disarm_data_bomb
    #                 + initiate_cryptanalysis
  end

  private

  def exploit_actions
    return [] unless current_actor.get_program_rating(MatrixProgram::EXPLOIT) > 0

    # build a list from available_nodes - current_actor.nodes_present_in for hacking_attempts
    # build a list with current_actor.nodes_present_in for CRASH NODE action
    # build a list with current_actor.nodes_present_in for CRASH PROGRAM action
  end

  def analyze_actions
    return [] unless current_actor.get_program_rating(MatrixProgram::ANALYZE) > 0
    # build a list of available_data_pieces by node, trim the ones where everything is available
  end

  def cybercombat_actions
    return [] unless current_actor.programs.any? { |prog| prog.damage_type && prog.rating > 0 }

    # return a list of known agent programs and personas detected in current_actor.nodes_present_in
  end

  def deactive_program_actions
    # return a list of current_actor.programs
    # also return a list of known agents on nodes where the account is ADMIN (or maybe security?)
  end
end
