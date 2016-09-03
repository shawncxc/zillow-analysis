var Q = require('q');
var request = require('request-promise');
var urlencode = require('urlencode');
var config = require('../config.json');

var getData = Q.async(function* (address, city, state) {
  address = urlencode(address);
  city = urlencode(city);
  state = urlencode(state);
  var uri = config.zillow + '/webservice/GetDeepSearchResults.htm?zws-id=' + 
            config.zws_id + '&address=' + address + '&citystatezip=' + city + 
            '%2C+' + state + '&rentzestimate=true';

  return request(uri);
});

module.exports = getData;
