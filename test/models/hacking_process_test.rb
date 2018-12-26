require 'test_helper'

class HackingProcessTest < ActiveSupport::TestCase
  setup do
    @decker_commlink = MobileNode.new(device_rating: 4)
    @decker_programs = [
      MatrixProgram.new(program_name: MatrixProgram::EXPLOIT, rating: 6),
      MatrixProgram.new(program_name: MatrixProgram::STEALTH, rating: 6)
    ]
    @decker_skills = {
      Skills::COMPUTER => 4,
      Skills::HACKING => 4,
      Skills::CYBERCOMBAT => 6,
    }
    @decker_attributes = {
      Attributes::LOGIC => 5,
      Attributes::WILLPOWER => 5,
    }
    @decker = Decker.from_node(home_node: @decker_commlink, programs: @decker_programs, skills: @decker_skills, attributes: @decker_attributes)
    @target_node = DesktopNode.new(device_rating: 4, programs: [MatrixProgram.new(program_name: MatrixProgram::ANALYZE, rating: 4)])
  end

  test '#hacking_dice_pool returns the logic + hacking + hot_sim bonus of the hacker' do
    process = HackingProcess.new(target_node: @target_node, hacker: @decker)
    assert_equal 11, process.hacking_dice_pool # HACKING(4) + LOGIC(5) + HOT_SIM(2)
  end

  test '#hacking_dice_pool_limit returns the exploit program actual rating' do
    process = HackingProcess.new(target_node: @target_node, hacker: @decker)
    assert_equal 4, process.hacking_dice_pool_limit # program rating 6 clamped to 4
  end

  test '#detect_hacking_dice_pool is the node\'s firewall + running ANALYZE program' do
    process = HackingProcess.new(target_node: @target_node, hacker: @decker)
    assert_equal 8, process.detect_hacking_dice_pool
  end

  test '#detect_hacking_dice_pool is 0 if the hacker probes and is not at his first dice roll' do
    process = HackingProcess.new(target_node: @target_node, hacker: @decker, probing: true, attempts: 1)
    assert_equal 0, process.detect_hacking_dice_pool
  end

  test '#hacking_detected? is false if the node_total_hits is <= to the hacker STEALTH program rating' do
    (0..@decker.get_program_rating(MatrixProgram::STEALTH)).each do |node_hits|
      process = HackingProcess.new(target_node: @target_node, hacker: @decker, node_total_hits: node_hits)
      refute process.hacking_detected?
    end
  end

  test '#hacking_detected? is true if the node_total_hits is > than the hacker STEALTH program rating' do
    ((@decker.get_program_rating(MatrixProgram::STEALTH) + 1)..10).each do |node_hits|
      process = HackingProcess.new(target_node: @target_node, hacker: @decker, node_total_hits: node_hits)
      assert process.hacking_detected?
    end
  end

  test '#hacking_successful? is false if the hacker\'s total hits is < than target FIREWALL for USER accounts' do
    (0..(@target_node.actual_device_rating(DeviceAttribute::FIREWALL) - 1)).each do |hack_hits|
      process = HackingProcess.new(target_node: @target_node, hacker: @decker, hacker_total_hits: hack_hits, account_type: HackingProcess::USER_ACCOUNT)
      refute process.hacking_successful?
    end
  end

  test '#hacking_successful? is true if the hacker\'s total hits is >= than target FIREWALL for USER accounts' do
    (@target_node.actual_device_rating(DeviceAttribute::FIREWALL)..10).each do |hack_hits|
      process = HackingProcess.new(target_node: @target_node, hacker: @decker, hacker_total_hits: hack_hits, account_type: HackingProcess::USER_ACCOUNT)
      assert process.hacking_successful?
    end
  end

  test '#hacking_successful? is false if the hacker\'s total hits is < than target FIREWALL + 3 for SECURITY accounts' do
    (0..(@target_node.actual_device_rating(DeviceAttribute::FIREWALL) + 2)).each do |hack_hits|
      process = HackingProcess.new(target_node: @target_node, hacker: @decker, hacker_total_hits: hack_hits)
      refute process.hacking_successful?
    end
  end

  test '#hacking_successful? is true if the hacker\'s total hits is >= than target FIREWALL + 3 for SECURITY accounts' do
    ((@target_node.actual_device_rating(DeviceAttribute::FIREWALL) + 3)..15).each do |hack_hits|
      process = HackingProcess.new(target_node: @target_node, hacker: @decker, hacker_total_hits: hack_hits)
      assert process.hacking_successful?
    end
  end

  test '#hacking_successful? is false if the hacker\'s total hits is < than target FIREWALL + 6 for ADMIN accounts' do
    (0..(@target_node.actual_device_rating(DeviceAttribute::FIREWALL) + 5)).each do |hack_hits|
      process = HackingProcess.new(target_node: @target_node, hacker: @decker, hacker_total_hits: hack_hits, account_type: HackingProcess::ADMIN_ACCOUNT)
      refute process.hacking_successful?
    end
  end

  test '#hacking_successful? is true if the hacker\'s total hits is >= than target FIREWALL + 6 for ADMIN accounts' do
    ((@target_node.actual_device_rating(DeviceAttribute::FIREWALL) + 6)..15).each do |hack_hits|
      process = HackingProcess.new(target_node: @target_node, hacker: @decker, hacker_total_hits: hack_hits, account_type: HackingProcess::ADMIN_ACCOUNT)
      assert process.hacking_successful?
    end
  end
end
