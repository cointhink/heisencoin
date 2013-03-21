zmq = require('zmq')
YAML = require('libyaml')
fs = require('fs')

settings_filename = "../config/settings.yml"
settings = YAML.parse(fs.readFileSync(settings_filename, 'utf8'))[0]

console.log("Connecting to "+settings.zeromq.listen)
sock = zmq.socket('req')
sock.connect(settings.zeromq.listen)