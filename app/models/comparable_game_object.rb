module ComparableGameObject
  def ==(o)
    o.class == self.class && o.game_id == game_id
  end
end
