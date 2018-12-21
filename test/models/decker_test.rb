require 'test_helper'

class DeckerTest < ActiveSupport::TestCase
  test '#run_program raises an error unless the node has a programs' do
    node = MobileNode.new(device_rating: 3)
    decker = Decker.from_node(home_node: node, skills: {}, attributes: {})

    assert_raises MatrixNode::NoSuchProgramError do
      decker.run_program(MatrixProgram.new(program_name: MatrixProgram::ATTACK, rating: 3))
    end
  end

  test '#run_program adds the program to the decker running programs' do
    prog = MatrixProgram.new(program_name: MatrixProgram::ATTACK, rating: 3)
    node = MobileNode.new(device_rating: 3, programs: [prog])
    decker = Decker.from_node(home_node: node, skills: {}, attributes: {})
    decker.run_program(prog)
    assert_equal [prog], decker.programs
  end

  test '#run_program removes the program from the node loaded programs' do
    prog = MatrixProgram.new(program_name: MatrixProgram::ATTACK, rating: 3)
    node = MobileNode.new(device_rating: 3, programs: [prog])
    decker = Decker.from_node(home_node: node, skills: {}, attributes: {})
    decker.run_program(prog)
    assert_nil decker.home_node.programs.find { |p| p == prog }
  end

  test '#stop_program raises an error unless the node has a programs' do
    node = MobileNode.new(device_rating: 3)
    decker = Decker.from_node(home_node: node, skills: {}, attributes: {})

    assert_raises MatrixNode::NoSuchProgramError do
      decker.stop_program(MatrixProgram.new(program_name: MatrixProgram::ATTACK, rating: 3))
    end
  end

  test '#stop_program removes the program from the decker running programs' do
    prog = MatrixProgram.new(program_name: MatrixProgram::ATTACK, rating: 3)
    node = MobileNode.new(device_rating: 3, icons: [])
    decker = Decker.from_node(home_node: node, skills: {}, attributes: {}, programs: [prog])
    decker.stop_program(prog)
    assert_equal [], decker.programs
  end

  test '#stop_program adds the program to the node loaded programs' do
    prog = MatrixProgram.new(program_name: MatrixProgram::ATTACK, rating: 3)
    node = MobileNode.new(device_rating: 3, icons: [])
    decker = Decker.from_node(home_node: node, skills: {}, attributes: {}, programs: [prog])
    decker.stop_program(prog)
    assert_not_nil decker.home_node.programs.find { |p| p == prog }
  end

  test '#actual_skill_rating returns 0 if the decker does not possess the skill' do
    node = MobileNode.new(device_rating: 3, icons: [])
    decker = Decker.from_node(home_node: node, skills: {}, attributes: {}, programs: [])
    assert_equal 0, decker.actual_skill_rating(Skills::CYBERCOMBAT)
  end

  test '#actual_skill_rating returns the value of the skill' do
    node = MobileNode.new(device_rating: 3, icons: [])
    decker = Decker.from_node(home_node: node, skills: { Skills::CYBERCOMBAT => 3 }, attributes: {}, programs: [])
    assert_equal 3, decker.actual_skill_rating(Skills::CYBERCOMBAT)
  end

  test '#actual_attribute_rating returns the value of the attribute' do
    node = MobileNode.new(device_rating: 3, icons: [])
    decker = Decker.from_node(home_node: node, skills: {}, attributes: { Attributes::LOGIC => 5 }, programs: [])
    assert_equal 5, decker.actual_attribute_rating(Attributes::LOGIC)
  end

  test '#hot_sim_bonus returns 2 if the inferface mode is InterfaceMode::HOT_SIM' do
    node = MobileNode.new(device_rating: 3, icons: [])
    decker = Decker.from_node(home_node: node, skills: {}, attributes: {}, programs: [], interface_mode: InterfaceMode::HOT_SIM)
    assert_equal 2, decker.hot_sim_bonus
  end

  test '#hot_sim bonus returns 0 if the InterfaceMode is InterfaceMode::AR or InterfaceMode::COLD_SIM' do
    node = MobileNode.new(device_rating: 3, icons: [])
    [InterfaceMode::AR, InterfaceMode::COLD_SIM].each do |mode|
      decker = Decker.from_node(home_node: node, skills: {}, attributes: {}, programs: [], interface_mode: mode)
      assert_equal 0, decker.hot_sim_bonus
    end
  end

  test '#subscribe_to creates a new NodeSubscription to the desired node' do
    node = MobileNode.new(device_rating: 3, icons: [])
    node2 = MobileNode.new(device_rating: 3, icons: [])
    decker = Decker.from_node(home_node: node, skills: {}, attributes: {}, programs: [])
    decker.subscribe_to(node: node2)
    assert_equal 1, decker.subscriptions.length
    assert_equal decker, decker.subscriptions[0].persona
    assert_equal node2, decker.subscriptions[0].destination_node
  end

  test '#nodes_present_in always returns at least the home node' do
    node = MobileNode.new(device_rating: 3, icons: [])
    decker = Decker.from_node(home_node: node, skills: {}, attributes: {}, programs: [])
    assert_equal [node], decker.nodes_present_in
  end

  test '#nodes_present_in also counts nodes subscribed to' do
    node = MobileNode.new(device_rating: 3, icons: [])
    node2 = MobileNode.new(device_rating: 3, icons: [])
    decker = Decker.from_node(home_node: node, skills: {}, attributes: {}, programs: [])
    decker.subscribe_to(node: node2)
    assert_equal [node, node2], decker.nodes_present_in
  end
end
