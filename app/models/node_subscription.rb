class NodeSubscription
  attr_accessor :originating_node, :destination_node, :slaved, :wired

  def initialize(originating_node:, destination_node:, slaved: false, wired: false)
    @originating_node = originating_node
    @destination_node = destination_node
    @slaved = slaved
    @wired = wired
  end

  def hidden_access?
    @destination_node.hidden?
  end

  def slaved?
    @slaved
  end

  def wired?
    @wired
  end
end
