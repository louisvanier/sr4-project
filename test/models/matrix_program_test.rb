require 'test_helper'

class MatrixProgramTest < ActiveSupport::TestCase
  test '#black_IC? returns true for blackout' do
    assert MatrixProgram.new(program_name: MatrixProgram::BLACKOUT, rating: 1).black_IC?
  end

  test '#black_IC? returns true for black-hammer' do
    assert MatrixProgram.new(program_name: MatrixProgram::BLACK_HAMMER, rating: 1).black_IC?
  end

  test '#black_IC? returns false for all programs that are not black-hammer or blackout' do
    [
      MatrixProgram::ANALYZE,
      MatrixProgram::ATTACK,
      MatrixProgram::BIOFEEDBACK_FILTER,
      MatrixProgram::BROWSE,
      MatrixProgram::DECRYPT,
      MatrixProgram::ECCM,
      MatrixProgram::EDIT,
      MatrixProgram::ENCRYPT,
      MatrixProgram::EXPLOIT,
      MatrixProgram::SNIFFER,
      MatrixProgram::STEALTH,
    ].each do |program_name|
      refute MatrixProgram.new(program_name: program_name, rating: 1).black_IC?
    end
  end

  test '#damage_type returns matrix-damage for ATTACK' do
    assert_equal MatrixProgram::MATRIX_DAMAGE, MatrixProgram.new(program_name: MatrixProgram::ATTACK, rating: 1).damage_type
  end

  test '#damage_type returns stun-damage for BLACKOUT' do
    assert_equal MatrixProgram::STUN_DAMAGE, MatrixProgram.new(program_name: MatrixProgram::BLACKOUT, rating: 1).damage_type
  end

  test '#damage_type returns physical-damage for BLACK_HAMMER' do
    assert_equal MatrixProgram::PHYSICAL_DAMAGE, MatrixProgram.new(program_name: MatrixProgram::BLACK_HAMMER, rating: 1).damage_type
  end

  test '#damage_type returns nil for non-attack programs' do
    [
      MatrixProgram::ANALYZE,
      MatrixProgram::BIOFEEDBACK_FILTER,
      MatrixProgram::BROWSE,
      MatrixProgram::DECRYPT,
      MatrixProgram::ECCM,
      MatrixProgram::EDIT,
      MatrixProgram::ENCRYPT,
      MatrixProgram::EXPLOIT,
      MatrixProgram::SNIFFER,
      MatrixProgram::STEALTH,
    ].each do |program_name|
      assert_nil MatrixProgram.new(program_name: program_name, rating: 1).damage_type
    end
  end

  test 'setting game_id once it is not nil raises an error' do
    program = MatrixProgram.new(program_name: MatrixProgram::BLACKOUT, rating: 1)
    program.game_id = 1
    assert_raises Exception do
      program.game_id = 2
    end
    assert_equal 1, program.game_id
  end
end
