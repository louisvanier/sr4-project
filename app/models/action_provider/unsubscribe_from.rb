module ActionProvider
  class UnsubscribeFrom < BaseProvider
    def actions
      return [] if current_actor.is_a?(AgentProgram)
      return (current_actor.nodes_present_in - [current_actor.home_node]).map { |node| { node => 'unsubscribe' } }
    end
  end
end
