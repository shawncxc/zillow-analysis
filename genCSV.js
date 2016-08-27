var fs = require('fs');
var parseString = require('xml2js').parseString;
var json2csv = require('json2csv');
var getData = require('./getData.js');
var dataAdapter = require('./dataAdapter.js');
var fields = [
  'zpid', 
  'latlon', 'street', 'zipcode', 'city', 'state',       // ADDRESS
  'bedrooms', 'bathrooms', 'finishedSqFt','yearBuilt',  // PROPERTY
  'price', 'rent', 'tax year', 'tax', 'hoa'             // MONEY
];

function genCSV(address, city, state, genCSV) {
  console.log(address, city, state, genCSV);
  setTimeout(function () {
    getData(address, city, state).then(function(data) {
      parseString(data, function (err, res) {
        if (err) {
          console.error(err);
        } else {
          res = dataAdapter(res);
          if (!res) {
            console.log('No Results.');
            throw new Error(); 
          } else {
            console.log('Results: ', res);
          }
          if (genCSV) {
            var csv = json2csv({ data: res, fields: fields });
            fs.writeFile('result.csv', csv, { flag: 'a' }, function(err) {
              if (err) { throw err; }
              console.log('file saved');
            });
          }
        }
      });
    });
  }, 1000);
}

module.exports = genCSV;