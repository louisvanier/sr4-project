class Decker
  attr_accessor :skills, :attributes, :home_node, :interface_mode, :programs

  def initialize(skills:, attributes:, home_node:, interface_mode: InterfaceMode::HOT_SIM, programs: [])
    @skills = skills
    @attributes = attributes
    @home_node = home_node
    @interface_mode = interface_mode
    @programs = programs
  end

  def actual_skill_rating(skill)
    @skills[skill]
  end

  def actual_attribute_rating(attribute)
    @attributes[attribute]
  end

  def hot_sim_bonus
    @interface_mode == InterfaceMode::HOT_SIM ? 2 : 0
  end

  def get_program_rating(program_name)
    prog = programs.find { |p| p.program_name == program_name }
    (prog&.rating || 0).clamp(0, home_node.actual_response
  end
end
