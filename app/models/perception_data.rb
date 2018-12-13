class PerceptionData
  NODE_TYPE = 'node-type'
  ACCESS_ID = 'access-ID'
  ALERT_STATUS = 'alert-status'
  EDIT_DATE = 'edit-date'
  HIDDEN_ACCESS = 'hidden-access'
  MATRIX_DAMAGE = 'matrix-damage'
  HAS_DATA_BOMB = 'has-data-bomb'
  PROGRAMS_LOADED = 'programs-loaded'
  MATRIX_ATTRIBUTE_RATING = 'matrix-attribute-rating'
  IS_ENCRYPTED = 'encryption-status'
  TRACE_RUNNING = 'trace-running'

  attr_reader :matrix_object, :available_data_pieces

  def identify_icon
    @available_data_pieces = get_available_data_pieces
    @matrix_object.class.name
  end

  class << self
    def from_unkown_icon(matrix_object)
      PerceptionData.new(@matrix_object, [NODE_TYPE])
    end
  end

  private

  def initialize(matrix_object, available_data_pieces)
    @matrix_object = matrix_object
    @available_data_pieces = available_data_pieces
  end

  def get_available_data_pieces
    PerceptionDataProvider.from_matrix_object(@matrix_object).available_data_pieces
  end
end
