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

var dataMassage = function (data) {
  data = data.results.result;
  return {
    zpid: data.zpid,
    latlon: [ parseInt(data.address.latitude), parseInt(data.address.longitude) ],
    street: data.address.street || 'UNKNOWN',
    zipcode: data.address.zipcode || 'UNKNOWN',
    city: data.address.city || 'UNKNOWN',
    state: data.address.state || 'UNKNOWN',
    bedrooms: parseInt(data.address.bedrooms) || 0,
    bathrooms: parseInt(data.address.bathrooms) || 0,
    finishedSqFt: parseInt(data.finishedSqFt),
    yearBuilt: data.yearBuilt || 'UNKNOWN',
    price: parseInt(data.zestimate.amount.$t) || 0,
    rent: parseInt(data.rentzestimate.amount.$t) || 0,
    taxYear: data.taxAssessmentYear || 'UNKNOWN',
    tax: parseInt(data.taxAssessment) || 0,
    useCode: data.useCode || 'UNKNOWN',
  };
};

var savePerAddr = co.wrap(function* (street) {
  for (var i = 1; i < 10000; i++) {
    var address = i + ' ' + street.name;
    var property = yield getData(address, 'San Francisco', 'CA').then(data => {
      data = JSON.parse(parser.toJson(data));
      data = data['SearchResults:searchresults'].response;
      return data;
    });

    if (property) {
      property = dataMassage(property);
      try {
        var newProperty = new Property(property);
        var alreadyExists = yield Property.find({zpid: property.zpid}).exec();
        if (alreadyExists[0]) {
          continue;
        }
        yield newProperty.save();
        console.log(property);
      } catch (e) {
        console.log(e);
      }
    }
  }
});

co(function* () {
  //yield mongoose.connect('mongodb://localhost/zillow');
  var streets = yield getAllStreets();
  for (var s = 0; s < streets.length; s++) {
    yield savePerAddr(streets[s]);  
  }
});