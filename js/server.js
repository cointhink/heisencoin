apiqueue = require('apifeedr').queue
ap = require('argparser')
            .vals('port')
            .nonvals('daemon', 'help')
            .parse()

if(ap.opt('help')){
  console.log('$ coffee server.coffee [--port port] [--daemon]')
} else {
  port = ap.opt("port") || 8000
  console.log("Listening on port "+port)
  if(ap.opt('daemon'))
    require('daemon')({stdout: process.stdout, stderr: process.stderr});

  apiqueue.setup().listen(port)
}