module PerceptionDataProvider
  class MatrixNodeProvider < BaseProvider
    def available_data_pieces
      [
        PerceptionData::ALERT_STATUS,
        PerceptionData::HIDDEN_ACCESS,
        PerceptionData::PROGRAMS_RUNNING,
        PerceptionData::RESPONSE_RATING,
        PerceptionData::SYSTEM_RATING,
        PerceptionData::FIREWALL_RATING,
        PerceptionData::SIGNAL_RATING,
      ]
    end
  end
end
