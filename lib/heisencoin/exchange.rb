require 'time'

module Heisencoin
  class Exchange
    attr_accessor :name, :time

    def initialize(simple = nil)
      from_simple(simple) if simple
    end

    def from_simple(simple)
      @name = simple['name']
    end

    def to_simple
      {'name' => name}
    end

  end
end
