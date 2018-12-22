require 'test_helper'

module PerceptionDataProvider
  class DeckerProviderTest < ActiveSupport::TestCase
    test '#available_data_pieces returns the supported data for a decker(persona) icon' do
      expected_data = [
        PerceptionData::ACCESS_ID,
        PerceptionData::MATRIX_DAMAGE,
        PerceptionData::MATRIX_ATTRIBUTE_RATING,
        PerceptionData::PROGRAMS_RUNNING,
        PerceptionData::TRACE_RUNNING,
      ]

      node = MobileNode.new(device_rating: 3)
      decker = Decker.from_node(home_node: node, programs: [], skills: [], attributes: [])

      assert_equal expected_data, DeckerProvider.new(decker).available_data_pieces
    end
  end
end
