require 'test_helper'

module ActionProvider
  class MockState
    attr_reader :current_actor, :known_data_pieces, :nodes, :extended_actions

    def initialize(current_actor, known_data_pieces, nodes, extended_actions = nil)
      @current_actor = current_actor
      @known_data_pieces = known_data_pieces
      @nodes = nodes
      @extended_actions = extended_actions
    end
  end

  class AnalyzeTest <  ActiveSupport::TestCase
    setup do
      @home_node = MobileNode.new(device_rating: 4)
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
        home_node: @home_node,
        programs: [analyze_program],
        skills: decker_skills,
        attributes: decker_attributes
      )
      @target_analyze_program = analyze_program.clone
      @target = DesktopNode.new(device_rating: 4, programs: [@target_analyze_program])
      @agent = AgentProgram.new(programs: [stealth_program], pilot_rating: 4, home_node: @target)

      @known_data = {
        @decker => {}
      }
      @game_state = MockState.new(@decker, @known_data, [@home_node, @target])
    end

    test '#actions returns an empty array if the current_actor is not running any analyze programs' do
      @decker.stubs(:get_program).with(MatrixProgram::ANALYZE).returns(nil)
      assert_empty ActionProvider::Analyze.new(game_state: @game_state).actions
    end

    test '#actions returns an empty result if the current_actor is only connected to his home_node' do
      assert_empty ActionProvider::Analyze.new(game_state: @game_state).actions
    end

    test '#actions returns 1 result per icon and for the node itself' do
      @decker.subscribe_to(node: @target)
      actions = ActionProvider::Analyze.new(game_state: @game_state).actions
      @decker.unsubscribe_to(node: @target)
      assert_equal Set.new(actions.map(&:keys).flatten), Set.new([@target, @target_analyze_program])
    end
  end
end
