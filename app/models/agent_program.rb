class AgentProgram
  include RunsPrograms
  include CanCybercombat
  include ComparableGameObject

  attr_reader :programs, :pilot_rating, :home_node, :matrix_damage_taken, :access_id, :game_id

  delegate :actual_device_rating, to: :home_node

  def initialize(programs:, pilot_rating:, home_node:, access_id: SecureRandom.uuid, matrix_damage_taken: 0)
    @programs = programs
    @pilot_rating = pilot_rating
    @home_node = home_node
    @access_id = access_id
    @matrix_damage_taken = matrix_damage_taken
  end

  def game_id=(value)
    raise Exception unless game_id.nil?
    @game_id = value
  end

  def actual_skill_rating(_)
    pilot_rating.clamp(0, actual_device_rating(DeviceAttribute::RESPONSE))
  end

  def actual_attribute_rating(_)
    pilot_rating.clamp(0, actual_device_rating(DeviceAttribute::RESPONSE))
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

  def move_to_other_node(node:)
    @home_node = node
    self
  end

  def as_json(_options)
    {
      game_id: game_id,
      access_id: access_id,
      pilot_rating: pilot_rating,
      matrix_damage_taken: matrix_damage_taken,
    }
  end
end
