require 'test_helper'

class PerceptionDataTest < ActiveSupport::TestCase
  test 'available_data_pieces returns only ICON_TYPE if it is not part of known data' do
    node = MobileNode.new(device_rating: 3)
    assert_equal [PerceptionData::ICON_TYPE], PerceptionData.from_known_data(matrix_object: node).available_data_pieces
  end
end
