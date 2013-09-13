require "minitest/autorun"
require "time"
require 'heisencoin'

class TestMeme < Minitest::Test

  describe Heisencoin::Arbitrage do
    before do
      @arby = Heisencoin::Arbitrage.new
      @ex1 = Heisencoin::Exchange.new({'name' =>'btcx'})
    end

    describe "when setting up the list of exchanges" do
      it "must start empty" do
        @arby.exchanges.size.must_equal 0
      end

      it "must accept new exchanges" do
        exchanges = [@ex1]
        @arby.add_exchanges(exchanges)
        @arby.exchanges.size.must_equal 1
      end
    end

    describe "when importing offers" do
      before do
        @depth = {"asks" => [ [10,1],
                              [11,1,1],
                              [9,0.9] ],
                  "bids" => [ [20,1],
                              [21,1,1],
                              [19,0.9] ]}
        @arby.add_depth(@ex1, @depth)
      end

      it "must keep the asks sorted" do
        @arby.asks.offers.length.must_equal @depth["asks"].size
        @arby.asks.offers.first.price.must_equal 9
      end

      it "must keep the bids sorted" do
        @arby.bids.offers.length.must_equal @depth["bids"].size
        @arby.bids.offers.first.price.must_equal 21
      end
    end

  end

  describe "when optimizing for arbitrage" do
    before do
      # full setup
      @arby = Heisencoin::Arbitrage.new
      @ex1 = Heisencoin::Exchange.new({'name' =>'btcx'})
      @ex2 = Heisencoin::Exchange.new({'name' =>'crytpsy'})
      @arby.add_exchanges([@ex1, @ex2])
      # ex1 has a 14.1 and 14.2 bid above ex2's 14 ask
      depth = {"asks" => [ [16,1],
                           [17,1.1],
                           [15,0.9] ],
               "bids" => [ [13,1],
                           [14.1,1.1],[14.2,1.2],
                           [12,0.9] ]}
      @arby.add_depth(@ex1, depth)
      # ex2 has a 13.5 ask below ex2
      depth = {"asks" => [ [14,1],
                           [15,1.1],
                           [13.5,0.9],[13.4,0.5] ],
               "bids" => [ [11,1],
                           [12,1.1],
                           [10,0.9] ]}
      @arby.add_depth(@ex2, depth)
    end

    it "should find the lowest profitable bid price" do
      limit_bid_price = @arby.best_price(@arby.bids, @arby.asks){|offer, other| offer > other}
      limit_bid_price.must_equal 14.1
    end

    it "should find the highest profitable ask price" do
      limit_ask_price = @arby.best_price(@arby.asks, @arby.bids){|offer, other| offer < other}
      limit_ask_price.must_equal 14
    end

    it "should find all profitable asks" do
      winners = @arby.profitable_asks
      winners.must_equal [ [@ex2, 13.4, 0.5], [@ex2, 13.5, 0.9], [@ex2, 14, 1]]
    end

    it "should find all profitable bids" do
      winners = @arby.profitable_bids
      winners.must_equal [ [@ex1, 14.2, 1.2], [@ex1, 14.1, 1.1]]
    end

    it "should make all available trades" do
      trades = @arby.trade_all(@arby.profitable_asks, @arby.profitable_bids)
      trades.must_equal [ [@ex1, @ex2, 13.4, 0.5], [@ex1, @ex2, 13.4, 0.5]]
    end

    it "should work" do
      # buy 13.5 x0.9 from ex2, sell to ex1 (up to x1.1)
      #plan = @arby.plan
      #plan.steps.size.must_equal 1
      #step1 = plan.steps.first
      #step1.from.must_equal @ex2
      #step1.to.must_equal @ex1
      #step1.amount.must_equal 0.9
    end
  end

end
