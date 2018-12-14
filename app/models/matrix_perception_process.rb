class MatrixPerceptionProcess
  def initialize(initiatior:, matrix_target:, known_data: [])
    @initiatior = initiatior
    @matrix_target = matrix_target
    @known_data = known_data
    @perception_data = PerceptionData.from_known_data(known_data)
  end

  def available_data
    @perception_data.available_data_pieces - known_data
  end

  def initiator_perception_dice_pool
    initiator.actual_skill_rating(Skills::COMPUTER) + initiator.actual_attribute_rating(Attributes::LOGIC) + initiator.hot_sim_bonus
  end

  def initiator_perception_dice_pool_limit
    initiator.get_program_rating(MatrixProgram::ANALYZE)
  end

  def matrix_target_stealth_pool
    return 0 unless @matrix_target.is_a?(RunsPrograms)
    matrix_target.get_skill_rating(Skills::HACKING) + matrix_target.get_attribute_rating(Attributes::LOGIC) + initiator.hot_sim_bonus
  end

  def matrix_target_stealth_pool_limit
    return 0 unless @matrix_target.is_a?(RunsPrograms)
    matrix_target.get_program_rating(MatrixProgram::STEALTH)
  end

  def total_data_pieces_gathered(initiator_hits:, matrix_target_hits:)
    initiator_hits - matrix_target_hits
  end
end
