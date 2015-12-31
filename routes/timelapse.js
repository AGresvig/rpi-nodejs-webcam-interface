var express = require('express');
var router = express.Router();

/* GET timelapse page. */
router.get('/:timespan', function(req, res, next) {
  res.render('videoplayer',
    {
      title: 'Timelapse - ' + req.params.timespan,
      videoname: req.params.timespan + '.mp4',
    });
});

module.exports = router;
