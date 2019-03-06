require 'test_helper'

module ActionProvider
  class LoadProgramTest <  ActiveSupport::TestCase
    setup do
      @home_node = MobileNode.new(device_rating: 4, physical_position: [0, 0])
      decker_skills = {
        Skills::COMPUTER => 4,
        Skills::HACKING => 4
      }

      decker_attributes = {
        Attributes::LOGIC => 5
      }

      @decker = Decker.from_node(
        home_node: @home_node,
        programs: [],
        skills: decker_skills,
        attributes: decker_attributes
      )
      @agent = AgentProgram.new(programs: [], pilot_rating: 4, home_node: @home_node)

      @known_data = {
        @decker => {}
      }
      @game_state = MockState.new(@decker, @known_data, [@home_node])
    end

    test '#actions returns an empty array if the actor an agent' do
      game_state = MockState.new(@agent, @known_data, [@home_node])
      assert_empty ActionProvider::LoadProgram.new(game_state: game_state).actions
    end

    test '#actions returns an empty result if the actors home node has no more available programs' do
      assert_empty ActionProvider::LoadProgram.new(game_state: @game_state).actions
    end

    test '#actions returns 1 result per available programs on the home node' do
      # @decker.subscribe_to(node: @in_range_node)
      analyze_program = MatrixProgram.new(program_name: MatrixProgram::ANALYZE, rating: 4)
      stealth_program = MatrixProgram.new(program_name: MatrixProgram::STEALTH, rating: 4)
      new_home_node = MobileNode.new(device_rating: 4, programs: [analyze_program, stealth_program])
      decker = Decker.from_node(
        home_node: new_home_node,
        programs: [],
        skills: {},
        attributes: {}
      )

      game_state = MockState.new(decker, {}, [new_home_node])
      actions = ActionProvider::LoadProgram.new(game_state: game_state).actions
      assert_equal Set.new(actions.map(&:keys).flatten), Set.new([analyze_program, stealth_program])
    end
  end
end
