zmq = require('zmq')
YAML = require('libyaml')
fs = require('fs')
apiworker = require('apifeedr').worker
edn = require('jsedn')
ap = require('argparser')
            .nonvals('daemon')
            .parse()

settings_filename = "../config/settings.yml"
settings = YAML.parse(fs.readFileSync(settings_filename, 'utf8'))[0]

console.log("connecting to zmq job queue at "+settings.zeromq.listen)
zsock = zmq.socket('req')
zsock.connect(settings.zeromq.listen)

if(ap.opt('daemon'))
  require('daemon')({stdout: process.stdout, stderr: process.stderr})

apiworker.work(function(job_info, finisher){
  var cache = false //cache_lookup(job_info)
  if(cache) {
    finisher.emit('job_result', cache)
  } else {
    // forward to engine
    var job_edn = edn.encode(job_info)
    console.log(job_edn)
    zsock.send(job_edn)
    zsock.on('message', function(result){
      var msg = String(result)
      console.log("ruby returned: "+msg)
      finisher.emit('job_result', msg)
      //cache_store(job_info, msg)
    })
  }
})

function cache_lookup(job) {
  console.log('cache_lookup')
  console.log(job)
  return null
}

function cache_store(job, msg) {
  console.log('cache_store')
  console.log(job)
  console.log(msg)
}