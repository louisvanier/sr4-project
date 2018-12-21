require 'test_helper'

class AgentProgramTest < ActiveSupport::TestCase
  setup do
    @home_node = MobileNode.new(device_rating: 3)
    @other_node = DesktopNode.new(device_rating: 4)
    @agent = AgentProgram.new(programs: [], pilot_rating: 5, home_node: @home_node)
  end

  test '#actual_skill_rating returns the pilot rating clamped by the home node\'s response' do
    [
      Skills::CYBERCOMBAT,
      Skills::DATA_SEARCH,
      Skills::ELECTRONIC_WARFARE,
      Skills::HACKING
    ].each do |skill|
      @agent.move_to_other_node(node: @home_node)
      assert_equal 3, @agent.actual_skill_rating(skill)
      @agent.move_to_other_node(node: @other_node)
      assert_equal 4, @agent.actual_skill_rating(skill)
    end
  end

  test '#actual_attribute_rating returns the pilot rating clamped by the home node\'s response' do
    [
      Attributes::LOGIC,
      Attributes::INTUITION,
      Attributes::REACTION,
    ].each do |attribute|
      @agent.move_to_other_node(node: @home_node)
      assert_equal 3, @agent.actual_attribute_rating(attribute)
      @agent.move_to_other_node(node: @other_node)
      assert_equal 4, @agent.actual_attribute_rating(attribute)
    end
  end

  test '#hot_sim_bonus always returns 2' do
    assert_equal 2, @agent.hot_sim_bonus
  end

  test '#nodes_present_in always returns an array with only the home node in' do
    assert_equal [@home_node], @agent.nodes_present_in
    @agent.move_to_other_node(node: @other_node)
    assert_equal [@other_node], @agent.nodes_present_in
  end

  test '#interface_mode always returns VR HOT SIM' do
    assert_equal InterfaceMode::HOT_SIM, @agent.interface_mode
  end

  test '#move_to_other_node changes the agents home node' do
    @agent.move_to_other_node(node: @other_node)
    assert_equal @other_node, @agent.home_node
  end
end
