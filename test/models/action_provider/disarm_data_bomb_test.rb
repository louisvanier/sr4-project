require 'test_helper'

module ActionProvider
  class DisarmDataBombTest < ActiveSupport::TestCase
    setup do
      @home_node = MobileNode.new(device_rating: 4)
      @defuse = MatrixProgram.new(program_name: MatrixProgram::DEFUSE, rating: 4)
      decker_skills = {
        Skills::CYBERCOMBAT => 4,
        Skills::HACKING => 4
      }

      decker_attributes = {
        Attributes::LOGIC => 5
      }

      @decker = Decker.from_node(
        home_node: @home_node,
        programs: [@defuse],
        skills: decker_skills,
        attributes: decker_attributes
      )

      @known_data = {
        @decker => {}
      }
      @game_state = MockState.new(@decker, @known_data, [@home_node])
    end

    test '#actions returns [] unless the current_actor is running a defuse program' do
      @decker.stubs(programs: [])
      assert_empty ActionProvider::DisarmDataBomb.new(game_state: @game_state).actions
    end

    test '#actions returns [] unless the current_actor has any knowledge of a databomb' do
      assert_empty ActionProvider::DisarmDataBomb.new(game_state: @game_state).actions
    end

    test '#actions returns [] if the actor knows about data bombs in nodes he is not present in' do
      file1 = MatrixFile.new(file_content: 'Im a super fleshed out content', edit_date: Time.now.strftime('%F'), data_bomb_rating: 4)
      file2 = MatrixFile.new(file_content: 'Im a super fleshed out content', edit_date: Time.now.strftime('%F'), data_bomb_rating: 2)
      file3 = MatrixFile.new(file_content: 'Im a super fleshed out content', edit_date: Time.now.strftime('%F'))

      other_node = DesktopNode.new(device_rating: 4, files: [file1, file2, file3])
      game_state = MockState.new(@decker, @known_data, [@home_node, other_node])
      assert_empty ActionProvider::DisarmDataBomb.new(game_state: @game_state).actions
    end

    test '#actions returns 1 element per known data bombs in nodes he is present in' do
      file1 = MatrixFile.new(file_content: 'Im a super fleshed out content', edit_date: Time.now.strftime('%F'), data_bomb_rating: 4)
      file2 = MatrixFile.new(file_content: 'Im a super fleshed out content', edit_date: Time.now.strftime('%F'), data_bomb_rating: 2)
      file3 = MatrixFile.new(file_content: 'Im a super fleshed out content', edit_date: Time.now.strftime('%F'))
      known_data = {
        @decker => {
          file1 => [PerceptionData::HAS_DATA_BOMB],
          file2 => [PerceptionData::HAS_DATA_BOMB],
          file3 => []
        }
      }

      other_node = DesktopNode.new(device_rating: 4, files: [file1, file2, file3])
      game_state = MockState.new(@decker, known_data, [@home_node, other_node])
      @decker.subscribe_to(node: other_node)
      actions = ActionProvider::DisarmDataBomb.new(game_state: game_state).actions
      @decker.unsubscribe_to(node: other_node)

      assert_equal 2, actions.length
    end
  end
end
