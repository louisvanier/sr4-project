require 'test_helper'

class CybercombatProcessTest < ActiveSupport::TestCase
  setup do
    @decker_commlink = MobileNode.new(device_rating: 4)
    @decker_programs = [
      MatrixProgram.new(program_name: MatrixProgram::ATTACK, rating: 4),
      MatrixProgram.new(program_name: MatrixProgram::ARMOR, rating: 2),
      MatrixProgram.new(program_name: MatrixProgram::BIOFEEDBACK_FILTER, rating: 2),
      MatrixProgram.new(program_name: MatrixProgram::BLACKOUT, rating: 2),
    ]
    @decker_skills = {
      Skills::COMPUTER => 4,
      Skills::HACKING => 4,
      Skills::CYBERCOMBAT => 6,
    }
    @decker_attributes = {
      Attributes::LOGIC => 5,
      Attributes::WILLPOWER => 5,
    }
    @decker = Decker.from_node(home_node: @decker_commlink, programs: @decker_programs, skills: @decker_skills, attributes: @decker_attributes)

    combat_node = DesktopNode.new(device_rating: 5)
    @blackout_agent = AgentProgram.new(home_node: combat_node, programs: [MatrixProgram.new(program_name: MatrixProgram::BLACKOUT, rating: 4)], pilot_rating: 4)
    @blackhammer_agent = blackout_agent = AgentProgram.new(home_node: combat_node, programs: [MatrixProgram.new(program_name: MatrixProgram::BLACK_HAMMER, rating: 4)], pilot_rating: 4)
  end

  test '#current_initiative_pass defaults to 1' do
    assert_equal 1, CybercombatProcess.new(participants: {}).current_initiative_pass
  end

  test '#initiative_order raises an error if any participant does not have its initiative set' do
    participants = {
      @decker => 9,
      @blackout_agent => 8,
      @blackhammer_agent => nil,
    }

    assert_raises CybercombatProcess::InitiativeNotSetError do
      CybercombatProcess.new(participants: participants).initiative_order
    end
  end

  test '#initiative_order sorts the participants by initiative in descending order' do
    participants = {
      @decker => 9,
      @blackout_agent => 8,
      @blackhammer_agent => 11,
    }

    expected = [@blackhammer_agent, @decker, @blackout_agent]

    assert_equal expected, CybercombatProcess.new(participants: participants).initiative_order
  end

  test '#initiative_order only sorts the participants that can still act in the current initiative pass' do
    decker = Decker.from_node(home_node: @decker_commlink, programs: @decker_programs, skills: @decker_skills, attributes: @decker_attributes, interface_mode: InterfaceMode::COLD_SIM)
    participants = {
      decker => 12,
      @blackout_agent => 8,
      @blackhammer_agent => 11,
    }

    expected = [@blackhammer_agent, @blackout_agent]
    assert_equal expected, CybercombatProcess.new(participants: participants, current_initiative_pass: 3).initiative_order
  end

  test '#get_attack_details raises an error if the defender is an agent and the attack program is some black IC' do
    participants = {
      @decker => 9,
      @blackout_agent => 8,
      @blackhammer_agent => 11,
    }

    assert_raises CybercombatProcess::ICImmuneToBlackICError do
      CybercombatProcess.new(participants: participants).get_attack_details(@decker, @blackout_agent, @decker.get_program(MatrixProgram::BLACKOUT))
    end
  end

  test '#get_attack_details raises an error if the attack program is not an attack program_name' do
    participants = {
      @decker => 9,
      @blackout_agent => 8,
      @blackhammer_agent => 11,
    }

    assert_raises CybercombatProcess::NotAnAttackProgramError do
      CybercombatProcess.new(participants: participants).get_attack_details(@decker, @blackout_agent, @decker.get_program(MatrixProgram::ARMOR))
    end
  end

  test '#get_attack_details returns the attack pool with its limit and the defense pool' do
    participants = {
      @decker => 9,
      @blackout_agent => 8,
      @blackhammer_agent => 11,
    }

    details = CybercombatProcess.new(participants: participants).get_attack_details(@decker, @blackout_agent, @decker.get_program(MatrixProgram::ATTACK))
    assert_equal 13, details.attack_pool # CYBERCOMBAT(6) + LOGIC(5) + HOT_SIM(2)
    assert_equal 4, details.attack_pool_limit # ATTACK Rating (4)
    assert_equal 10, details.defense_pool # Agent uses the home node's RESPONSE(5) + FIREWALL(5)
  end

  test '#get_attack_details adds the defender hacking skill if on full defense' do
    participants = {
      @decker => 9,
      @blackout_agent => 8,
      @blackhammer_agent => 11,
    }

    details = CybercombatProcess.new(participants: participants).get_attack_details(@decker, @blackout_agent, @decker.get_program(MatrixProgram::ATTACK), true)
    assert_equal 13, details.attack_pool # CYBERCOMBAT(6) + LOGIC(5) + HOT_SIM(2)
    assert_equal 4, details.attack_pool_limit # ATTACK Rating (4)
    assert_equal 14, details.defense_pool # Agent uses the home node's RESPONSE(5) + FIREWALL(5) + HACKING(4), hacking == agent pilot rating
  end

  test '#get_damage_details returns the damage value and type and the damage soak roll' do
    participants = {
      @decker => 9,
      @blackout_agent => 8,
      @blackhammer_agent => 11,
    }

    details = CybercombatProcess.new(participants: participants).get_damage_details(2, @decker, @blackout_agent, @decker.get_program(MatrixProgram::ATTACK))
    assert_equal 6, details.damage_value # ATTACK(rating 4) + 2 Net hits
    assert_equal MatrixProgram::MATRIX_DAMAGE, details.damage_type
    assert_equal 5, details.damage_soak_pool # SYTEM(5) + ARMOR(0)
  end

  test '#get_damage_details gets willpower + biofeedback filter against black IC' do
    participants = {
      @decker => 9,
      @blackout_agent => 8,
      @blackhammer_agent => 11,
    }

    details = CybercombatProcess.new(participants: participants).get_damage_details(2, @blackout_agent, @decker, @blackout_agent.get_program(MatrixProgram::BLACKOUT))
    assert_equal 6, details.damage_value # ATTACK(rating 4) + 2 Net hits
    assert_equal MatrixProgram::STUN_DAMAGE, details.damage_type
    assert_equal 7, details.damage_soak_pool # WILLPOWER(5) + BIOFEEDBACK_FILTER(2)
  end
end
