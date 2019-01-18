module ActionProvider
  class << self
    class_attribute :registered_providers
  end

  class BaseProvider
    attr_reader :game_state
    delegate :current_actor, :known_data_pieces, :extended_actions, to: :game_state

    def initialize(game_state:)
      @game_state = game_state
    end

    def actions
      raise StandardError
    end

    def inherited(provider_class)
      ActionProvider.registered_providers ||= []
      ActionProvider.registered_providers << provider_class.underscore.gsub('_class', '')
    end
  end
end
