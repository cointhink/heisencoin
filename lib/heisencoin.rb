require 'active_record'
require 'em-zeromq'
require 'edn'
require 'friendly_id'
require 'acts_as_tree'

require 'heisencoin/rpc'

# Load models
Dir['lib/models/*.rb'].map{|f| File.basename(f,".rb")}
                      .each{|rb| require "models/#{rb}"}

APP_ROOT = File.dirname(__FILE__)+"/../"

API_METHODS = %w(arbitrage)

module Heisencoin
  def self.begin
    # Load database.yml
    settings = YAML.load_file(APP_ROOT+"/config/settings.yml")

    # Connect ActiveRecord
    ActiveRecord::Base.establish_connection(settings["development"])

    # Listen on ZeroMQ
    zmq_ctx = EM::ZeroMQ::Context.new(1)    

    rpc = RPC.new(zmq_ctx, settings)
    rpc.reactor
  end
end
