require 'test_helper'

class MatrixNodeTest < ActiveSupport::TestCase
  test '#hidden? returns true if the node is in hidden_mode' do
    assert MobileNode.new(device_rating: 3, device_mode: MatrixNode::HIDDEN_MODE).hidden?
  end

  test '#hidden? returns false if the node is in active or passive mode' do
    [MatrixNode::ACTIVE_MODE, MatrixNode::PASSIVE_MODE].each do |device_mode|
      refute MobileNode.new(device_rating: 3, device_mode: device_mode).hidden?
    end
  end

  test '#subscriptions_to_self returns only subscriptions from other nodes to self' do
    node1 = MobileNode.new(device_rating: 3)
    node2 = MobileNode.new(device_rating: 3)
    node3 = MobileNode.new(device_rating: 3)

    node2.subscribe_to(node: node1)
    node1.subscribe_to(node: node3)
    assert_equal 1, node1.subscriptions_to_self.length
    assert_equal node2, node1.subscriptions_to_self[0].originating_node
  end

  test '#subscriptions_to_others returns only subscriptions to other nodes' do
    node1 = MobileNode.new(device_rating: 3)
    node2 = MobileNode.new(device_rating: 3)
    node3 = MobileNode.new(device_rating: 3)

    node2.subscribe_to(node: node1)
    node1.subscribe_to(node: node3)
    assert_equal 1, node1.subscriptions_to_others.length
    assert_equal node3, node1.subscriptions_to_others[0].destination_node
  end

  test '#hidden_accesses returns subscriptions to other nodes running in hidden mode' do
    node1 = MobileNode.new(device_rating: 3)
    node2 = MobileNode.new(device_rating: 3, device_mode: MatrixNode::HIDDEN_MODE)
    node3 = MobileNode.new(device_rating: 3)

    node1.subscribe_to(node: node2)
    node1.subscribe_to(node: node3)
    assert_equal 2, node1.subscriptions_to_others.length
    assert_equal node2, node1.hidden_accesses[0].destination_node
  end

  test '#subscribe_to raises AlreadySlavedError if the node is already slaved to another node' do
    node1 = MobileNode.new(device_rating: 3)
    node2 = MobileNode.new(device_rating: 3)
    node3 = MobileNode.new(device_rating: 3)

    node1.subscribe_to(node: node2, slaved: true)
    assert_raises MatrixNode::AlreadySlavedError do
      node1.subscribe_to(node: node3)
    end
  end

  test '#subscribe_to raises AlreadySubscribedError if subscribing to the same node again' do
    node1 = MobileNode.new(device_rating: 3)
    node2 = MobileNode.new(device_rating: 3)

    node1.subscribe_to(node: node2)
    assert_raises MatrixNode::AlreadySubscribedError  do
      node1.subscribe_to(node: node2)
    end
  end

  test '#subscribe_to adds the subscription to the orignating and destination node' do
    node1 = MobileNode.new(device_rating: 3)
    node2 = MobileNode.new(device_rating: 3)

    node1.subscribe_to(node: node2)
    assert_equal 1, node1.subscriptions_to_others.length
    assert_equal 1, node2.subscriptions_to_self.length
    assert_equal node1, node2.subscriptions_to_self[0].originating_node
    assert_equal node1, node1.subscriptions_to_others[0].originating_node
  end

  test '#user_programs_rating returns the sum of agents programs and deckers programs' do
    node1 = MobileNode.new(device_rating: 3)
    agent = AgentProgram.new(programs: [MatrixProgram.new(program_name: MatrixProgram::ATTACK, rating: 3)], pilot_rating: 3, home_node: node1)
    node1.agents << agent
    Decker.from_node(home_node: node1, programs: [MatrixProgram.new(program_name: MatrixProgram::ATTACK, rating: 3)], skills: [], attributes: [])

    assert_equal 6, node1.user_programs_rating
  end

  test '#user_programs_rating defaults to 0 for decker programs if there are none originating from that node' do
    node1 = MobileNode.new(device_rating: 3)
    agent = AgentProgram.new(programs: [MatrixProgram.new(program_name: MatrixProgram::ATTACK, rating: 3)], pilot_rating: 3, home_node: node1)
    node1.agents << agent

    assert_equal 3, node1.user_programs_rating
  end

  test '#user_programs_rating defaults to 0 for agent programs if there are none running on that node' do
    node1 = MobileNode.new(device_rating: 3)
    decker = Decker.from_node(home_node: node1, programs: [MatrixProgram.new(program_name: MatrixProgram::ATTACK, rating: 3)], skills: [], attributes: [])
    node1.decker = decker

    assert_equal 3, node1.user_programs_rating
  end

  test '#user_programs_rating properly sums the rating of all agent programs running on that node' do
    node1 = MobileNode.new(device_rating: 3)
    agent = AgentProgram.new(programs: [MatrixProgram.new(program_name: MatrixProgram::ATTACK, rating: 3)], pilot_rating: 3, home_node: node1)
    node1.agents << agent
    agent2 = AgentProgram.new(programs: [MatrixProgram.new(program_name: MatrixProgram::ATTACK, rating: 3)], pilot_rating: 3, home_node: node1)
    node1.agents << agent2

    assert_equal 6, node1.user_programs_rating
  end

  test '#get_device_rating returns the right response rating' do
    node1 = MobileNode.new(response: 5, device_rating: 3)
    assert_equal 5, node1.get_device_rating(DeviceAttribute::RESPONSE)
  end

  test '#get_device_rating returns the right signal rating' do
    node1 = MobileNode.new(signal: 5, device_rating: 3)
    assert_equal 5, node1.get_device_rating(DeviceAttribute::SIGNAL)
  end

  test '#get_device_rating returns the right system rating' do
    node1 = MobileNode.new(matrix_system: 5, device_rating: 3)
    assert_equal 5, node1.get_device_rating(DeviceAttribute::SYSTEM)
  end

  test '#get_device_rating returns the right firewall rating' do
    node1 = MobileNode.new(firewall: 5, device_rating: 3)
    assert_equal 5, node1.get_device_rating(DeviceAttribute::FIREWALL)
  end

  test '#get_device_rating returns nil if not one of the 4 device attributes' do
    node1 = MobileNode.new(device_rating: 3)
    assert_nil node1.get_device_rating('timmay')
  end

  test '#actual_device_rating returns the modified response if overloaded by running programs (MobileNode: 4x Response)' do
    node1 = MobileNode.new(device_rating: 1, programs: [MatrixProgram.new(program_name: 'abc', rating: 3)])
    assert_equal 1, node1.actual_device_rating(DeviceAttribute::RESPONSE)
    node1.programs << MatrixProgram.new(program_name: 'abc', rating: 3)
    assert_equal 6, node1.running_programs_rating
    assert_equal 0, node1.actual_device_rating(DeviceAttribute::RESPONSE)
  end

  test '#actual_device_rating returns the modified response if overloaded by running programs (DesktopNode: 6x Response)' do
    node1 = DesktopNode.new(device_rating: 1, programs: [MatrixProgram.new(program_name: 'abc', rating: 4)])
    assert_equal 1, node1.actual_device_rating(DeviceAttribute::RESPONSE)
    node1.programs << MatrixProgram.new(program_name: 'abc', rating: 4)
    assert_equal 8, node1.running_programs_rating
    assert_equal 0, node1.actual_device_rating(DeviceAttribute::RESPONSE)
  end

  test '#actual_device_rating returns the modified response if overloaded by running programs (NexusNode: 8x Response)' do
    node1 = NexusNode.new(device_rating: 1, programs: [MatrixProgram.new(program_name: 'abc', rating: 6)])
    assert_equal 1, node1.actual_device_rating(DeviceAttribute::RESPONSE)
    node1.programs << MatrixProgram.new(program_name: 'abc', rating: 6)
    assert_equal 12, node1.running_programs_rating
    assert_equal 0, node1.actual_device_rating(DeviceAttribute::RESPONSE)
  end

  test '#actual_device_rating returns the firewall with alert bonus when on full_alert' do
    node1 = MobileNode.new(device_rating: 1, alert_status: AlertStatus::FULL_ALERT)
    assert_equal 5, node1.actual_device_rating(DeviceAttribute::FIREWALL)
  end

  test '#actual_device_rating returns the system clamped by the response' do
    node1 = MobileNode.new(device_rating: 3, matrix_system: 5)
    assert_equal 5, node1.get_device_rating(DeviceAttribute::SYSTEM)
    assert_equal 3, node1.actual_device_rating(DeviceAttribute::SYSTEM)
  end
end
