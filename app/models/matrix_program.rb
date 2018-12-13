class MatrixProgram
  ANALZYE = 'analyze'
  BROWSE = 'browse'
  DECRYPT = 'decrypt'
  ECCM = 'electronic-counter-counter-measure'
  EDIT = 'edit'
  ENCRYPT = 'encrypt'
  EXPLOIT = 'exploit'
  SNIFFER = 'sniffer'
  STEALTH = 'stealth'

  attr_accessor :rating, :program_name

  def initialize(rating:, program_name:, loaded: false)
    @rating = rating
    @program_name = program_name
  end
end
