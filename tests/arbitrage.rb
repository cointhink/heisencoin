require "minitest/autorun"
require "time"
require 'heisencoin'

class TestMeme < Minitest::Test

  describe Heisencoin::Arbitrage do
    before do
      @arby = Heisencoin::Arbitrage.new
      @ex1 = Heisencoin::Exchange.new({'name' =>'btcx',
          'time' => "1970-01-01",
          'depth' => {"asks" => [], "bids" => []}
        })
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
      it "must keep the asks sorted" do
        @ex1.depth["asks"] += [ [10,1],
                                [11,1,1],
                                [9,0.9] ]
        @arby.add_exchanges([@ex1])
        @arby.asks.offers.length.must_equal 3
        @arby.asks.offers.first[1].must_equal 9
      end

      it "must keep the bids sorted" do
        @ex1.depth["bids"] += [ [20,1],
                                [21,1,1],
                                [19,0.9] ]
        @arby.add_exchanges([@ex1])
        @arby.bids.offers.length.must_equal 3
        @arby.bids.offers.first[1].must_equal 21
      end
    end

  end

  describe "when optimizing for arbitrage" do
    before do
      # full setup
      @arby = Heisencoin::Arbitrage.new
      @ex1 = Heisencoin::Exchange.new({'name' =>'btcx',
          'time' => "1970-01-01",
          'depth' => {"asks" => [], "bids" => []}
        })
      @ex2 = Heisencoin::Exchange.new({'name' =>'crytpsy',
          'time' => "1970-01-01",
          'depth' => {"asks" => [], "bids" => []}
        })
      # ex1 has a 14 bid above ex2
      @ex1.depth["asks"] += [ [16,1],
                              [17,1.1],
                              [15,0.9] ]
      @ex1.depth["bids"] += [ [13,1],
                              [14,1.1],
                              [12,0.9] ]
      # ex2 has a 13.5 ask below ex2
      @ex1.depth["asks"] += [ [14,1],
                              [15,1.1],
                              [13.5,0.9] ]
      @ex1.depth["bids"] += [ [11,1],
                              [12,1.1],
                              [10,0.9] ]
      @arby.add_exchanges([@ex1, @ex2])
    end

    it "should find the lowest profitable bid" do
      limit_bid_price = @arby.best_price(@arby.bids, @arby.asks){|offer, other| offer > other}
      limit_bid_price.must_equal 14
    end

    it "should find the highest profitable ask" do
      #@arby.high_ask.must_equal 13.5
      limit_ask_price = @arby.best_price(@arby.asks, @arby.bids){|offer, other| offer < other}
      limit_ask_price.must_equal 13.5
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
