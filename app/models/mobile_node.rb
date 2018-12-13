class MobileNode < MatrixNode
  class << self
    def response_overload_factor
      @response_overload_factor ||= 4
    end
  end
end
