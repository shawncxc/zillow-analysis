// Third Party Module
var co = require('co');
var wait = require('co-wait');
var mongoose = require('mongoose');
var request = require('request-promise');
var parser = require('xml2json');
var _ = require('underscore');

// Own Module
var Property = require('../model/property.js');
var Street = require('../model/street.js');
var config = require('../../../config.json');
var getData = require('../../getData.js');
var dataMassage = require('./propertyDataMassage.js');

// Define Promise
mongoose.Promise = global.Promise;

var savePerAddr = co.wrap(function* (street) {
  var startIdx;
  var endIdx = 1000;
  var startIdxes = yield Property.find({ street_id: street }, { inc_id: 1 }).sort({ inc_id: -1 }).exec();
  if (startIdxes.length === 0) {
    startIdx = 0;
  } else {
    startIdx = startIdxes[0].inc_id;
  }
  var dataSize = yield Property.find({}).count().exec();
  if (startIdx >= endIdx || dataSize >= endIdx) {
    return;
  }
  console.log('Start from: ', startIdx);

  for (var i = startIdx; i <= endIdx; i++) {
    yield wait(1500);
    var address = i + ' ' + street;
    console.log(address);
    var rawProperties = yield getData(address, 'San Francisco', 'CA').then(data => {
      let statusCode, body;
      data = JSON.parse(parser.toJson(data));
      body = data['SearchResults:searchresults'];
      statusCode = body.message.code;
      console.log(body.message.text);
      
      return body.response;
    });

    if (rawProperties) {
      var properties = dataMassage(rawProperties, street, i);
      console.log(address, ': ', properties.length, ' properties detected!');
      for (var j = 0; j < properties.length; j++) {
        try {
          var property = properties[j];
          var newProperty = new Property(property);
          var alreadyExists = yield Property.find({zpid: property.zpid}).exec();
          if (alreadyExists[0]) {
            console.log('No.', i, ' already exists');
            continue;
          }
          yield newProperty.save();
          console.log('saved');
        } catch (e) {
          console.error(e);
        }
      }
    }
  }
});

module.exports = co.wrap(function* (fromNthStreet) {
  fromNthStreet = fromNthStreet || 0;
  yield mongoose.connect('mongodb://localhost/zillow');
  var streets;
  streets = yield Street.find().exec();
  streets = _.sortBy(streets, 'name').map(x => x.name);

  for (var s = fromNthStreet; s < streets.length; s++) {
    yield savePerAddr(streets[s]);
  }
});