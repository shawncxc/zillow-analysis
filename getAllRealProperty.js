/**
 * @fileOverview Get all the real property in SF
 */

var request = require('request-promise');
var co = require('co');
var config = require('./config.json');
var genCSV = require('./genCSV.js');

var options = {
  uri: config.streets_link,
  headers: {
    'User-Agent': 'Request-Promise'
  },
  json: true,
};

request(options).then(res => {
  return res.map(x => x.fullstreetname);
}).then(streets => {
  streets.forEach(street => {
    for (var i = 1; i < 10; i++) {
      var addr = i + ' ' + street;
      try {
        genCSV(addr, 'San Francisco', 'CA', true);
      } catch (err) {
        break;
      }
    }
  });
});
