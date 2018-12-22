module PerceptionDataProvider
  class BaseProvider
    class << self
      def from_matrix_object(matrix_object)
        case matrix_object
          when ::AgentProgram
            PerceptionDataProvider::AgentProvider
          when ::Decker
            PerceptionDataProvider::DeckerProvider
          when ::MatrixNode
            PerceptionDataProvider::MatrixNodeProvider
          when ::MatrixFile
            PerceptionDataProvider::FileProvider
        end.new(matrix_object)
      end

      def from_unknown_icon(matrix_object)
        PerceptionDataProvider::UnknownIconProvider.new(matrix_object)
      end
    end

    def initialize(matrix_object)
      @matrix_object = matrix_object
    end

    def get_data(data_type)
      case data_type
      when PerceptionData::ACCESS_ID
        @matrix_object.access_id
      when PerceptionData::MATRIX_DAMAGE
        @matrix_object.matrix_damage_taken
      when PerceptionData::RESPONSE_RATING
        @matrix_object.actual_device_rating(DeviceAttribute::RESPONSE)
        when PerceptionData::SYSTEM_RATING
        @matrix_object.actual_device_rating(DeviceAttribute::SYSTEM)
        when PerceptionData::FIREWALL_RATING
        @matrix_object.actual_device_rating(DeviceAttribute::FIREWALL)
        when PerceptionData::SIGNAL_RATING
        @matrix_object.actual_device_rating(DeviceAttribute::SIGNAL)
      when PerceptionData::PROGRAMS_RUNNING
        @matrix_object.programs
      when PerceptionData::TRACE_RUNNING
        # TODO implement trace running
        ''
      when PerceptionData::ALERT_STATUS
        @matrix_object.alert_status
      when PerceptionData::HIDDEN_ACCESS
        @matrix_object.hidden_accesses
      when PerceptionData::EDIT_DATE
        @matrix_object.edit_date
      when PerceptionData::HAS_DATA_BOMB
        @matrix_object.has_data_bomb?
      end
    end
  end
end
