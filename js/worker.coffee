zmq = require('zmq')
YAML = require('libyaml')
fs = require('fs')
apiworker = require('apifeedr').worker

settings_filename = "../config/settings.yml"
settings = YAML.parse(fs.readFileSync(settings_filename, 'utf8'))[0]

console.log("Connecting to "+settings.zeromq.listen)
zsock = zmq.socket('req')
zsock.connect(settings.zeromq.listen)

apiworker.work_jobs((job_info, finisher)->
  console.log('dispatch called! '+job_info)
  zsock.send('{"method" "arbitrage"}')
  zsock.on('message', (result) ->
    console.log(String(result))
    finisher.emit('job_result', result)
  )
)
