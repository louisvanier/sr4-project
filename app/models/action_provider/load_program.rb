module ActionProvider
  class LoadProgram < BaseProvider
    def actions
      return [] if current_actor.is_a?(AgentProgram)
      return current_actor.home_node.programs.map { |prog| { prog => 'load program' } }
    end
  end
end
