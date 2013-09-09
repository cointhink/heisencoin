module Heisencoin
  class Arbitrage
    attr_accessor :exchanges, :bids, :asks

    def initialize
      @exchanges = []
      @asks = Market.new
      @bids = Market.new
    end

    def add_exchanges(exchanges)
      @exchanges += exchanges
      exchanges.each do |exchange|
        add_depth(exchange)
      end
    end

    def add_depth(exchange)
      @asks.import(exchange, exchange.depth["asks"])
      @bids.import(exchange, exchange.depth["bids"])
    end

    def plan

    end
  end
end