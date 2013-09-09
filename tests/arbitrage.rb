require "minitest/autorun"

class TestMeme < Minitest::Test

  describe Heisencoin::Arbitrage do
    before do
      @arby = Heisencoin::Arbitrage.new
      @ex1 = Heisencoin::Exchange.new({name:'btcx',
          depth: {"asks" => [], "bids" => []}
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
      it "must keep them sorted" do
        @ex1.depth["asks"] += [ [10,1],
                                [11,1,1],
                                [9,0.9] ]
        @arby.add_exchanges([@ex1])
        puts @arby.asks.offers.inspect
        @arby.asks.offers.length.must_equal 3
        @arby.asks.offers.first[1].must_equal 9

      end
    end

  end

end
