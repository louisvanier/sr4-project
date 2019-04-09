class MatrixFile
  include Encryptable
  include ComparableGameObject

  attr_accessor :file_content, :edit_date, :encryption_rating, :data_bomb_rating, :node

  attr_reader :game_id

  def initialize(file_content:, edit_date:, encryption_rating: 0, data_bomb_rating: 0)
    @file_content = file_content
    @edit_date = edit_date
    @encryption_rating = encryption_rating
    @data_bomb_rating = data_bomb_rating
  end

  def game_id=(value)
    raise Exception unless game_id.nil?
    @game_id = value
  end

  def has_data_bomb?
    data_bomb_rating > 0
  end

  def as_json(_options)
    {
      game_id: game_id,
      edit_date: edit_date,
      encryption_rating: encryption_rating,
      data_bomb_rating: data_bomb_rating,
    }
  end
end
