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

    def sorted_insert(array, element)
      value = yield element
      if array.length == 0 || value <= (yield array[0])
        array.unshift(element)
      else
        last_index = array.length-1
        for idx in 0..last_index
          if (yield array[idx]) > value
            array.insert(idx, element)
            break
          end
          if idx == last_index
            array.push(element)
          end
        end
      end
    end
  end
end
