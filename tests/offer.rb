require "minitest/autorun"
require "time"
require 'heisencoin'

class TestMeme < Minitest::Test

  include Heisencoin

  describe Heisencoin::Offer do
    describe "when constructing an Offer" do

      it "must start empty" do
        offer = Offer.new
        offer.quantity.must_equal nil
      end

      it "must load from a hash" do
        params = {'exchange' => 'ex1',
                  'price' => 10,
                  'quantity' => 1.1}
        offer = Offer.new(params)
        offer.price.must_equal params['price']
        offer.quantity.must_equal params['quantity']
      end

    end

    describe "when deriving information" do
      before do
        @offer = Offer.new({'exchange' => 'ex1',
                            'price' => 10,
                            'quantity' => 1.1})
      end

      it "must calculate amount spent" do
        @offer.cost(0.5).must_equal 5
      end

    end

  end
end
