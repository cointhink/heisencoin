module Heisencoin
  class Trade
    attr_accessor :from_offer, :to_offer, :quantity

    def initialize(from, to, quantity)
      @from_offer = from
      @to_offer = to
      @quantity = quantity
    end

    def ==(other)
      @from_offer == other.from_offer
      @to_offer == other.to_offer
      @quantity == other.quantity
    end
  end
end
