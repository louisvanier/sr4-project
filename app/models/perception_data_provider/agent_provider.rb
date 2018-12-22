module PerceptionDataProvider
  class AgentProvider < BaseProvider
    def available_data_pieces
      [
        PerceptionData::ACCESS_ID,
        PerceptionData::MATRIX_DAMAGE,
        PerceptionData::MATRIX_ATTRIBUTE_RATING,
        PerceptionData::PROGRAMS_RUNNING,
        PerceptionData::TRACE_RUNNING,
      ]
    end
  end
end
