module ActionProvider
  class SubscribeTo < BaseProvider
    def actions
      return [] if connectable_nodes.empty?

      connectable_nodes.map { |node| { node => 'subscribe' }}
    end

    private

    def connectable_nodes
      @connectable_nodes ||= begin
        nodes_in_range = game_state.nodes.select do |node|
          next unless node.device_mode != MatrixNode::HIDDEN_MODE || known_data_pieces[actor][node].include?(PerceptionData::NODE_PRESENCE)
          current_actor.home_node.in_mutual_range?(node: node)
        end

        (nodes_in_range.concat(
          nodes_in_range.map do |node|
            node.subscriptions_to_others.select do |sub|
              !sub.hidden_access? || known_data_pieces[current_actor][sub.destination_node].include?(PerceptionData::NODE_PRESENCE)
            end.map(&:destination_node)
          end.flatten.concat(
            nodes_in_range.map do |node|
              node.subscriptions_to_self.select do |sub|
                !sub.hidden_access? || known_data_pieces[actor][sub.originating_node].include?(PerceptionData::NODE_PRESENCE)
              end.map(&:originating_node)
            end.flatten
          )
        ) - current_actor.nodes_present_in).uniq
      end
    end
  end
end
