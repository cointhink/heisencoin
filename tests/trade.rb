require "minitest/autorun"
require "time"
require 'heisencoin'

class TestMeme < Minitest::Test

  include Heisencoin

  describe Heisencoin::Trade do
    before do
      @ex1 = Exchange.new({'name' =>'buylow'})
      @offer1 = Offer.new({'exchange' => @ex1.to_simple,
                           'price' => 10,
                           'quantity' => 1})
      @ex2 = Exchange.new({'name' =>'sellhigh'})
      @offer2 = Offer.new({'exchange' => @ex2.to_simple,
                           'price' => 11,
                           'quantity' => 1})
    end

    describe "when constructing a Trade" do

      it "must start empty" do
        trade = Trade.new
      end

    end

    describe "when deriving information" do
      before do
        @trade = Trade.new({'from_offer' => @offer1.to_simple,
                            'to_offer' => @offer2.to_simple,
                            'quantity' => 1.0})
      end

      it "must remember the offers" do
        @trade.from_offer.must_equal @offer1
        @trade.to_offer.must_equal @offer2
        @trade.quantity.must_equal 1
      end

      it "must calculate amount spent" do
        @trade.profit.must_equal 1
      end

    end

  end
end
