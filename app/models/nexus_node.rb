class NexusNode < MatrixNode
  class << self
    def response_overload_factor
      @response_overload_factor ||= 10
    end
  end
end
