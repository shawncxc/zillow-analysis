var co = require('co');
var mongoose = require('mongoose');
var Property = require('../model/property.js');
var Street = require('../model/street.js');
var request = require('request-promise');
var config = require('../../../config.json');

mongoose.Promise = global.Promise;

var getAllStreets = co.wrap(function* () {
  console.log('RUNNING getAllStreets');
  yield mongoose.connect('mongodb://localhost/zillow');
  var streets = yield Street.find().exec();
  console.log('-> ', streets);
  return yield Promise.resolve(streets);
});

console.log(getAllStreets());