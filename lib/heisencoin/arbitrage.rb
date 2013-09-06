module Heisencoin
  class Arbitrage
    @exchanges = []

    def add_exchanges(exchanges)
      @exchanges += exchanges
    end

    def plan
      puts "formulating a plan"
    end
  end
end