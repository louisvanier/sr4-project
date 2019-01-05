module RunsPrograms
  def get_program_rating(program_name)
    (programs[program_name]&.rating || 0).clamp(0, home_node.actual_device_rating(DeviceAttribute::RESPONSE))
  end

  def get_program(program_name)
    programs.find { |p| p.program_name == program_name }
  end

  def total_programs_rating
    programs.sum(&:rating)
  end

  def self.included(base)
    base.class_eval do
      alias [] get_program
    end
  end
end
