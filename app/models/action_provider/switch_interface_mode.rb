module ActionProvider
  class SwitchInterfaceMode < BaseProvider
    def actions
      return [] if current_actor.is_a?(AgentProgram)
      available_modes = InterfaceMode.constants.select do |mode|
        InterfaceMode.const_get(mode) != current_actor.interface_mode
      end

      available_modes.map { |mode| { current_actor => mode } }
    end
  end
end
