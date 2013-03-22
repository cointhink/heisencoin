require 'active_record'
require 'em-zeromq'
require 'edn'
require 'friendly_id'
require 'acts_as_tree'

# Load models
Dir['lib/models/*.rb'].map{|f| File.basename(f,".rb")}
                      .each{|rb| require "models/#{rb}"}

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
        result = dispatch(rpc)
        reply.send_msg(result.to_edn)
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
        rpc_arbitrage(rpc['params'])
      end
    else
      puts "bad"
    end
  end

  def self.rpc_arbitrage(params)
    snapshot = Snapshot.last
    actions = Strategy.opportunity('btc','usd', snapshot)

    # Full accounting
    #strategy = Strategy.analyze(actions)
    #snapshot.update_attribute :strategy, strategy
    #puts "Linked strategy ##{strategy.id} to snapshot ##{snapshot.id} #{snapshot.created_at}"

    # Summary
    buysells = Strategy.buysells(actions)
    usd_in = actions.sum{|a| a[:sells].sum{|s| a[:buy].cost(s[:spent])}}
    usd_out = actions.sum{|a| a[:sells].sum{|s| s[:offer].cost(s[:spent])}}

    { cache: Time.now,
      snapshot: {id: snapshot.id, date: snapshot.created_at},
      balance_in: usd_in.to_h,
      balance_out: usd_out.to_h
    }
  end
end
