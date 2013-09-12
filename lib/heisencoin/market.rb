module Heisencoin
  class Market
    attr_accessor :offers

    def initialize(half)
      @offers = []
      if half == :bid || half == :ask
        @half = half
      else
        raise "Bad market type parameter"
      end
    end

    def import(exchange, offers)
      offers.each do |raw_offer|
        offer = Offer.from_array(exchange, [raw_offer.first, raw_offer.last])
        sorted_insert(@offers, offer) {|offer| offer.price}
      end
    end

    def drop_offers(exchange)
      offers.reject!{|o| o.exchange = exchange}
    end

    def sorted_insert(array, element)
      value = yield element
      if array.length == 0 || better_than(value, (yield array[0]))
        array.unshift(element)
      else
        last_index = array.length-1
        for idx in 0..last_index
          if not better_than((yield array[idx]), value)
            array.insert(idx, element)
            break
          end
          if idx == last_index
            array.push(element)
          end
        end
      end
    end

    def better_than(a,b)
      if @half == :ask
        a < b
      elsif @half == :bid
        a > b
      end
    end

    def offers_better_than(price)
      offers.select{|offer| better_than(offer[1], price)}
    end

  end
end
