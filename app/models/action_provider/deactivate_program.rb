module ActionProvider
  class DeactivateProgram < BaseProvider
    def actions
      return [] unless current_actor.is_a?(Decker)

      actions = []
      actions.concat(
        current_actor.programs.map do |prog|
          { prog => 'deactivate'}
        end
      )

      # TODO => also return a list of known agents on nodes where the account is ADMIN (or maybe security?)

      actions
    end
  end
end
