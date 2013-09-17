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

    def quantity
      @steps.reduce(0){|sum,trade|sum+trade.quantity}
    end

    def to_json(state = nil)
      @steps.to_json
    end

  end
end
