require 'test_helper'

module ActionProvider
  class DetectHiddenNodeTest < ActiveSupport::TestCase
    setup do
      @home_node = MobileNode.new(device_rating: 4)
      @scan = MatrixProgram.new(program_name: MatrixProgram::SCAN, rating: 4)
      decker_skills = {
        Skills::CYBERCOMBAT => 4,
        Skills::HACKING => 4
      }

      decker_attributes = {
        Attributes::LOGIC => 5
      }

      @decker = Decker.from_node(
        home_node: @home_node,
        programs: [@scan],
        skills: decker_skills,
        attributes: decker_attributes
      )

      @known_data = {
        @decker => {}
      }
      @extended_actions = {
        @decker => {}
      }
      @game_state = MockState.new(@decker, @known_data, [@home_node], @extended_actions)
    end

    test '#actions returns [] unless the current_actor is running a scan program' do
      @decker.stubs(programs: [])
      assert_empty ActionProvider::DetectHiddenNode.new(game_state: @game_state).actions
    end

    test '#actions returns the extended test already running if there is one' do
      running_scan = ::DetectHiddenNodesProcess.new(hits: 5)
      extended_tests = {
        @decker => {
          'detect_hidden_node' => [
            { @decker => running_scan }
          ]
        }
      }

      game_state = MockState.new(@decker, @known_data, [@home_node], extended_tests)
      actions = ActionProvider::DetectHiddenNode.new(game_state: game_state).actions
      assert_equal extended_tests[@decker]['detect_hidden_node'][0], actions[0]
    end

    test '#actions returns a new detect_hidden_node_process with 0 hits' do
      actions = ActionProvider::DetectHiddenNode.new(game_state: @game_state).actions
      assert_equal 1, actions.length
      assert_equal 1, actions[0].keys.length
      assert_equal @decker, actions[0].keys[0]
      assert_equal 0, actions[0][@decker].hits
    end
  end
end
