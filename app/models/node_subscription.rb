class NodeSubscription
  include ComparableGameObject

  attr_reader :originating_node, :destination_node, :persona, :slaved, :wired, :game_id

  class << self
    def from_node(node:, destination_node:, slaved: false, wired: false)
      NodeSubscription.new(
        originating_node: node,
        destination_node: destination_node,
        slaved: slaved,
        wired: wired
      )
    end

    def from_persona(decker:, destination_node:)
      NodeSubscription.new(destination_node: destination_node, persona: decker)
    end
  end

  def game_id=(value)
    raise Exception unless game_id.nil?
    @game_id = value
  end

  def hidden_access?
    @persona.nil? && @destination_node.hidden?
  end

  def slaved?
    @slaved
  end

  def wired?
    @wired
  end

  def as_json(_option)
    {
      game_id: game_id,
      originating_node: originating_node&.game_id,
      destination_node: destination_node.game_id,
      persona: persona&.game_id,
      slaved: slaved?,
      wired: wired?
    }
  end

  private

  def initialize(destination_node:, originating_node: nil, persona: nil, slaved: false, wired: false)
    @originating_node = originating_node
    @persona = persona
    @destination_node = destination_node
    @slaved = slaved
    @wired = wired
  end
end
