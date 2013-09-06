module Heisencoin
  class Arbitrage
    attr_accessor :exchanges

    def initialize
      @exchanges = []
    end

    def add_exchanges(exchanges)
      @exchanges += exchanges
    end

    def plan
      puts "formulating a plan"
    end
  end
end