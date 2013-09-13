module Heisencoin
  class Offer
    attr_accessor :exchange, :price, :quantity

    def self.from_array(exchange, raw_offer)
      offer = Offer.new
      offer.exchange = exchange
      offer.price = raw_offer[0]
      offer.quantity = raw_offer[1]
      offer
    end

    def ==(other)
      exchange.name == other.exchange.name
      price == other.price
      quantity = other.quantity
    end

  end
end
