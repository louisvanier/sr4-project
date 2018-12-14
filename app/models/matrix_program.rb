class MatrixProgram
  ANALZYE = 'analyze'
  ATTACk = 'attack'
  BIOFEEDBACK_FILTER = 'biofeedback-filter'
  BLACKOUT = 'blackout'
  BLACK_HAMMER = 'black-hammer'
  BROWSE = 'browse'
  DECRYPT = 'decrypt'
  ECCM = 'electronic-counter-counter-measure'
  EDIT = 'edit'
  ENCRYPT = 'encrypt'
  EXPLOIT = 'exploit'
  SNIFFER = 'sniffer'
  STEALTH = 'stealth'

  attr_accessor :rating, :program_name

  def initialize(rating:, program_name:)
    @rating = rating
    @program_name = program_name
  end

  def black_IC?
    return true if [BLACKOUT, BLACK_HAMMER].include?(@program_name)
  end
end
