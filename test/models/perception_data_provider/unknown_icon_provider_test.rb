require 'test_helper'

module PerceptionDataProvider
  class UnknownIconProviderTest < ActiveSupport::TestCase
    test '#available_data_pieces returns the supported data for an unknown icon' do
      expected_data = [
        PerceptionData::ICON_TYPE
      ]

      file = MatrixFile.new(file_content: 'Im a super fleshed out content', edit_date: Time.now.strftime('%F'))

      assert_equal expected_data, UnknownIconProvider.new(file).available_data_pieces
    end
  end
end
