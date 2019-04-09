require 'test_helper'

class NodeSubscriptionTest < ActiveSupport::TestCase
  setup do
    @node1 = MobileNode.new(device_rating: 3)
    @node2 = MobileNode.new(device_rating: 3)
    @persona = Decker.from_node(home_node: @node1, attributes: {}, skills: {})
  end

  test 'from_node creates a subscription without a decker' do
    subscription = NodeSubscription.from_node(node: @node1, destination_node: @node2)
    assert_nil subscription.persona
  end

  test 'from_persona creates a subscription without an originating_node' do
    subscription = NodeSubscription.from_persona(decker: @persona, destination_node: @node2)
    assert_nil subscription.originating_node
  end

  test '#hidden_access returns false for persona subscriptions even if destination_node is hidden' do
    hidden_node = MobileNode.new(device_rating: 3, device_mode: MatrixNode::HIDDEN_MODE)
    subscription = NodeSubscription.from_persona(decker: @persona, destination_node: hidden_node)
    refute subscription.hidden_access?
  end

  test '#hidden_access returns false if the destination_node is not running in access_mode' do
    subscription = NodeSubscription.from_node(node: @node1, destination_node: @node2)
    assert_not_equal MatrixNode::HIDDEN_MODE, @node2.device_mode
    refute subscription.hidden_access?
  end

  test '#hidden_access returns true for node subscriptions to a destination_node running in hidden mode' do
    hidden_node = MobileNode.new(device_rating: 3, device_mode: MatrixNode::HIDDEN_MODE)
    subscription = NodeSubscription.from_node(node: @node1, destination_node: hidden_node)
    assert subscription.hidden_access?
  end

  test 'setting game_id once it is not nil raises an error' do
    subscription = NodeSubscription.from_node(node: @node1, destination_node: @node2)
    subscription.game_id = 1
    assert_raises Exception do
      subscription.game_id = 2
    end
    assert_equal 1, subscription.game_id
  end

  test '#as_json serializes only the nodes game_id' do
    @node1.expects(game_id: 1)
    @node2.expects(game_id: 2)
    subscription = NodeSubscription.from_node(node: @node1, destination_node: @node2)
    json_result = JSON.parse(subscription.to_json)
    assert_equal 1, json_result['originating_node']
    assert_equal 2, json_result['destination_node']
  end

  test '#as_json serializes null for the persona when its a node to node subscription' do
    subscription = NodeSubscription.from_node(node: @node1, destination_node: @node2)
    json_result = JSON.parse(subscription.to_json)
    assert json_result.keys.any? { |key| key == 'persona' }
    assert_nil json_result['persona']
  end

  test '#as_json serializes only the persona game_id' do
    @persona.expects(game_id: 1)
    subscription = NodeSubscription.from_persona(decker: @persona, destination_node: @node2)
    json_result = JSON.parse(subscription.to_json)
    assert_equal 1, json_result['persona']
  end

  test '#as_json serializes null for the originating_node when its a persona subscription' do
    subscription = NodeSubscription.from_persona(decker: @persona, destination_node: @node2)
    json_result = JSON.parse(subscription.to_json)
    assert json_result.keys.any? { |key| key == 'originating_node' }
    assert_nil json_result['originating_node']
  end
end
