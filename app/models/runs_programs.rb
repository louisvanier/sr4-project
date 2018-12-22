module RunsPrograms
  def get_program_rating(program_name)
    prog = programs.find { |p| p.program_name == program_name }
    (prog&.rating || 0).clamp(0, home_node.actual_device_rating(DeviceAttribute::RESPONSE))
  end

  def total_programs_rating
    programs.sum(&:rating)
  end
end
