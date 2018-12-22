class CybercombatDamageDetails
  attr_reader :damage_value, :damage_type, :damage_soak_pool

  def initialize(damage_value:, damage_type:, damage_soak_pool:)
    @damage_value = damage_value
    @damage_type = @damage_type
    @damage_soak_pool = damage_soak_pool
  end
end
