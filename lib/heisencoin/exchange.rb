require 'time'

module Heisencoin
  class Exchange
    attr_accessor :name, :depth, :time

    def initialize(attrs)
      @name = attrs['name']
    end
  end
end
