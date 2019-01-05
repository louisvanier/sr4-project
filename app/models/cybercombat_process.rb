class CybercombatProcess
  class InitiativeNotSetError < StandardError; end
  class ICImmuneToBlackICError < StandardError; end
  class NotAnAttackProgramError < StandardError; end

  class << self
    def get_attack_details(attacker, defender, attack_program, full_defense = false)
      raise ICImmuneToBlackICError if attack_program.black_IC? && defender.is_a?(AgentProgram)
      raise NotAnAttackProgramError unless attack_program.damage_type

      attack_pool = attacker.actual_attribute_rating(Attributes::LOGIC) + attacker.actual_skill_rating(Skills::CYBERCOMBAT) + attacker.hot_sim_bonus
      defense_pool = defender.actual_device_rating(DeviceAttribute::RESPONSE) + defender.actual_device_rating(DeviceAttribute::FIREWALL)
      defense_pool += defender.actual_skill_rating(Skills::HACKING) if full_defense
      attack_pool_limit = attacker.get_program_rating(attack_program.program_name)
      CybercombatAttackDetails.new(attack_pool: attack_pool, attack_pool_limit: attack_pool_limit, defense_pool: defense_pool)
    end

    def get_damage_details(attacker_net_hits, attacker, defender, attack_program)
      damage_value = attacker.get_program_rating(attack_program.program_name) + attacker_net_hits
      damage_type = attack_program.damage_type
      damage_soak_pool = defender.get_damage_resistance_pool(attack_program)
      CybercombatDamageDetails.new(damage_value: damage_value, damage_type: damage_type, damage_soak_pool: damage_soak_pool)
    end
  end
end
