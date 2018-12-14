module AgentProgram
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
    pilot_rating.clamp(0, resident_node.actual_response)
  end

  def actual_attribute_rating(_)
    pilot_rating.clamp(0, resident_node.actual_response
  end

  def hot_sim_bonus
    2
  end

  def interface_mode
    InterfaceMode::HOT_SIM
  end
end
