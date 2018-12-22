module PerceptionDataProvider
  class FileProvider < BaseProvider
    def available_data_pieces
      [
        PerceptionData::EDIT_DATE,
        PerceptionData::HAS_DATA_BOMB,
      ]
    end
  end
end
