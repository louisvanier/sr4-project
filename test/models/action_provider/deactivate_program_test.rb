require 'test_helper'

module ActionProvider
  class DeactivateProgramTest < ActiveSupport::TestCase
    setup do
      @home_node = MobileNode.new(device_rating: 4)
      @attack = MatrixProgram.new(program_name: MatrixProgram::ATTACK, rating: 4)
      @armor = MatrixProgram.new(program_name: MatrixProgram::ARMOR, rating: 4)
      decker_skills = {
        Skills::CYBERCOMBAT => 4,
        Skills::HACKING => 4
      }

      decker_attributes = {
        Attributes::LOGIC => 5
      }

      @decker = Decker.from_node(
        home_node: @home_node,
        programs: [@attack, @armor],
        skills: decker_skills,
        attributes: decker_attributes
      )

      @known_data = {
        @decker => {}
      }
      @agent = AgentProgram.new(programs: [], pilot_rating: 4, home_node: @home_node)
      @game_state = MockState.new(@decker, @known_data, [@home_node])
    end

    test '#actions returns [] when the current_actor is not a decker' do
      game_state = MockState.new(@agent, @known_data, [@home_node])
      assert_empty ActionProvider::DeactivateProgram.new(game_state: game_state).actions
    end

    test '#actions returns 1 action per loaded programs for the decker' do
      actions = ActionProvider::DeactivateProgram.new(game_state: @game_state).actions
      assert_equal 2, actions.length
      assert_equal Set.new([@attack, @armor]), Set.new(actions.map(&:keys).flatten)
    end
  end
end
