module PerceptionDataProvider
  class UnknownIconProvider < BaseProvider
    def get_data(data_type, _)
      @matrix_object.class.name
    end
  end
end
