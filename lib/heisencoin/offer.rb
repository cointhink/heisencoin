module Heisencoin
  class Offer
    attr_accessor :exchange, :price, :quantity

    def initialize(simple = nil)
      from_simple(simple) if simple
    end

    def from_simple(simple)
      @exchange = Exchange.new(simple['exchange'])
      @price = simple['price']
      @quantity = simple['quantity']
    end

    def to_simple
      {'exchange' => exchange.to_simple,
       'price' => price,
       'quantity' => quantity}
    end

    def ==(other)
      exchange.name == other.exchange.name
      price == other.price
      quantity = other.quantity
    end

    def cost(quantity)
      quantity * price
    end

    def self.from_array(exchange, raw_offer)
      Offer.new({'exchange' => exchange.to_simple,
                 'price' => raw_offer[0],
                 'quantity' => raw_offer[1]})
    end
  end
end
