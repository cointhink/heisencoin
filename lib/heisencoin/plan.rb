module Heisencoin
  class Plan
    attr_accessor :steps

    def initialize()
      @steps = []
    end

    def <<(trades)
      @steps += trades
      self
    end
  end
end
