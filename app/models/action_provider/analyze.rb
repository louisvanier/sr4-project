module ActionProvider
  class Analyze < BaseProvider
    def actions
      return [] unless current_actor.get_program_rating(MatrixProgram::ANALYZE) > 0

      actions = []

      (current_actor.nodes_present_in - [current_actor.home_node]).each do |node|
        node.icons.each do |icon|
          icon_data = known_data_pieces[current_actor][icon] || []
          perception_process = MatrixPerceptionProcess.new(initiator: current_actor, matrix_target: icon, known_data: icon_data)
          actions << { icon => perception_process } unless perception_process.available_data.empty?
        end

        node_data = known_data_pieces[current_actor][node] || []
        node_perception_process = MatrixPerceptionProcess.new(initiator: current_actor, matrix_target: node, known_data: node_data)
        actions << { node => node_perception_process } unless node_perception_process.available_data.empty?
      end

      actions
    end
  end
end
