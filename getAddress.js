var request = require('request-promise');
var co = require('co');
var config = require('./config.json');

var options = {
  uri: config.streets_link,
  headers: {
    'User-Agent': 'Request-Promise'
  },
  json: true,
};

module.exports = function () {
  return request(options);
};

