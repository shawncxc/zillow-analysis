var fs = require('fs');
var parseString = require('xml2js').parseString;
var json2csv = require('json2csv');
var getData = require('./getData.js');
var fields = ['zpid', 'links', 'address', 'finishedSqFt', 'bathrooms', 'bedrooms', 'zestimate', 'localRealEstate'];

var dataAdapter = function(data) {
  data = data['SearchResults:searchresults'].response[0].results[0].result;
  data = JSON.stringify(data);
  data = data.replace(/[\[\]]+/g, '');
  data = '[' + data + ']';
  data = JSON.parse(data);

  return data;
};

function genCSV(address, city, state) {
  getData(address, city, state).then(function(data) {
    parseString(data, function (err, res) {
      if (err) {
        console.error(err);
      } else {
        res = dataAdapter(res);
        console.log(res);
        var csv = json2csv({ data: res, fields: fields }); 
        fs.writeFile('result.csv', csv, function(err) {
          if (err) { throw err; }
          console.log('file saved');
        });
      }
    });
  });
}

module.exports = genCSV;