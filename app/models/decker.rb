class Decker
  include RunsPrograms
  include CanCybercombat

  attr_accessor :skills, :attributes, :home_node, :interface_mode, :programs, :matrix_damage_taken, :meat_world_initiative_passes, :subscriptions, :stun_damage_taken, :physical_damage_taken

  delegate :actual_device_rating, to: :home_node

  class << self
    def from_node(home_node:, skills:, attributes:, interface_mode: InterfaceMode::HOT_SIM, programs: [])
      decker = Decker.new(skills: skills, home_node: home_node, attributes: attributes, interface_mode: interface_mode, programs: programs)
      home_node.decker = decker
      decker
    end
  end

  def run_program(program)
    raise MatrixNode::NoSuchProgramError unless program = home_node.programs.find { |prog| prog == program }
    programs << program
    home_node.programs.delete(program)
  end

  def stop_program(program)
    raise MatrixNode::NoSuchProgramError unless program = programs.find { |prog| prog == program }
    programs.delete(program)
    home_node.programs << program
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

  def nodes_present_in
    [home_node] << subscriptions.map { |sub| sub.destination_node }
  end

  private

  def initialize(skills:, attributes:, home_node:, interface_mode: InterfaceMode::HOT_SIM, programs: [])
    @skills = skills
    @attributes = attributes
    @home_node = home_node
    @interface_mode = interface_mode
    @programs = programs
  end
end
