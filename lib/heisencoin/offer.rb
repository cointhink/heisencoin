module Heisencoin
  class Offer
    attr_accessor :exchange, :price, :quantity

    def self.from_array(exchange, raw_offer)
      @exchange = exchange
      @price = raw_offer[0]
      @quantity = raw_offer[1]
    end

  end
end
