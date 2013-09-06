module HeisenCoin
  class Exchange
    attr_accessor :name, :depth

    def initialize(attrs)
      @name = attrs[:name]
      @depth = attrs[:depth]
    end
  end
end
