require 'test_helper'

module PerceptionDataProvider
  class PerceptionDataProviderTest < ActiveSupport::TestCase
    test 'from_unkown_icon returns an UnkownIconProvider' do
      assert_instance_of PerceptionDataProvider::UnknownIconProvider, BaseProvider.from_unknown_icon({})
    end

    test 'from_matrix_object returns an AgentProvider if the object is an agent' do
      node1 = MobileNode.new(device_rating: 3)
      agent = AgentProgram.new(programs: [], pilot_rating: 3, home_node: node1)

      assert_instance_of PerceptionDataProvider::AgentProvider, BaseProvider.from_matrix_object(agent)
    end

    test 'from_matrix_object returns a DeckerProvider if the object is a Decker' do
      node1 = MobileNode.new(device_rating: 3)
      decker = Decker.from_node(home_node: node1, programs: [], skills: [], attributes: [])

      assert_instance_of PerceptionDataProvider::DeckerProvider, BaseProvider.from_matrix_object(decker)
    end

    test 'from_matrix_object returns a FileProvider if the object is a MatrixFile' do
      file = MatrixFile.new(file_content: 'Im a super fleshed out content', edit_date: Time.now.strftime('%F'))
      assert_instance_of PerceptionDataProvider::FileProvider, BaseProvider.from_matrix_object(file)
    end

    test 'from_matrix_object returns a MatrixNodeProvider if the object is a MatrixNode' do
      node = MobileNode.new(device_rating: 3)
      assert_instance_of PerceptionDataProvider::MatrixNodeProvider, BaseProvider.from_matrix_object(node)
    end

    test '#get_data with PerceptionData::ACCESS_ID returns the access_id of the agent or decker' do
      node1 = MobileNode.new(device_rating: 3)
      agent = AgentProgram.new(programs: [], pilot_rating: 3, home_node: node1)
      decker = Decker.from_node(home_node: node1, programs: [], skills: [], attributes: [])

      [agent, decker].each do |icon|
        provider = BaseProvider.from_matrix_object(icon)
        assert_equal icon.access_id, provider.get_data(PerceptionData::ACCESS_ID)
      end
    end

    test '#get_data with PerceptionData::MATRIX_DAMAGE returns the matrix damage taken of the agent or decker' do
      node1 = MobileNode.new(device_rating: 3)
      agent = AgentProgram.new(programs: [], pilot_rating: 3, home_node: node1)
      decker = Decker.from_node(home_node: node1, programs: [], skills: [], attributes: [])

      [agent, decker].each do |icon|
        provider = BaseProvider.from_matrix_object(icon)
        assert_equal 0, provider.get_data(PerceptionData::MATRIX_DAMAGE)
      end
    end

    test '#get_data with PerceptionData::RESPONSE_RATING returns the response of the node, agent, or decker' do
      node1 = MobileNode.new(device_rating: 3)
      agent = AgentProgram.new(programs: [], pilot_rating: 3, home_node: node1)
      decker = Decker.from_node(home_node: node1, programs: [], skills: [], attributes: { })

      [node1, agent, decker].each do |icon|
        provider = BaseProvider.from_matrix_object(icon)
        assert_equal 3, provider.get_data(PerceptionData::RESPONSE_RATING)
      end
    end

    test '#get_data with PerceptionData::PROGRAMS_RUNNING returns the running programs for agents, deckers or nodes' do
      node1 = MobileNode.new(device_rating: 3, programs: [MatrixProgram.new(program_name: MatrixProgram::ANALYZE, rating: 3)])
      agent = AgentProgram.new(programs: [MatrixProgram.new(program_name: MatrixProgram::ATTACK, rating: 3)], pilot_rating: 3, home_node: node1)
      decker = Decker.from_node(home_node: node1, programs: [MatrixProgram.new(program_name: MatrixProgram::STEALTH, rating: 3)], skills: [], attributes: [])

      [agent, decker].each do |icon|
        provider = BaseProvider.from_matrix_object(icon)
        assert_equal icon.programs, provider.get_data(PerceptionData::PROGRAMS_RUNNING)
      end
    end

    test '#get_data with PerceptionData::ALERT_STATUS returns the alert_status for a node' do
      node1 = MobileNode.new(device_rating: 3)

      provider = BaseProvider.from_matrix_object(node1)
      assert_equal AlertStatus::NO_ALERT, provider.get_data(PerceptionData::ALERT_STATUS)
    end

    test '#get_data with PerceptionData::HIDDEN_ACCESS returns the hidden_accesses for a node' do
      node1 = MobileNode.new(device_rating: 3)
      node2 = MobileNode.new(device_rating: 3, device_mode: MatrixNode::HIDDEN_MODE)
      node3 = MobileNode.new(device_rating: 3)

      node1.game_id = 1
      node2.game_id = 2
      node3.game_id = 3

      node1.subscribe_to(node: node2)
      node1.subscribe_to(node: node3)

      provider = BaseProvider.from_matrix_object(node1)
      assert_equal node1.hidden_accesses, provider.get_data(PerceptionData::HIDDEN_ACCESS)
    end

    test '#get_data with PerceptionData::EDIT_DATE returns the running programs for agents, deckers or nodes' do
      date = Time.now.strftime('%F')
      file = MatrixFile.new(file_content: 'Im a super fleshed out content', edit_date: date, encryption_rating: 3)

      provider = BaseProvider.from_matrix_object(file)
      assert_equal date, provider.get_data(PerceptionData::EDIT_DATE)
    end

    test '#get_data with PerceptionData::HAS_DATA_BOMB returns the running programs for agents, deckers or nodes' do
      file = MatrixFile.new(file_content: 'Im a super fleshed out content', edit_date: Time.now.strftime('%F'), data_bomb_rating: 3)

      provider = BaseProvider.from_matrix_object(file)
      assert provider.get_data(PerceptionData::HAS_DATA_BOMB)
    end
  end
end
