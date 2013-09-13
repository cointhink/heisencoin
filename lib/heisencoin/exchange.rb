require 'time'

module Heisencoin
  class Exchange
    attr_accessor :name, :time

    def initialize(attrs)
      @name = attrs['name']
    end
  end
end
