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
    end

    def exchange(name)
      exchanges.select{|e| e.name == name}.first
    end

    def add_depth(exchange, depth)
      @asks.drop_offers(exchange)
      @asks.import(exchange, depth["asks"])
      @bids.drop_offers(exchange)
      @bids.import(exchange, depth["bids"])
    end

    def best_price(market1, market2)
      level = nil
      market1.offers.each do |offer|
        good = market2.offers.any?{|offer_other| yield offer.price, offer_other.price}
        if good
          level = offer.price
          break
        end
      end
      level
    end

    def profitable_asks(highwater=nil)
      highwater ||= best_price(@bids, @asks){|offer, other| offer > other}
      if highwater
        @asks.offers_better_than(highwater)
      else
        []
      end
    end

    def profitable_bids(lowwater=nil)
      lowwater ||= best_price(@asks, @bids){|offer, other| offer < other}
      if lowwater
        @bids.offers_better_than(lowwater)
      else
        []
      end
    end

    def trade_all(asks, bids)
      working_bids = bids.dup
      trades = []
      fee = 0.001
      asks.each do |ask|
        step_trades = consume_ask(working_bids, ask, ask.price*(1-fee))
        trades += step_trades
        qty_traded = step_trades.reduce(0){|memo, trade| memo += trade[3]}
        break if qty_traded < ask.quantity #out of coins
      end
      trades
    end

    def consume_ask(bids, ask, price_limit)
      trades = []
      price = price_limit
      quantity = ask.quantity
      near_zero = 0.0001 #floats
      bids.each do |bid|
        if bid.price >= price
          if bid.quantity > near_zero
            trade_quantity = [bid.quantity, quantity].min
            trades << [bid.exchange, bid.price, ask.exchange, ask.price, trade_quantity]
            bid.quantity -= trade_quantity
            quantity -= trade_quantity
          end
        end
        break if quantity < near_zero
      end
      trades
    end

    def plan
      #buy sell plan
      trade_all(profitable_asks, profitable_bids)
    end

    def spread
      @asks.offers.first.price - @bids.offers.first.price
    end

  end
end