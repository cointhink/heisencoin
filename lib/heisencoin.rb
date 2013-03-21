require 'active_record'
require 'models/strategy'

APP_ROOT = File.dirname(__FILE__)+"/../"

# Load database.yml
db_settings = YAML.load_file(APP_ROOT+"/config/database.yml")

# Connect ActiveRecord
ActiveRecord::Base.establish_connection(db_settings["development"])