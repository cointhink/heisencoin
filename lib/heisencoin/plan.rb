module Heisencoin
  class Plan
    attr_accessor :steps, :state

    def initialize(simple = nil)
      @steps = []
      from_simple(simple) if simple
    end

    def from_simple(simple)
      @state = simple["state"]
      @steps = simple["steps"].map{|trade_simple| Trade.new(trade_simple)}
    end

    def to_simple
      {"steps" => @steps.map{|step| step.to_simple},
       "state" => @state}
    end

    def <<(trades)
      @steps += trades
      self
    end

    def quantity
      @steps.reduce(0){|sum,trade|sum+trade.quantity}
    end

    def profit
      @steps.reduce(0){|total, trade| total+trade.profit}
    end

    def cost
      @steps.reduce(0){|total, trade| total+trade.cost}
    end
  end
end
