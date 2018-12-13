module PerceptionData
  class PerceptionDataProvider
    class << self
      def from_matrix_object(matrix_object)
        case matrix_object
          when ::AgentProgram
            AgentProvider
          when ::Decker
            DeckerProvider
          when ::MatrixNode
            MatrixNodeProvider
        end.new(matrix_object)
      end
    end
  end

  private

  class BaseProvider
    def initialize(matrix_object)
      @matrix_object = matrix_object
    end

    def get_data(data_type, arg)
      case data_type
      when PerceptionData::ACCESS_ID
        @matrix_object.access_id
      when PerceptionData.MATRIX_DAMAGE
        @matrix_object.matrix_damage
      when PerceptionData.MATRIX_ATTRIBUTE_RATING
        @matrix_object.get_attribute_rating(arg)
      when PerceptionData::PROGRAMS_LOADED
        @matrix_object.programs
      when PerceptionData::TRACE_RUNNING
        # TODO implement trace running
        ''
      when PerceptionData::ALERT_STATUS
        # TODO change alert status to an enum
        @matrix_object.on_alert
      when PerceptionData::HIDDEN_ACCESS
        @matrix_object.hidden_accesses
      when PerceptionData::IS_ENCRYPTED
        @matrix_object.encryption_rating > 0
      end
    end
  end

  class AgentProvider < BaseProvider
    def available_data_pieces
      [
        PerceptionData::ACCESS_ID,
        PerceptionData::MATRIX_DAMAGE,
        PerceptionData::MATRIX_ATTRIBUTE_RATING,
        PerceptionData::PROGRAMS_LOADED,
        PerceptionData::TRACE_RUNNING,
      ]
    end
  end

  class MatrixNodeProvider < BaseProvider
    def available_data_pieces
      [
        PerceptionData::ALERT_STATUS,
        PerceptionData::HIDDEN_ACCESS,
        PerceptionData::PROGRAMS_LOADED,
        PerceptionData::MATRIX_ATTTRIBUTE_RATING,
        PerceptionData::IS_ENCRYPTED,
      ]
    end
  end

  class DeckerProvider < BaseProvider
    def available_data_pieces
      [
        PerceptionData::ACCESS_ID,
        PerceptionData::MATRIX_DAMAGE,
        PerceptionData::MATRIX_ATTRIBUTE_RATING,
        PerceptionData::PROGRAMS_LOADED,
        PerceptionData::TRACE_RUNNING,
      ]
    end
  end
end

