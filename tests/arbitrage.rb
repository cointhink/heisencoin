require "minitest/autorun"

class TestMeme < Minitest::Test

  describe Heisencoin::Arbitrage do
    before do
      @arby = Heisencoin::Arbitrage.new
    end

    describe "when setting up the list of exchanges" do
      it "must start empty" do
        @arby.exchanges.size.must_equal 0
      end

      it "must accept new exchanges" do
        exchanges = [{name:'place'}]
        @arby.add_exchanges(exchanges)
        @arby.exchanges.size.must_equal 1
      end
    end
  end

end
