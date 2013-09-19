module Heisencoin
  class Trade
    attr_accessor :from_offer, :to_offer, :quantity

    def initialize(simple = nil)
      from_simple(simple) if simple
    end

    def from_simple(simple)
      @from_offer = Offer.new(simple['from_offer'])
      @to_offer = Offer.new(simple['to_offer'])
      @quantity = simple['quantity']
    end

    def to_simple
      {'from_offer' => @from_offer.to_simple,
       'to_offer' => @to_offer.to_simple,
       'quantity' => @quantity}
    end

    def ==(other)
      @from_offer == other.from_offer
      @to_offer == other.to_offer
      @quantity == other.quantity
    end

    def cost
      from_offer.cost(@quantity)
    end

    def profit
      earned = to_offer.cost(@quantity)
      earned - cost
    end

  end
end
