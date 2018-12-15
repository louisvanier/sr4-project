class DiceRoller
  class << self
    def standard_roll(dice_pool:)
      dice_roll = DiceRoller.new(dice_pool: dice_pool)
      dice_roll.results = dice_roll.roll_dices.sort
      dice_roll
    end

    def roll_with_edge_prior(dice_pool:)
      dice_roll = DiceRoller.new(dice_pool: dice_pool, used_edge: true)
      dice_roll.roll_exploding_dices(dice_pool)
      dice_roll.results = dice_roll.results.sort
      dice_roll.edge_results = dice_roll.edge_results.sort
      dice_roll
    end

    def roll_with_edge_after(early_results:, edge_pool:)
      dice_roll = DiceRoller.new(dice_pool: early_results.length + edge_pool, early_results: early_results, used_edge: true)
      dice_roll.roll_exploding_dices(use_edge_prior)
      dice_roll.results = dice_roll.results.sort
      dice_roll.edge_results = dice_roll.edge_results.sort
      dice_roll
    end

    def edge_reroll(early_results:)
      dice_roll = DiceRoller.new(dice_pool: early_results.count { |dice| dice < 5 }, early_results: early_results, used_edge: true)
      dice_roll.results = early_results.select { |dice| dice > 4 }.concat(dice_roll.roll_dices).sort
      dice_roll.edge_results = dice_roll.edge_results.sort
      dice_roll
    end
  end

  attr_accessor :results, :edge_results, :used_edge

  def initialize(dice_pool:, early_results: [], used_edge: false)
    @dice_pool = dice_pool
    @results = early_results
    @used_edge = used_edge
    @random_generator = Random.new
    @edge_results = []
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

  def glitch?
    @results.count(1) >= @dice_pool / 2
  end

  def critical_glitch?
    glitch? && @results.count { |dice| dice > 4 } == 0
  end

  def successes
    @results.concat(@edge_results).count { |dice| dice > 4 }
  end
end
