class MatrixNode
  include Encryptable
  include RunsPrograms

  class AlreadySlavedError <  StandardError; end
  class AlreadySubscribedError < StandardError; end
  class NoSuchProgramError < StandardError; end

  ACTIVE_MODE = 'active'
  PASSIVE_MODE = 'passive'
  HIDDEN_MODE = 'hidden'

  class << self
    attr_reader :response_overload_factor
  end

  attr_accessor :decker

  attr_reader :device_attributes,
    :device_mode,
    :loaded_programs,
    :programs,
    :agents,
    :subscriptions,
    :files,
    :encryption_rating,
    :alert_status,
    :physical_position

  def initialize(**attributes)
    @device_attributes = {}
    @device_attributes[DeviceAttribute::RESPONSE] = attributes[:response] || attributes[:device_rating]
    @device_attributes[DeviceAttribute::SIGNAL] = attributes[:signal] || attributes[:device_rating]
    @device_attributes[DeviceAttribute::SYSTEM] = attributes[:matrix_system] || attributes[:device_rating]
    @device_attributes[DeviceAttribute::FIREWALL] = attributes[:firewall] || attributes[:device_rating]

    @loaded_programs = attributes[:loaded_programs] || []
    @programs = attributes[:programs] || []
    @agents = attributes[:agents] || []
    @agents.each { |agent| agent.move_to_other_node(node: self)}
    @subscriptions = attributes[:subscriptions] || []
    @files = attributes[:files] || []
    @files.each { |file| file.node = self }

    @encryption_rating = attributes[:encryption_rating]
    @device_mode = attributes[:device_mode] || PASSIVE_MODE
    @alert_status = attributes[:alert_status] || AlertStatus::NO_ALERT
    @physical_position = attributes[:physical_position] || [0, 0]
  end

  def hidden?
    device_mode == HIDDEN_MODE
  end

  def icons
    @loaded_programs + @programs + @agents + @subscriptions + @files
  end

  def all_programs_on_node
    @programs + @loaded_programs
  end

  def subscriptions_to_self
    @subscriptions.select { |s| s.originating_node != self }
  end

  def subscriptions_to_others
    @subscriptions.select { |s| s.originating_node == self }
  end

  def hidden_accesses
    subscriptions_to_others.select { |sub| sub.hidden_access? }
  end

  def subscribe_to(node:, slaved: false, wired: false)
    if subscriptions_to_others.any? { |s| s.slaved? }
      raise AlreadySlavedError
    end

    if subscriptions_to_others.any? { |s| s.destination_node == node }
      raise AlreadySubscribedError
    end

    subscription = NodeSubscription.from_node(
      node: self,
      destination_node: node,
      slaved: slaved,
      wired: wired,
    )

    @subscriptions << subscription
    node.subscriptions << subscription
  end

  def user_programs_rating
    @agents.sum(&:total_programs_rating) + (decker&.total_programs_rating || 0)
  end

  def running_programs_rating
    user_programs_rating + total_programs_rating
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
    @device_attributes[DeviceAttribute::RESPONSE] - (running_programs_rating / calculated_overload_factor)
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
