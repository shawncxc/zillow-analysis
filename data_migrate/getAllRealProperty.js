/**
 * @fileOverview Get all the real property in SF
 */

var request = require('request-promise');
var Q = require('q');
var co = require('co');
var config = require('../config.json');
var genCSV = require('./genCSV.js');

var options = {
  uri: config.streets_link,
  headers: {
    'User-Agent': 'Request-Promise'
  },
  json: true,
};

var getAllRealProperty = Q.async(function* () {
  var streets = yield request(options).then(res => {
    return res.map(x => x.fullstreetname);
  });

  for (var i = 1; i < 2; i++) {
    streets.forEach((street, idx) => {
      var addr = i + ' ' + street;
      try {
        console.info(i, ' / ', 10 - 1, ' - ', idx + 1, ' / ', streets.length);
        genCSV(addr, 'San Francisco', 'CA', true);
      } catch (err) {
        console.log('No result');
      }
    });  
  }
});

module.exports = getAllRealProperty;
