zmq = require('zmq')
YAML = require('libyaml')
fs = require('fs')
edn = require('jsedn')

settings_filename = "../config/settings.yml"
settings = YAML.parse(fs.readFileSync(settings_filename, 'utf8'))[0]

console.log("connecting to zmq job queue at "+settings.zeromq.listen)
zsock = zmq.socket('req')
zsock.connect(settings.zeromq.listen)


job_info = '{"id" "3abd926d-1449-4479-8bcc-21a35353033f" "method" "arbitrage"'+
           ' "params" {"exchanges" ["mtgox" "btce"] "currency" "usd"}}'
zsock.send(job_info)
zsock.on('message', function(result){
  console.log(String(result))
})

