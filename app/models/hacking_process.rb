class HackingProcess
  SECURITY_ACCOUNT = 'security'
  ADMIN_ACCOUNT = 'admin'
  USER_ACCOUNT = 'user'

  TRESHOLD_MODIFIER = {
    USER_ACCOUNT => 0,
    SECURITY_ACCOUNT => 3,
    ADMIN_ACCOUNT => 6
  }

  attr_reader :attempts, :hacker_total_hits, :node_total_hits, :probing, :account_type

  def initialize(target_node:, hacker:, attempts: 0, hacker_total_hits: 0, node_total_hits: 0, probing: false, account_type: SECURITY_ACCOUNT)
    @target_node = target_node
    @hacker = hacker
    @attempts = attempts
    @hacker_total_hits = hacker_total_hits
    @node_total_hits = node_total_hits
    @probing = probing
    @account_type = account_type
  end

  def add_attempt(hacker_hits:, node_hits:)
    @attempts++
    @hacker_total_hits += hacker_hits
    @node_total_hits += node_hits
    @target_node.on_alert = true if hacking_detected
  end

  def probing?
    @probing
  end

  def hacking_dice_pool
    @hacker.actual_skill_rating(Skills::HACKING) + @hacker.actual_attribute_rating(Attributes::LOGIC) + @hacker.hot_sim_bonus
  end

  def hacking_dice_pool_limit
    @hacker.get_program_rating(MatrixProgram::EXPLOIT)
  end

  def detect_hacking_dice_pool
    @target_node.actual_firewall + @target_node.get_program_rating(MatrixProgram::ANALYZE)
  end

  def hacking_detected?
    @node_total_hits > @hacker.get_program_rating(MatrixProgram::STEALTH)
  end

  def hacking_successful?
    hacker_total_hits >= @target_node.actual_firewall + TRESHOLD_MODIFIER[@account_type]
  end

  def current_hack_duration
    "#{attempts} #{(probing? ? 'hour' : 'complex action').pluralize(attempts)}"
  end

  private

  def node_can_try_to_detect?
    !probing? || attempts == 0
  end
end
