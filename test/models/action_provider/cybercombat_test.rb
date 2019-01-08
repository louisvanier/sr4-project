require 'test_helper'

module ActionProvider
  class CybercombatTest < ActiveSupport::TestCase
    setup do
      @home_node = MobileNode.new(device_rating: 4)
      analyze_program = MatrixProgram.new(program_name: MatrixProgram::ATTACK, rating: 4)
      decker_skills = {
        Skills::CYBERCOMBAT => 4,
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
      @agent = AgentProgram.new(programs: [], pilot_rating: 4, home_node: @target)

      @known_data = {
        @decker => {}
      }
      @game_state = MockState.new(@decker, @known_data, [@home_node, @target])
    end

    test '#actions returns [] if the current_actor is not running any attack programs' do
      @decker.stubs(programs: [])
      assert_empty ActionProvider::Cybercombat.new(game_state: @game_state).actions
    end

    test '#actions returns [] if there are no other deckers and agents on the subscribed nodes' do
    end

    test '#actions returns 1 action per known agent and decker times the number of attack programs on subscribed nodes' do
    end
  end
end
