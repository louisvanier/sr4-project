class MatrixPerceptionProcess
  # initiatior is either an agent or a decker
  # matrix target is any icon so it can be a decker's persona, an agent, a node, a subscription, a file or a program
  # known data is a hash with the keys being the data_type and the values being the actual value
  def initialize(initiator:, matrix_target:, known_data: {})
    @initiator = initiator
    @matrix_target = matrix_target
    @known_data = known_data
    @perception_data = PerceptionData.from_known_data(matrix_object: matrix_target, known_data: known_data)
  end

  def available_data
    @perception_data.available_data_pieces - @known_data.keys
  end

  def initiator_perception_dice_pool
    @initiator.actual_skill_rating(Skills::COMPUTER) + @initiator.actual_attribute_rating(Attributes::LOGIC) + @initiator.hot_sim_bonus
  end

  def initiator_perception_dice_pool_limit
    @initiator.get_program_rating(MatrixProgram::ANALYZE)
  end

  def matrix_target_stealth_pool
    return 0 unless @matrix_target.get_program_rating(MatrixProgram::STEALTH) > 0
    @matrix_target.actual_skill_rating(Skills::HACKING) + @matrix_target.actual_attribute_rating(Attributes::LOGIC) + @matrix_target.hot_sim_bonus
  end

  def matrix_target_stealth_pool_limit
    @matrix_target.get_program_rating(MatrixProgram::STEALTH)
  end

  def total_data_pieces_gathered(initiator_hits:, matrix_target_hits:)
    initiator_hits - matrix_target_hits
  end
end
