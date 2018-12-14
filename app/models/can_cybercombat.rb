module CanCybercombat
  def get_total_condition_boxes
    (get_device_attribute_rating(DeviceAttribute::SYSTEM) / 2.0).ceil + 8
  end

  def get_damage_resistance_pool(attack_program, full_defense)
    pool = 0
    if attack_program.black_IC?
      pool += actual_attribute_rating(Attributes::WILLPOWER) + get_program_rating(MatrixPrograms::BIOFEEDBACK_FILTER) if attack_program.black_IC?
    else
      actual_device_rating(DeviceAttribute::SYSTEM) + get_program_rating(MatrixPrograms::ARMOR)
    end

    pool += actual_skill_rating(Skills::HACKING) if full_defense

    pool
  end

  def get_matrix_initiative
    case interface_mode
    when InterfaceMode::AR
      actual_attribute_rating(Attributes::REACTION) + actual_attribute_rating(Attributes::INTUITION)
    when InterfaceMode::COLD_SIM, InterfaceMode::HOT_SIM
      rating = actual_device_rating(DeviceAttribute::RESPONSE) + actual_attribute_rating(Attributes::INTUITION)
      rating += 1 if interface_mode == InterfaceMode::HOT_SIM and is_a?(Decker)
      rating
    end
  end
end
