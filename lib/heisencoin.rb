require 'active_record'
require 'models/strategy'
require 'em-zeromq'
require 'edn'

APP_ROOT = File.dirname(__FILE__)+"/../"

API_METHODS = %w(arbitrage)

module Heisencoin
  def self.setup
    # Load database.yml
    @settings = YAML.load_file(APP_ROOT+"/config/settings.yml")

    # Connect ActiveRecord
    ActiveRecord::Base.establish_connection(@settings["development"])

    # Listen on ZeroMQ
    @zmq_ctx = EM::ZeroMQ::Context.new(1)
  end

  def self.reactor
    EM.run do
      reply = @zmq_ctx.socket(ZMQ::REP)
      listening = @settings["zeromq"]["listen"]
      puts "zeromq listening on #{listening}"
      reply.bind(listening)
      reply.on(:message) do |part|
        rpc = EDN.read(part.copy_out_string)
        part.close
        dispatch(rpc)
      end
    end
  end

  def self.req #test
    EM.run do
      req = @zmq_ctx.socket(ZMQ::REQ)
      req.connect(@settings["zeromq"]["listen"])
      req.send_msg("anyone home")
    end
  end

  def self.dispatch(rpc)
    puts "dispatch: #{rpc}"
    method = rpc['method']
    if API_METHODS.include?(method)
      case method
      when "arbitrage"
        Strategy.opportunity('btc','usd',Snapshot.last)
      end
    else
      puts "bad"
    end
  end
end