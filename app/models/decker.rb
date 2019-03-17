class Decker
  include RunsPrograms
  include CanCybercombat

  attr_accessor :skills,
    :attributes,
    :home_node,
    :interface_mode,
    :programs,
    :matrix_damage_taken,
    :meat_world_initiative_passes,
    :subscriptions

    attr_reader :access_id, :game_id

  delegate :actual_device_rating, to: :home_node

  class << self
    def from_node(
      home_node:,
      skills:,
      attributes:,
      interface_mode: InterfaceMode::HOT_SIM,
      programs: [],
      subscriptions: [],
      access_id: SecureRandom.uuid,
      matrix_damage_taken: 0
    )
      decker = Decker.new(
        skills: skills,
        home_node: home_node,
        attributes: attributes,
        interface_mode: interface_mode,
        programs: programs,
        access_id: access_id,
        subscriptions: subscriptions,
        matrix_damage_taken: matrix_damage_taken
      )
      home_node.decker = decker
      decker
    end
  end

  def game_id=(value)
    raise Exception unless game_id.nil?
    @game_id = value
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
    @skills[skill] || 0
  end

  def actual_attribute_rating(attribute)
    @attributes[attribute]
  end

  def hot_sim_bonus
    @interface_mode == InterfaceMode::HOT_SIM ? 2 : 0
  end

  def subscribe_to(node:)
    @subscriptions << NodeSubscription.from_persona(decker: self, destination_node: node)
  end

  def unsubscribe_to(node:)
    @subscriptions.delete_if { |sub| sub.destination_node == node }
  end

  def nodes_present_in
    ([home_node] << subscriptions.map { |sub| sub.destination_node }).flatten
  end

  def as_json(_options)
    {
      game_id: game_id,
      attributes: {
        Attributes::REACTION => attributes[Attributes::REACTION],
        Attributes::INTUITION => attributes[Attributes::INTUITION],
        Attributes::LOGIC => attributes[Attributes::LOGIC],
        Attributes::WILLPOWER => attributes[Attributes::WILLPOWER]
      },
      skills: {
          Skills::COMPUTER => skills[Skills::COMPUTER],
          Skills::CYBERCOMBAT => skills[Skills::CYBERCOMBAT],
          Skills::DATA_SEARCH => skills[Skills::DATA_SEARCH],
          Skills::ELECTRONIC_WARFARE => skills[Skills::ELECTRONIC_WARFARE],
          Skills::HACKING => skills[Skills::HACKING]
      },
      interface_mode: interface_mode,
      programs: programs,
      matrix_damage_taken: matrix_damage_taken,
      meat_world_initiative_passes: meat_world_initiative_passes
    }
  end

  private

  def initialize(
    skills:,
    attributes:,
    home_node:,
    interface_mode:,
    programs:,
    access_id:,
    subscriptions:,
    matrix_damage_taken:
  )
    @skills = skills
    @attributes = attributes
    @home_node = home_node
    @interface_mode = interface_mode
    @programs = programs
    @subscriptions = subscriptions
    @access_id = access_id
    @matrix_damage_taken = matrix_damage_taken
  end
end
