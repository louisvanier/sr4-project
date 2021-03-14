require 'test_helper'

class GameStateTest < ActiveSupport::TestCase
  test '#add_node adds it to the list of nodes' do
    state = GameState.new
    node = MobileNode.new(device_rating: 3)

    assert_equal 0, state.nodes.size
    state.add_node(node)
    assert_equal 1, state.nodes.size
  end

  test '#add_node sets a game_id to the node and all of its icons' do
    state = GameState.new

    analyze = MatrixProgram.new(program_name: MatrixProgram::ANALYZE, rating: 2)
    stealth = MatrixProgram.new(program_name: MatrixProgram::STEALTH, rating: 2)
    node = MobileNode.new(device_rating: 3, programs: [analyze, stealth])

    state.add_node(node)

    assert_not_nil node.game_id
    assert node.icons.size > 0
    node.icons.each do |icon|
      assert_not_nil icon.game_id
    end
  end

  test '#add_persona adds it to the list of personas' do
    state = GameState.new

    node = MobileNode.new(device_rating: 3)
    decker = Decker.from_node(home_node: node, skills: {}, attributes: {}, programs: [])

    assert_equal 0, state.personas.size
    state.add_persona(persona: decker)
    assert_equal 1, state.personas.size
  end

  test '#add_persona sets a game_id to it, its programs and its subscriptions' do
    state = GameState.new

    node = MobileNode.new(device_rating: 3)
    analyze = MatrixProgram.new(program_name: MatrixProgram::ANALYZE, rating: 2)
    stealth = MatrixProgram.new(program_name: MatrixProgram::STEALTH, rating: 2)
    decker = Decker.from_node(home_node: node, skills: {}, attributes: {}, programs: [analyze, stealth])

    state.add_persona(persona: decker)

    assert_not_nil decker.game_id
    assert decker.programs.size > 0
    decker.programs.each do |prog|
      assert_not_nil prog.game_id
    end
  end

  test '#add_persona sets its known_data' do
    state = GameState.new

    node = MobileNode.new(device_rating: 3)
    decker = Decker.from_node(home_node: node, skills: {}, attributes: {}, programs: [])
    other_node = DesktopNode.new(device_rating: 3)

    state.add_node(other_node)
    state.add_persona(persona: decker, known_data: { other_node => [PerceptionData::RESPONSE_RATING, PerceptionData::SIGNAL_RATING]})

    assert_equal({ other_node => [PerceptionData::RESPONSE_RATING, PerceptionData::SIGNAL_RATING] }, state.known_data_pieces[decker])
  end

  test '#add_player adds it to the list of player personas' do
    state = GameState.new

    node = MobileNode.new(device_rating: 3)
    decker = Decker.from_node(home_node: node, skills: {}, attributes: {}, programs: [])

    assert_equal 0, state.personas.size
    state.add_player(decker)
    assert_equal 1, state.player_personas.size
  end

  test '#add_player sets a game_id to it and its programs' do
    state = GameState.new

    node = MobileNode.new(device_rating: 3)
    analyze = MatrixProgram.new(program_name: MatrixProgram::ANALYZE, rating: 2)
    stealth = MatrixProgram.new(program_name: MatrixProgram::STEALTH, rating: 2)
    decker = Decker.from_node(home_node: node, skills: {}, attributes: {}, programs: [analyze, stealth])

    state.add_player(decker)

    assert_not_nil decker.game_id
    assert decker.programs.size > 0
    decker.programs.each do |prog|
      assert_not_nil prog.game_id
    end
  end

  test '#add_player sets its known_data' do
    state = GameState.new

    node = MobileNode.new(device_rating: 3)
    decker = Decker.from_node(home_node: node, skills: {}, attributes: {}, programs: [])
    other_node = DesktopNode.new(device_rating: 3)

    state.add_node(other_node)
    state.add_player(decker, known_data: { other_node => [PerceptionData::RESPONSE_RATING, PerceptionData::SIGNAL_RATING]})

    assert_equal({ other_node => [PerceptionData::RESPONSE_RATING, PerceptionData::SIGNAL_RATING] }, state.known_data_pieces[decker])
  end

  test '#available_nodes returns nodes present in, nodes subscribed to & nodes current node is subscribed to' do
    node = MobileNode.new(device_rating: 3)

    node_connected_to = MobileNode.new(device_rating: 3)
    node_connected_to.subscribe_to(node: node)

    node_subscribed_to = MobileNode.new(device_rating: 3)
    node.subscribe_to(node: node_subscribed_to)

    decker = Decker.from_node(home_node: node, skills: {}, attributes: {}, programs: [])
    state = GameState.new

    state.add_node(node)
    state.add_node(node_connected_to)
    state.add_node(node_subscribed_to)

    state.add_persona(persona: decker)

    state.set_current_actor_by_game_id(decker.game_id)

    assert_equal(Set.new([node, node_connected_to, node_subscribed_to]), Set.new(state.available_nodes))
  end

  test '#available_nodes ignores hidden access nodes' do
    node = MobileNode.new(device_rating: 3)

    node_connected_to = MobileNode.new(device_rating: 3)
    node_connected_to.subscribe_to(node: node)

    hidden_node = MobileNode.new(device_rating: 3, device_mode: MatrixNode::HIDDEN_MODE)
    node.subscribe_to(node: hidden_node)

    decker = Decker.from_node(home_node: node, skills: {}, attributes: {}, programs: [])
    state = GameState.new

    state.add_node(node)
    state.add_node(node_connected_to)
    state.add_node(hidden_node)

    state.add_persona(persona: decker)

    state.set_current_actor_by_game_id(decker.game_id)

    assert_equal(Set.new([node, node_connected_to]), Set.new(state.available_nodes))
  end

  test '#set_current_actor_by_game_id sets the selected actor' do
    state = GameState.new

    node = MobileNode.new(device_rating: 3)
    decker = Decker.from_node(home_node: node, skills: {}, attributes: {}, programs: [])

    state.add_player(decker)
    state.set_current_actor_by_game_id(decker.game_id)
    assert_equal decker, state.current_actor
  end
end
