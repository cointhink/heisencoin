Dir['lib/heisencoin/*.rb'].map{|f| File.basename(f,".rb")}
                          .each{|rb| require "heisencoin/#{rb}"}

module Heisencoin
  @@version = "0.0.1"
end
