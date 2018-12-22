module PerceptionDataProvider
  class DeckerProvider < BaseProvider
    def available_data_pieces
      [
        PerceptionData::ACCESS_ID,
        PerceptionData::MATRIX_DAMAGE,
        PerceptionData::RESPONSE_RATING,
        PerceptionData::SYSTEM_RATING,
        PerceptionData::FIREWALL_RATING,
        PerceptionData::SIGNAL_RATING,
        PerceptionData::PROGRAMS_RUNNING,
        PerceptionData::TRACE_RUNNING,
      ]
    end
  end
end
