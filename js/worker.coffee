zmq = require('zmq')
YAML = require('libyaml')
fs = require('fs')
apiworker = require('apifeedr').worker

settings_filename = "../config/settings.yml"
settings = YAML.parse(fs.readFileSync(settings_filename, 'utf8'))[0]

console.log("Connecting to "+settings.zeromq.listen)
zsock = zmq.socket('req')
zsock.connect(settings.zeromq.listen)

apiworker.work((job_info, finisher)->
  zsock.send('{"method" "arbitrage"}')
  zsock.on('message', (result) ->
    finisher.emit('job_result', String(result))
  )
)
