module ActionProvider
  class DetectHiddenNode < BaseProvider
    def actions
      return [] unless current_actor.get_program_rating(MatrixProgram::SCAN) > 0

      current_scan_action = extended_actions[current_actor]['detect_hidden_node']
      return current_scan_action unless current_scan_action.nil?

      [{current_actor => ::DetectHiddenNodesProcess.new(hits: 0)}]
    end
  end
end
