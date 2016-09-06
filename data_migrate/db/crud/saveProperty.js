var co = require('co');
var mongoose = require('mongoose');
var Property = require('../model/property.js');
var Street = require('../model/street.js');
var request = require('request-promise');
var parser = require('xml2json');
var config = require('../../../config.json');
var getData = require('../../getData.js');

mongoose.Promise = global.Promise;

var getAllStreets = co.wrap(function* () {
  console.log('RUNNING getAllStreets');
  yield mongoose.connect('mongodb://localhost/zillow');
  var streets = yield Street.find().exec();
  return streets;
});

var savePerAddr = co.wrap(function* (street) {
  for (var i = 1; i < 10000; i++) {
    var address = i + ' ' + street.name;
    var property = yield getData(address, 'San Francisco', 'CA').then(data => {
      data = JSON.parse(parser.toJson(data));
      data = data['SearchResults:searchresults'].response;
      return data;
    });

    if (property) {
      property = property.results.result;
      console.log(property);
    }
  }
});

co(function* () {
  var streets = yield getAllStreets();
  for (var s = 0; s < streets.length; s++) {
    yield savePerAddr(streets[s]);  
  }
});