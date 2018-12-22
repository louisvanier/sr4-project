module PerceptionDataProvider
  class UnknownIconProvider < BaseProvider
    def available_data_pieces
      [
        PerceptionData::ICON_TYPE
      ]
    end

    def get_data(data_type, _)
      @matrix_object.class.name
    end
  end
end
