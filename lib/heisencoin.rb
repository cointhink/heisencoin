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

module Heisencoin
  def self.begin
    rpc = setup
    rpc.reactor
  end
    
  def self.setup    
    # Load database.yml
    settings = YAML.load_file(APP_ROOT+"/config/settings.yml")

    # Connect ActiveRecord
    ActiveRecord::Base.establish_connection(settings["development"])

    # Listen on ZeroMQ
    zmq_ctx = EM::ZeroMQ::Context.new(1)    

    RPC.new(zmq_ctx, settings)
  end
end
