require 'test_helper'

module PerceptionDataProvider
  class AgentProviderTest < ActiveSupport::TestCase
    test '#available_data_pieces returns the supported data for an agent icon' do
      expected_data = [
        PerceptionData::ACCESS_ID,
        PerceptionData::MATRIX_DAMAGE,
        PerceptionData::RESPONSE_RATING,
        PerceptionData::SYSTEM_RATING,
        PerceptionData::FIREWALL_RATING,
        PerceptionData::SIGNAL_RATING,
        PerceptionData::PROGRAMS_RUNNING,
        PerceptionData::TRACE_RUNNING,
      ]

      node = MobileNode.new(device_rating: 3)
      agent = AgentProgram.new(programs: [], pilot_rating: 3, home_node: node)

      assert_equal expected_data, AgentProvider.new(agent).available_data_pieces
    end
  end
end
