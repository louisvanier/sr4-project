require 'test_helper'

class MatrixPerceptionProcessTest < ActiveSupport::TestCase
  setup do
    home_node = MobileNode.new(device_rating: 4)
    analyze_program = MatrixProgram.new(program_name: MatrixProgram::ANALYZE, rating: 4)
    stealth_program = MatrixProgram.new(program_name: MatrixProgram::STEALTH, rating: 4)
    decker_skills = {
      Skills::COMPUTER => 4,
      Skills::HACKING => 4
    }

    decker_attributes = {
      Attributes::LOGIC => 5
    }

    @decker = Decker.from_node(
      home_node: home_node,
      programs: [analyze_program],
      skills: decker_skills,
      attributes: decker_attributes
    )
    @target = DesktopNode.new(device_rating: 4, programs: [analyze_program.clone])
    @agent = AgentProgram.new(programs: [stealth_program], pilot_rating: 4, home_node: @target)
  end

  test '#available_data returns the provider available_data_pieces when known data is only the icon type' do
    process = MatrixPerceptionProcess.new(initiator: @decker, matrix_target: @target, known_data: { PerceptionData::ICON_TYPE => 'DesktopNode' })
    assert_equal PerceptionDataProvider::MatrixNodeProvider.new(@target).available_data_pieces, process.available_data
  end

  test '#available_data does not return known_data in the available_data' do
    known_data = { PerceptionData::ICON_TYPE => 'DesktopNode', PerceptionData::RESPONSE_RATING => 4 }
    expected_available_data = PerceptionDataProvider::MatrixNodeProvider.new(@target).available_data_pieces - [PerceptionData::RESPONSE_RATING]

    process = MatrixPerceptionProcess.new(initiator: @decker, matrix_target: @target, known_data: known_data)
    assert_equal expected_available_data, process.available_data
  end

  test '#available_data returns only ICON_TYPE when known_data is empty' do
    process = MatrixPerceptionProcess.new(initiator: @decker, matrix_target: @target, known_data: {})
    assert_equal [PerceptionData::ICON_TYPE], process.available_data
  end

  test '#initiator_perception_dice_pool returns the initator COMPUTER + LOGIC + Hot sim bonus if any' do
    process = MatrixPerceptionProcess.new(initiator: @decker, matrix_target: @target, known_data: {})

    # COMPUTER(4) + LOGIC(5) + HOT_SIM(2)
    assert_equal 11, process.initiator_perception_dice_pool
  end

  test '#initiator_perception_dice_pool_limit returns the initiator ANALYZE program rating' do
    process = MatrixPerceptionProcess.new(initiator: @decker, matrix_target: @target, known_data: {})

    assert_equal 4, process.initiator_perception_dice_pool_limit
  end

  test '#matrix_target_stealth_pool returns HACKING + LOGIC + Hot sim bonus if any' do
    process = MatrixPerceptionProcess.new(initiator: @decker, matrix_target: @agent, known_data: {})

    assert_equal 10, process.matrix_target_stealth_pool
  end

  test '#matrix_target_stealth_pool returns 0 for matrix_nodes since they cannot run a stealth program' do
    process = MatrixPerceptionProcess.new(initiator: @decker, matrix_target: @target, known_data: {})

    assert_equal 0, process.matrix_target_stealth_pool
  end

  test '#matrix_target_stealth_pool_limit returns the targets STEALTH program rating' do
    process = MatrixPerceptionProcess.new(initiator: @decker, matrix_target: @agent, known_data: {})

    assert_equal 4, process.matrix_target_stealth_pool_limit
  end

  test '#matrix_target_stealth_pool_limit returns 0 for a matrix node' do
    process = MatrixPerceptionProcess.new(initiator: @decker, matrix_target: @target, known_data: {})

    assert_equal 0, process.matrix_target_stealth_pool_limit
  end
end
