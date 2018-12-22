class CybercombatAttackDetails
  attr_reader :attack_pool, :attack_pool_limit, :defense_pool

  def initialize(attack_pool:, attack_pool_limit:, defense_pool:)
    @attack_pool = attack_pool
    @attack_pool_limit = attack_pool_limit
    @defense_pool = defense_pool
  end
end
