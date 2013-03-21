require 'active_record'
require 'models/strategy'
require 'zmq'

APP_ROOT = File.dirname(__FILE__)+"/../"

module Heisencoin
  def self.setup
    # Load database.yml
    db_settings = YAML.load_file(APP_ROOT+"/config/settings.yml")

    # Connect ActiveRecord
    ActiveRecord::Base.establish_connection(db_settings["development"])

    # Listen on ZeroMQ
    context = ZMQ::Context.new(1)
    inbound = context.socket(ZMQ::UPSTREAM)
    listening = db_settings["zeromq"]["listen"]
    puts "zeromq listening on #{listening}"
    inbound.bind(listening)
  end
end