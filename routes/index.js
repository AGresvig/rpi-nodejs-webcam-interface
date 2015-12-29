var express = require('express');
var router = express.Router();

var fs = require('fs');

/* GET files. */
router.get('/', function(req, res, next) {
  var snapsdir = 'public/images';
  var snapshots = fs.readdirSync(snapsdir);
  res.render('slides', { title: 'Today Live', files: snapshots});
});

module.exports = router;
