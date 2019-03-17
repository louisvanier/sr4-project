class MatrixProgram
  ANALYZE = 'analyze'
  ARMOR = 'analyze'
  ATTACK = 'attack'
  BIOFEEDBACK_FILTER = 'biofeedback-filter'
  BLACKOUT = 'blackout'
  BLACK_HAMMER = 'black-hammer'
  BROWSE = 'browse'
  DECRYPT = 'decrypt'
  DEFUSE = 'defuse'
  ECCM = 'electronic-counter-counter-measure'
  EDIT = 'edit'
  ENCRYPT = 'encrypt'
  EXPLOIT = 'exploit'
  SCAN = 'scan'
  SNIFFER = 'sniffer'
  STEALTH = 'stealth'

  MATRIX_DAMAGE = 'matrix-damage'
  STUN_DAMAGE = 'stun-damage'
  PHYSICAL_DAMAGE = 'physical-damage'

  attr_accessor :rating, :program_name

  attr_reader :game_id

  def initialize(rating:, program_name:)
    @rating = rating
    @program_name = program_name
  end

  def game_id=(value)
    raise Exception unless game_id.nil?
    @game_id = value
  end

  def black_IC?
    return true if [BLACKOUT, BLACK_HAMMER].include?(@program_name)
  end

  def damage_type
    return MATRIX_DAMAGE if @program_name == ATTACK
    return STUN_DAMAGE if @program_name == BLACKOUT
    return PHYSICAL_DAMAGE if @program_name == BLACK_HAMMER
    nil
  end

  def as_json
    {
      game_id: game_id,
      rating: rating,
      program_name: program_name,
    }
  end
end
