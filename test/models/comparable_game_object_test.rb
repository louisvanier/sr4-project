require 'test_helper'

class ComparableGameObjectTest < ActiveSupport::TestCase
  test '#== returns true if the game object is of the same class and has the same game_id' do
    matrix_program_1 = MatrixProgram.new(rating: 5, program_name: MatrixProgram::ATTACK)
    matrix_program_1.game_id = 6
    matrix_program_2 = MatrixProgram.new(rating: 2, program_name: MatrixProgram::ATTACK)
    matrix_program_2.game_id = 6

    assert matrix_program_1 == matrix_program_2
  end
end
