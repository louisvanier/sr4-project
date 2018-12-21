require 'test_helper'

class DiceRollTest < ActiveSupport::TestCase
  test 'self.standard_roll returns false for used_edge' do
    roll = DiceRoll.standard_roll(dice_pool: 6)
    refute roll.used_edge
  end

  test 'self.roll_with_edge_prior returns true for used_edge' do
    roll = DiceRoll.roll_with_edge_prior(dice_pool: 6)
    assert roll.used_edge
  end

  test 'self.roll_with_edge_after returns true for used_edge' do
    roll = DiceRoll.roll_with_edge_after(original_dice_roll: DiceRoll.standard_roll(dice_pool: 6), edge_pool: 6)
    assert roll.used_edge
  end

  test 'self.edge_reroll returns true for used_edge' do
    roll = DiceRoll.edge_reroll(original_dice_roll: DiceRoll.standard_roll(dice_pool: 6))
    assert roll.used_edge
  end

  test 'self.roll_with_edge_after raises an AlreadyEdgedError if the original roll used edge' do
    assert_raises DiceRoll::AlreadyEdgedError do
      DiceRoll.roll_with_edge_after(original_dice_roll: DiceRoll.roll_with_edge_prior(dice_pool: 6), edge_pool: 6)
    end
  end

  test 'self.edge_reroll raises an AlreadyEdgedError if the original roll used edge' do
    assert_raises DiceRoll::AlreadyEdgedError do
      DiceRoll.edge_reroll(original_dice_roll: DiceRoll.roll_with_edge_prior(dice_pool: 6))
    end
  end

  test '#glitch? returns true if the number of 1 in the results array is >= to half of the dice pool' do
    roll = DiceRoll.standard_roll(dice_pool: 6)
    [3, 4, 5, 6].each do |number_of_1s|
      roll.results = (1..number_of_1s).map { |n| 1 }.concat((6-number_of_1s..6).map { |n| 6 })
      assert roll.glitch?
    end
  end

  test '#critical_glitch? returns true if the number of 1 in the results array is >= to half of the dice pool and there are no 5 and 6' do
    roll = DiceRoll.standard_roll(dice_pool: 6)
    [3, 4, 5, 6].each do |number_of_1s|
      roll.results = (1..number_of_1s).map { |n| 1 }.concat((6-number_of_1s..6).map { |n| 4 })
      assert roll.critical_glitch?
    end
  end

  test '#critical_glitch? returns false if the number of 1 in the results array is >= to half of the dice pool and the 5 and 6 are only in the edge results' do
    roll = DiceRoll.standard_roll(dice_pool: 6)
    [3, 4, 5, 6].each do |number_of_1s|
      roll.results = (1..number_of_1s).map { |n| 1 }.concat((6-number_of_1s..6).map { |n| 4 })
      roll.edge_results = [6]
      refute roll.critical_glitch?
    end
  end

  test '#successes counts the number of 5 && 6 in the results array' do
    roll = DiceRoll.standard_roll(dice_pool: 6)
    roll.results = [3,3,3,4,5,6]
    assert_equal 2, roll.successes
  end

  test '#successes counts the number of 5 && 6 in the results array && in the edge_results array' do
    roll = DiceRoll.standard_roll(dice_pool: 6)
    roll.results = [3,3,3,4,5,6]
    roll.edge_results = [5,6]
    assert_equal 4, roll.successes
  end
end
