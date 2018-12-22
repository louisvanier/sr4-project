class PerceptionData
  class UnavailableDataError < StandardError; end
  ICON_TYPE = 'icon-type'
  ACCESS_ID = 'access-ID'
  ALERT_STATUS = 'alert-status'
  EDIT_DATE = 'edit-date'
  HIDDEN_ACCESS = 'hidden-access'
  MATRIX_DAMAGE = 'matrix-damage'
  HAS_DATA_BOMB = 'has-data-bomb'
  PROGRAMS_RUNNING = 'programs-running '
  MATRIX_ATTRIBUTE_RATING = 'matrix-attribute-rating'
  DECRYPTED = 'decrypted'
  TRACE_RUNNING = 'trace-running'

  attr_reader :matrix_object, :available_data_pieces

  def get_data(data_type, arg)
    raise UnavailableDataError unless @available_data_pieces.include?(data_type)
    @data_provider.get_data(data_type, arg)
  end

  class << self
    def from_known_data(matrix_object:, known_data: [])
      unless known_data.include?(ICON_TYPE)
        return from_unkown_icon(matrix_object)
      end

      from_matrix_object(matrix_object)
    end

    private

    def from_unkown_icon(matrix_object)
      PerceptionData.new(matrix_object, [ICON_TYPE], PerceptionDataProvider::BaseProvider.from_unknown_icon(matrix_object))
    end

    def from_matrix_object(matrix_object)
      PerceptionData.new(matrix_object, nil, PerceptionDataProvider::BaseProvider.from_matrix_object(matrix_object))
    end
  end

  private

  def initialize(matrix_object, available_data_pieces, data_provider)
    @matrix_object = matrix_object
    @data_provider = data_provider
    @available_data_pieces = available_data_pieces || data_provider.available_data_pieces
  end
end
