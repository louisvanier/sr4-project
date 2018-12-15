class MatrixNode
  class AlreadySlavedError <  StandardError; end
  class AlreadySubscribedError < StandardError; end
  class NoSuchProgramError < StandardError; end
  include Encryptable

  ACTIVE_MODE = 'active'
  PASSIVE_MODE = 'passive'
  HIDDEN_MODE = 'hidden'

  class << self
    attr_reader :response_overload_factor
  end

  attr_accessor :device_attributes,
    :icons,
    :encryption_rating,
    :alert_status,
    :decker,
    :physical_position

  attr_reader :device_mode

  def initialize(**attrs)
    @device_attributes = {}
    @device_attributes[DeviceAttribute::RESPONSE] = attrs[:response] || attrs[:device_rating]
    @device_attributes[DeviceAttribute::SIGNAL] = attrs[:signal] || attrs[:device_rating]
    @device_attributes[DeviceAttribute::SYSTEM] = attrs[:matrix_system] || attrs[:device_rating]
    @device_attributes[DeviceAttribute::FIREWALL] = attrs[:firewall] || attrs[:device_rating]
    @icons = attrs[:icons] || []
    @running_programs = attrs[:running_programs] || []
    @encryption_rating = attrs[:encryption_rating]
    @device_mode = attrs[:device_mode] || PASSIVE_MODE
    @alert_status = attrs[:alert_status] || AlertStatus::NO_ALERT
    @physical_position = attrs[:physical_position] || [0, 0]
  end

  def hidden?
    device_mode == HIDDEN_MODE
  end

  def programs
    icons.select { |i| i.is_a?(MatrixProgram)}
  end

  def agents
    icons.select { |i| i.is_a?(AgentProgram)}
  end

  def subscriptions_to_self
    icons.select { |i| i.is_a?(NodeSubscription) && i.originating_node != self }
  end

  def subscriptions_to_others
    icons.select { |i| i.is_a?(NodeSubscription) && i.originating_node == self }
  end

  def hidden_accesses
    subscriptions_to_others.select { |sub| sub.hidden_access? }
  end

  def subscribe_to(node:, slaved: false, wired: false)
    if subscriptions_to_others.any? { |s| s.slaved?}
      raise AlreadySlavedError
    end

    if subscriptions_to_others.any? { |s| s.destination_node == node }
      raise AlreadySubscribedError
    end

    subscription = NodeSubscription.new(
      originating_node: self,
      destination_node: node,
      slaved: slaved,
      wired: wired,
    )

    icons << subscription
    node.icons << subscription
  end

  def user_programs_rating
    agents.sum(&:total_programs_rating) + (decker&.total_programs_rating || 0)
  end

  def total_programs_rating
    user_programs_rating + @running_programs.sum(&:rating)
  end

  def get_device_rating(device_attribute)
    @device_attributes[device_attribute]
  end

  def actual_device_rating(device_attribute)
    send("actual_#{device_attribute}")
  end

  def get_program_rating(program_name)
    prog = programs.find { |p| p.program_name == program_name }
    return 0 unless prog
    prog.rating.clamp(0, actual_response)
  end

  private

  def actual_response
    @device_attributes[DeviceAttribute::RESPONSE] - (total_programs_rating / calculated_overload_factor)
  end

  def actual_firewall
    @device_attributes[DeviceAttribute::FIREWALL] + AlertStatus::FIREWALL_BONUS[alert_status]
  end

  def actual_system
    @device_attributes[DeviceAttribute::SYSTEM].clamp(0, actual_response)
  end

  def actual_signal
    @device_attributes[DeviceAttribute::SIGNAL]
  end

  def calculated_overload_factor
    self.class.response_overload_factor * @device_attributes[DeviceAttribute::RESPONSE]
  end
end
