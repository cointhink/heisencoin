require 'time'

module Heisencoin
  class Exchange
    attr_accessor :name, :depth, :time

    def initialize(attrs)
      @name = attrs['name']
      @depth = attrs['depth']
      @time = Time.parse(attrs['time'])
    end

    def inspect
      @name.inspect
    end
  end
end
