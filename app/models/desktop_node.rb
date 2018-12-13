class DesktopNode < MatrixNode
  class << self
    def response_overload_factor
      @response_overload_factor ||= 6
    end
  end
end
