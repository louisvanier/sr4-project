require 'test_helper'

class MatrixFiletest < ActiveSupport::TestCase
  test '#has_data_bomb? returns true for any data_bomb_rating > 0' do
    [1, 6, 99].each do |rating|
      assert MatrixFile.new(file_content: '', edit_date: '', data_bomb_rating: rating).has_data_bomb?
    end
  end

  test 'setting game_id once it is not nil raises an error' do
    file = MatrixFile.new(file_content: '', edit_date: '', data_bomb_rating: 0)
    file.game_id = 1
    assert_raises Exception do
      file.game_id = 2
    end
    assert_equal 1, file.game_id
  end
end
