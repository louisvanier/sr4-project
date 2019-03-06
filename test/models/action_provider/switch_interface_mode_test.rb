require 'test_helper'

module ActionProvider
  class SwitchInterfaceModeTest <  ActiveSupport::TestCase
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
      assert_empty ActionProvider::SwitchInterfaceMode.new(game_state: game_state).actions
    end

    test '#actions returns 1 result per interface mode except the current one of the actor' do
      actions = ActionProvider::SwitchInterfaceMode.new(game_state: @game_state).actions
      assert_equal 2, actions.size
    end
  end
end
