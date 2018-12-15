class CybercombatProcess
  class InitiativeNotSetError < StandardError; end
  class NotInSameNodeError < StandardError; end
  class ICImmuneToBlackICError < StandardError; end

  attr_accessor :participants, :current_initiatives, :current_initiative_pass

  def initialize(participants:, current_initiative_pass: 1)
    @participants = participants
    @current_initiative_pass = current_initiative_pass
  end

  def initiative_order
    raise InitiativeNotSetError if @participants.any? { |k, v| v.nil? }

    @participants.select { |k, v| k.matrix_initiative_passes >= @current_initiative_pass}
      .sort_by { |k, v| v }
      .reverse_each { |v| v }
      .map { |v| v[0] }
  end

  def get_attack_details(attacker, defender, attack_program)
    raise NotInSameNodeError if (attacker.nodes_present_in & defender.nodes_present_in).empty?
    raise ICImmuneToBlackICError if attack_program.black_IC? && defender.is_a?(AgentProgram)

    attack_pool = attacker.get_attribute_rating(Attributes::LOGIC) + attacker.get_skill_rating(Skills::CYBERCOMBAT) + attacker.hot_sim_bonus
    defense_pool = defender.actual_device_rating(DeviceAttribute::RESPONSE) + defender.actual_device_rating(DeviceAttribute::FIREWALL)
    attack_pool_limit = attacker.get_program_rating(attack_program.program_name)
  end

  def get_damage_details(attacker_net_hits, attacker, defender attack_program)
    damage_value = attacker.get_program_rating(attack_program.program_name) + attacker_net_hits
    damage_type = attack_program.damage_type
    defense_dice_pool = defender.get_damage_resistance_pool
  end
end
