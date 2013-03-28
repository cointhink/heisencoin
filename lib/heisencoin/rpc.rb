Dir['lib/heisencoin/rpc/*.rb'].map{|f| File.basename(f,".rb")}
                              .each{|rb| require "heisencoin/rpc/#{rb}"}


module Heisencoin
  class RPC
    def initialize(zmq_ctx, settings)
      @zmq_ctx = zmq_ctx
      @settings = settings
    end
    
    def reactor
      EM.run do
        reply = @zmq_ctx.socket(ZMQ::REP)
        listening = @settings["zeromq"]["listen"]
        puts "zeromq listening on #{listening}"
        reply.bind(listening)
        reply.on(:message) do |part|
          rpc = EDN.read(part.copy_out_string)
          part.close
          result = dispatch(rpc)
          reply.send_msg(result.to_edn)
        end
      end
    end
  
    def dispatch(rpc)
      puts "dispatch: #{rpc}"
      method = rpc['method']
      if API_METHODS.include?(method)
        case method
        when "arbitrage"
          rpc_arbitrage(rpc['params'])
        end
      else
        puts "unknown method #{method}"
        {error: "Unknown method #{method}"}
      end
    end
  end
end