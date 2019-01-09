require 'test_helper'

module ActionProvider
  class CybercombatTest < ActiveSupport::TestCase
    setup do
      @home_node = MobileNode.new(device_rating: 4)
      attack = MatrixProgram.new(program_name: MatrixProgram::ATTACK, rating: 4)
      decker_skills = {
        Skills::CYBERCOMBAT => 4,
        Skills::HACKING => 4
      }

      decker_attributes = {
        Attributes::LOGIC => 5
      }

      @decker = Decker.from_node(
        home_node: @home_node,
        programs: [attack],
        skills: decker_skills,
        attributes: decker_attributes
      )
      @agent = AgentProgram.new(programs: [], pilot_rating: 4, home_node: nil)
      @target = DesktopNode.new(device_rating: 4, programs: [], agents: [@agent])

      @known_data = {
        @decker => {}
      }
      @game_state = MockState.new(@decker, @known_data, [@home_node, @target])
    end

    test '#actions returns [] if the current_actor is not running any attack programs' do
      @decker.stubs(programs: [])
      assert_empty ActionProvider::Cybercombat.new(game_state: @game_state).actions
    end

    test '#actions returns [] if there are no deckers or agents on the subscribed nodes' do
      @target.stubs(icons: [])
      assert_empty ActionProvider::Cybercombat.new(game_state: @game_state).actions
    end

    test '#actions returns [] if there are no known deckers or agents on the subscribed nodes' do
      assert_empty ActionProvider::Cybercombat.new(game_state: @game_state).actions
    end

    test '#actions returns 1 action per known agent and decker times the number of attack programs on subscribed nodes' do
      known_data = {
        @decker => {
          @agent => [PerceptionData::ICON_TYPE]
        }
      }
      @decker.subscribe_to(node: @target)

      game_state = MockState.new(@decker, known_data, [@home_node, @target])
      actions = ActionProvider::Cybercombat.new(game_state: game_state).actions
      @decker.unsubscribe_to(node: @target)
      assert_equal 1, actions.length
      assert_equal [@agent], actions[0].keys
    end
  end
end
