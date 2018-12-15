require 'test_helper'

class MatrixFiletest < ActiveSupport::TestCase
  test '#has_data_bomb? returns true for any data_bomb_rating > 0' do
    [1, 6, 99].each do |rating|
      assert MatrixFile.new(file_content: '', edit_date: '', data_bomb_rating: rating).has_data_bomb?
    end
  end
end
