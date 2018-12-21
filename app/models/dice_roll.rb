class DiceRoll
  class AlreadyEdgedError < StandardError; end
  class << self
    def standard_roll(dice_pool:)
      dice_roll = DiceRoll.new(dice_pool: dice_pool)
      dice_roll.results = dice_roll.roll_dices.sort
      dice_roll
    end

    def roll_with_edge_prior(dice_pool:)
      dice_roll = DiceRoll.new(dice_pool: dice_pool, used_edge: true)
      dice_roll.roll_exploding_dices(dice_pool)
      dice_roll.results = dice_roll.results.sort
      dice_roll.edge_results = dice_roll.edge_results.sort
      dice_roll
    end

    def roll_with_edge_after(original_dice_roll:, edge_pool:)
      raise AlreadyEdgedError if original_dice_roll.used_edge
      dice_roll = DiceRoll.new(dice_pool: original_dice_roll.results.length + edge_pool, original_results: original_dice_roll.results, used_edge: true)
      dice_roll.roll_exploding_dices(edge_pool)
      dice_roll.results = dice_roll.results.sort
      dice_roll.edge_results = dice_roll.edge_results.sort
      dice_roll
    end

    def edge_reroll(original_dice_roll:)
      raise AlreadyEdgedError if original_dice_roll.used_edge
      dice_roll = DiceRoll.new(dice_pool: original_dice_roll.results.count { |dice| dice < 5 }, original_results: original_dice_roll.results, used_edge: true)
      dice_roll.results = original_dice_roll.results.select { |dice| dice > 4 }.concat(dice_roll.roll_dices).sort
      dice_roll.edge_results = dice_roll.edge_results.sort
      dice_roll
    end
  end

  attr_accessor :results, :edge_results
  attr_reader :used_edge

  def initialize(dice_pool:, original_results: [], used_edge: false)
    @dice_pool = dice_pool
    @results = original_results
    @used_edge = used_edge
    @random_generator = Random.new
    @edge_results = []
  end

  def glitch?
    @results.count(1) >= @dice_pool / 2
  end

  def critical_glitch?
    glitch? && successes == 0
  end

  def successes
    @results.concat(@edge_results).count { |dice| dice > 4 }
  end

  def roll_exploding_dices(exploding_dice_pool)
    current_pool = exploding_dice_pool
    results = []
    while current_pool > 0 && result = roll_dices(current_pool) do
      @results.concat(result) if current_pool == exploding_dice_pool
      @edge_results.concat(result.select { |dice| dice == 5 || dice == 6 }) unless current_pool == exploding_dice_pool
      current_pool = result.count(6)
    end
  end

  def roll_dices(dice_pool = @dice_pool)
    (1..@dice_pool).map { |value| @random_generator.rand(6) + 1 }
  end
end
