var fs = require('fs');
var Q = require('q');
var parser = require('xml2json');
var json2csv = require('json2csv');
var getData = require('./getData.js');
var dataAdapter = require('./dataAdapter.js');
var fields = [
  'zpid', 
  'latlon', 'street', 'zipcode', 'city', 'state',       // ADDRESS
  'bedrooms', 'bathrooms', 'finishedSqFt','yearBuilt',  // PROPERTY
  'price', 'rent', 'tax year', 'tax', 'hoa'             // MONEY
];

var genCSV = Q.async(function* (address, city, state, genCSVflag) {
  var data;

  // get xml data
  data = yield getData(address, city, state).then(function(data) {
    return data;
  });

  // get json data
  data = JSON.parse(parser.toJson(data));

  // data massage
  if (!data) {
    throw new Error('no result for this address');
  } else {
    data = dataAdapter(data);
    console.log(data);
  }

  // write to csv
  if (genCSVflag && data) {
    var csv = json2csv({ data: data, fields: fields });
    yield Q.async(fs.writeFile('result.csv', csv, { flag: 'a' }));
  }

  return true;
});

module.exports = genCSV;