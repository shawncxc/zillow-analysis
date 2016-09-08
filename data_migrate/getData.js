var co = require('co');
var request = require('request-promise');
var urlencode = require('urlencode');
var config = require('../config.json');

var getData = co.wrap(function* (address, city, state) {
  address = urlencode(address);
  city = urlencode(city);
  state = urlencode(state);
  var uri = config.zillow + '/webservice/GetDeepSearchResults.htm?zws-id=' + 
            config.zws_id + '&address=' + address + '&citystatezip=' + city + 
            '%2C+' + state + '&rentzestimate=true';
  
  var result;
  try {
    result = yield request(uri);
  } catch (e) {
    console.error(e);
  }
  
  return result;
});

module.exports = getData;