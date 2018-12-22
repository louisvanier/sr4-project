module PerceptionDataProvider
  class MatrixNodeProvider < BaseProvider
    def available_data_pieces
      [
        PerceptionData::ALERT_STATUS,
        PerceptionData::HIDDEN_ACCESS,
        PerceptionData::PROGRAMS_RUNNING,
        PerceptionData::MATRIX_ATTRIBUTE_RATING,
      ]
    end
  end
end
