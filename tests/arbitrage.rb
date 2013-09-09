require "minitest/autorun"
require "time"

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
      @ex1.depth["asks"] += [ [10,1],
                              [11,1.1],
                              [9,0.9] ]
      @ex1.depth["bids"] += [ [20,1],
                              [21,1.1],
                              [19,0.9] ]
      @ex1.depth["asks"] += [ [10,1],
                              [11,1.1],
                              [9,0.9] ]
      @ex1.depth["bids"] += [ [20,1],
                              [21,1.1],
                              [19,0.9] ]
      @arby.add_exchanges([@ex1, @ex2])
    end

    it "should work" do
      @arby.plan
    end
  end

end
