require 'test_helper'

module PerceptionDataProvider
  class FileProviderTest < ActiveSupport::TestCase
    test '#available_data_pieces returns the supported data for a file icon' do
      expected_data = [
        PerceptionData::EDIT_DATE,
        PerceptionData::HAS_DATA_BOMB,
      ]

      file = MatrixFile.new(file_content: 'Im a super fleshed out content', edit_date: Time.now.strftime('%F'))

      assert_equal expected_data, FileProvider.new(file).available_data_pieces
    end
  end
end
