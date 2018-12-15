class AgentProgram
  include RunsPrograms
  include CanCybercombat

  attr_accessor :programs, :pilot_rating, :home_node, :matrix_damage_taklen

  delegate :actual_device_rating, to: :home_node

  def initialize(programs:, pilot_rating:, home_node:)
    @programs = programs
    @pilot_rating = pilot_rating
    @home_node = home_node
  end

  def actual_skill_rating(_)
    pilot_rating.clamp(0, home_node.actual_device_attribute(DeviceAttribtue::RESPONSE))
  end

  def actual_attribute_rating(_)
    pilot_rating.clamp(0, home_node.actual_device_attribute(DeviceAttribtue::RESPONSE))
  end

  def hot_sim_bonus
    2
  end

  def nodes_present_in
    [home_node]
  end

  def interface_mode
    InterfaceMode::HOT_SIM
  end
end
