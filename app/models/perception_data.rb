class PerceptionData
  class UnavailableDataError < StandardError; end
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
  DECRYPTED = 'decrypted'
  TRACE_RUNNING = 'trace-running'

  attr_reader :matrix_object, :available_data_pieces

  private_class_method :new

  def get_data(data_type, arg)
    raise UnavailableDataError unless @available_data_pieces.include?(data_type)
    @data_provider.get_data(data_type, arg)
  end

  class << self
    def from_known_data(known_data:, matrix_object:)
      unless known_data.include?(NODE_TYPE)
        return from_unkown_icon(matrix_object)
      end

      if matrix_target.encrypted? && !known_data.include?(DECRYPTED)
        return from_encrypted_icon(matrix_object)
      end

      from_matrix_object(matrix_object)
    end

    private

    def from_unkown_icon(matrix_object)
      PerceptionData.new(matrix_object, [NODE_TYPE], PerceptionDataProvider.from_unkown_icon(matrix_object))
    end

    def from_encrypted_icon(matrix_object)
      PerceptionData.new(matrix_object, [IS_ENCRYPTED], PerceptionDataProvider.from_encrypted_icon(matrix_object))
    end

    def from_matrix_object(matrix_object)
      PerceptionData.new(matrix_object, nil, PerceptionDataProvider.from_matrix_object(matrix_object))
    end
  end

  private

  def initialize(matrix_object, available_data_pieces, data_provider)
    @matrix_object = matrix_object
    @data_provider = data_provider
    @available_data_pieces = available_data_pieces || data_provider.available_data_pieces
  end
end
