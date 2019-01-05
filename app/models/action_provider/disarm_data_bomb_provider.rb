module ActionProvider
  class DisarmDataBombProvider < BaseProvider
    def actions
      return [] unless current_actor.get_program_rating(MatrixProgram::DEFUSE) > 0
      return [] unless known_bombs = known_data_pieces[current_actor].select { |icon, data| data.include?(PerceptionData::HAS_DATA_BOMB) }

       known_bombs.map do |icon, data|
        { icon => 'defuse' } # TODO => Implement actual defuse process
       end
    end
  end
end
