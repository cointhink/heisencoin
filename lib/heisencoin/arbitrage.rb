module Heisencoin
  class Arbitrage
    attr_accessor :exchanges, :bids, :asks

    def initialize
      @exchanges = []
      @asks = Market.new(:ask)
      @bids = Market.new(:bid)
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

    def best_price(market1, market2)
      level = nil
      market1.offers.each do |offer|
        good = market2.offers.any?{|offer_other| yield offer[1], offer_other[1]}
        level = offer[1] if good
      end
      level
    end

    def profitable_asks(highwater=nil)
      highwater ||= best_price(@bids, @asks){|offer, other| offer > other}
      @asks.offers_better_than(highwater)
    end

    def profitable_bids(lowwater=nil)
      lowwater ||= best_price(@asks, @bids){|offer, other| offer < other}
      @bids.offers_better_than(lowwater)
    end

    def trade_all(asks, bids)
      working_bids = bids.dup
      trades = []
      fee = 0.001
      asks.each do |ask|
        step_trades = consume_ask(working_bids, ask, ask[1]*(1-fee))
        trades += step_trades
        qty_traded = step_trades.reduce(0){|memo, trade| memo += trade[3]}
        break if qty_traded < ask[2] #out of coins
      end
      trades
    end

    def consume_ask(bids, ask, price_limit)
      trades = []
      price = price_limit
      quantity = ask[2]
      bids.each do |bid|
        if bid[1] >= price
          if bid[2] >= quantity
            trades << [bid[0], ask[0], ask[1], quantity]
            bid[2] -= quantity
          end
        end
      end
      trades
    end

    def plan
      #buy sell plan
      trade_all(profitable_asks, profitable_bids)
    end
  end
end