require 'time'

module Heisencoin
  class Exchange
    attr_accessor :name, :fee, :time

    def initialize(simple = nil)
      from_simple(simple) if simple
    end

    def from_simple(simple)
      @name = simple['name']
      @fee = simple['fee']
    end

    def to_simple
      {'name' => name,
       'fee' => fee}
    end

    def ==(other)
      self.name == other.name
    end

  end
end
