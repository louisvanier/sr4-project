class DetectHiddenNodesProcess
  class << self
    def from_node_list(initiator, node_list)
    end

    private

    def calculate_nodes_in_range(node_list)
      initiator_signal_range = DeviceAttributes.SIGNAL_RANGE_BY_RATING[initiator.home_node.device_attributes[DeviceAttributes::SIGNAL]]
      node_list.select do |node|
        distance_x = node.physical_position[0] - initiator.home_node.physical_position[0]
        distance_y = node.physical_position[1] - initiator.home_node.physical_position[1]
        (distance_x + distance_y).abs <= initiator_signal_range.clamp(0, DeviceAttributes.SIGNAL_RANGE_BY_RATING[node.device_attributes[DeviceAttributes::SIGNAL]])
      end
    end
  end

  def initialize(initiator:)
    @initiator = initiator
    @nodes_in_range = calculate_nodes_in_range(node_list)
  end
end
