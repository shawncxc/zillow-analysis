var co = require('co');
var mongoose = require('mongoose');
var Street = require('../model/street.js');
var request = require('request-promise');
var config = require('../../../config.json');

mongoose.Promise = global.Promise;

var options = {
  uri: config.streets_link,
  headers: {
    'User-Agent': 'Request-Promise'
  },
  json: true,
};

var saveStreets = co.wrap(function* () {
  console.log('RUNNING saveStreets');
  yield mongoose.connect('mongodb://localhost/zillow');
  var streets = yield request(options).then(res => {
    return res.map(x => x.fullstreetname);
  });
  streets.forEach(street => {
    var newStreet = new Street({
      name: street
    });

    // save the user
    newStreet.save(function(err) {
      if (err) throw err;

      console.log('SAVED', street);
    });
  });
});

saveStreets();