require 'test_helper'

module PerceptionDataProvider
  class MatrixNodeProviderTest < ActiveSupport::TestCase
    test '#available_data_pieces returns the supported data for matrix node' do
      expected_data = [
        PerceptionData::ALERT_STATUS,
        PerceptionData::HIDDEN_ACCESS,
        PerceptionData::PROGRAMS_RUNNING,
        PerceptionData::RESPONSE_RATING,
        PerceptionData::SYSTEM_RATING,
        PerceptionData::FIREWALL_RATING,
        PerceptionData::SIGNAL_RATING,
      ]

      node = MobileNode.new(device_rating: 3)

      assert_equal expected_data, MatrixNodeProvider.new(node).available_data_pieces
    end
  end
end
