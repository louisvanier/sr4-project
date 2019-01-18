class MatrixFile
  include Encryptable

  attr_accessor :file_content, :edit_date, :encryption_rating, :data_bomb_rating, :node

  def initialize(file_content:, edit_date:, encryption_rating: 0, data_bomb_rating: 0)
    @file_content = file_content
    @edit_date = edit_date
    @encryption_rating = encryption_rating
    @data_bomb_rating = data_bomb_rating
  end

  def has_data_bomb?
    data_bomb_rating > 0
  end
end
