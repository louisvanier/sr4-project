module ActionProvider
  class DetectHiddenNode < BaseProvider
    def actions
      return [] unless current_actor.get_program_rating(MatrixProgram::SCAN) > 0

      actions = []
      # TODO => Complete with the detect_hidden_nodes_process

      actions
    end
  end
end
