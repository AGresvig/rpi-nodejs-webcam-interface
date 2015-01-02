var express = require('express')
var app = express()

var config = require('./config.js');
var RaspiCam = require("raspicam");

var camera = new RaspiCam(config.cameraOpts);

app.get('/', function (req, res) {
  //listen for the "read" event triggered when each new photo/video is saved
  camera.on("read", function(err, timestamp, filename){
    if (err) {
      res.json(500, err);
    }
    res.send("image available at: /"+filename);
  });
  camera.start();
})

var server = app.listen(3000, function () {

  var host = server.address().address
  var port = server.address().port

  console.log('Example app listening at http://%s:%s', host, port)

})

module.exports = server;
