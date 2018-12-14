module PerceptionData
  class PerceptionDataProvider
    private_class_method :new
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

      def from_unknown_icon(matrix_object)
        UnknownIconProvider.new(matrix_object)
      end

      def from_encrypted_icon(matrix_object)
        EncryptedIconProvider.new(matrix_object)
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
        @matrix_object.matrix_damage_taken
      when PerceptionData.MATRIX_ATTRIBUTE_RATING
        @matrix_object.actual_attribute_rating(arg)
      when PerceptionData::PROGRAMS_LOADED
        @matrix_object.programs
      when PerceptionData::TRACE_RUNNING
        # TODO implement trace running
        ''
      when PerceptionData::ALERT_STATUS
        @matrix_object.alert_status
      when PerceptionData::HIDDEN_ACCESS
        @matrix_object.hidden_accesses
      when PerceptionData::IS_ENCRYPTED
        @matrix_object.encrypted?
      when PerceptionData::EDIT_DATE
        @matrix_object.edit_date
      when PerceptionData::HAS_DATA_BOMB
        @matrix_object.has_data_bomb?
      end
    end
  end

  class UnknownIconProvider
    def get_data(data_type, _)
      @matrix_object.class.name
    end
  end

  def EncryptedIconProvider
    def get_data(data_type, _)
      true
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

  class FileProvider < BaseProvider
    def available_data_pieces
      [
        PerceptionData::EDIT_DATE,
        PerceptionData::HAS_DATA_BOMB,
        PerceptionData::IS_ENCRYPTED,
      ]
    end
  end
end

