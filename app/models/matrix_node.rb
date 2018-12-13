class MatrixNode
  ACTIVE_MODE = 'active'
  PASSIVE_MODE = 'passive'
  HIDDEN_MODE = 'hidden'

  AlreadySlavedError <  Error
  class << self
    attr_reader :response_overload_factor
  end
  attr_accessor :response,
    :signal,
    :firewall,
    :matrix_system,
    :icons,
    :encryption_rating,
    :on_alert

  attr_reader :device_mode

  # should never be instantiated
  def initialize(**attrs)
    @response = attrs[:response] || attrs[:device_rating]
    @signal = attrs[:signal] || attrs[:device_rating]
    @matrix_system = attrs[:matrix_system] || attrs[:device_rating]
    @firewall = attrs[:firewall] || attrs[:device_rating]
    @icons = attrs[:icons] || []
    @encryption_rating = attrs[:encryption_rating]
    @device_mode = attrs[:device_mode] || PASSIVE_MODE

  end

  def on_alert?
    @on_alert
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
    if slaved && subscriptions_to_others.any? { |s| s.slaved?}
      raise AlreadySlavedError
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

  def running_programs_rating
    programs.select(&:loaded).sum(&:rating) + agents.sum { |a| a.programs.sum(&:rating) }
  end

  def actual_response
    response - (running_programs_rating / (self.class.response_overload_factor * response))
  end

  def actual_firewall
    firewall + on_alert? ? 4 : 0
  end

  def get_program_rating(program_name)
    prog = programs.find { |p| p.program_name == program_name }
    return 0 unless prog
    prog.rating.clamp(0, actual_response)
  end
end
