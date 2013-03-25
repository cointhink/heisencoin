apiqueue = require('apifeedr').queue

console.log("Listening on port 8000")
require('daemon')({stdout: process.stdout});

apiqueue.setup().listen(8000)