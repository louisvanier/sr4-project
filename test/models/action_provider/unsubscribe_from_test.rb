require 'test_helper'

module ActionProvider
  class UnsubscribeFromTest <  ActiveSupport::TestCase
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

      @in_range_node = DesktopNode.new(device_rating: 4, programs: [], physical_position: [500, 200])

      @known_data = {
        @decker => {}
      }
      @game_state = MockState.new(@decker, @known_data, [@home_node, @in_range_node])
    end

    test '#actions returns an empty array if the actor is only subscribed to its home node' do
      assert_empty ActionProvider::UnsubscribeFrom.new(game_state: @game_state).actions
    end

    test '#actions returns an empty result if the current_actor is an agent' do
      game_state = MockState.new(@agent, @known_data, [@home_node, @in_range_node])
      assert_empty ActionProvider::UnsubscribeFrom.new(game_state: game_state).actions
    end

    test '#actions returns 1 result per node subscribed to' do
      @decker.subscribe_to(node: @in_range_node)
      actions = ActionProvider::UnsubscribeFrom.new(game_state: @game_state).actions
      assert_equal Set.new(actions.map(&:keys).flatten), Set.new([@in_range_node])
      @decker.unsubscribe_to(node: @in_range_node)
    end
  end
end
