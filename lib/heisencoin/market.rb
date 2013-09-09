module Heisencoin
  class Market
    attr_accessor :offers

    def initialize()
      @offers = []
    end

    def import(exchange, offers)
      offers.each do |raw_offer|
        offer = [exchange, raw_offer.first, raw_offer.last]
        sorted_insert(@offers, offer) {|element| element[1]}
      end
    end

    def sorted_insert(array, value)
      if array.length == 0 || (yield value) <= (yield array[0])
        array.unshift(value)
      else
        for idx in 0..array.length-1
          if (yield array[idx]) > (yield value)
            array.insert(idx, value)
            break
          end
          if idx == array.length-1
            array.push(value)
          end
        end
      end
    end
  end
end
