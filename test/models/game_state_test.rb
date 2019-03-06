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
  end

  test '#add_persona sets a game_id to it and its programs' do
  end

  test '#add_persona sets its known_data' do
  end

  test '#add_player adds it to the list of player personas' do

  end

  test '#add_player sets a game_id to it and its programs' do
  end

  test '#add_player sets its known_data' do
  end
end
