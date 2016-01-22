var express = require('express');
var router = express.Router();

var fs = require('fs');

/* GET front page with outdoor pics. */
router.get('/', function(req, res, next) {
  var snapsdir = 'public/images/outdoor';
  var snapshots = fs.readdirSync(snapsdir);
  res.render('slides', { title: 'Today Live Outdoor', rootPath: '/images/outdoor', files: snapshots });
});

/* GET page with indoor pics. */
router.get('/indoor', function(req, res, next) {
  var snapsdir = 'public/images/indoor';
  var snapshots = fs.readdirSync(snapsdir);
  res.render('slides', { title: 'Today Live Indoor', rootPath: '/images/indoor', files: snapshots });
});

/* GET timelapse page. */
router.get('/:timespan', function(req, res, next) {
  res.render('videoplayer',
    {
      title: 'Timelapse - ' + req.params.timespan,
      videoname: req.params.timespan + '.mp4',
    });
});

module.exports = router;
