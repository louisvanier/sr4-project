module AgentProgram
  attr_accessor :programs, :pilot_rating, :resident_node

  def initialize(programs:, pilot_rating:, resident_node:)
    @programs = programs
    @pilot_rating = pilot_rating
    @resident_node = resident_node
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

  def get_program_rating(program_node)
    prog = programs.find { |p| p.program_name == program_name }
    (prog&.rating || 0).clamp(0, resident_node.actual_response)
  end
end
