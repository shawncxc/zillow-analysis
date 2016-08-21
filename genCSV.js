var fs = require('fs');
var parseString = require('xml2js').parseString;
var json2csv = require('json2csv');
var getData = require('./getData.js');
var fields = ['zpid', 'links', 'address', 'finishedSqFt', 'bathrooms', 'bedrooms', 'zestimate', 'localRealEstate'];

getData('1190 Mission St', 'San Francisco', 'CA').then(function(data) {
  parseString(data, function (err, res) {
    res = res['SearchResults:searchresults'].response[0].results[0].result;
    res = JSON.stringify(res);
    res = res.replace(/[\[\]]+/g, '');
    res = '[' + res + ']';
    res = JSON.parse(res);
    console.log(res);
    var csv = json2csv({ data: res, fields: fields }); 
    fs.writeFile('result.csv', csv, function(err) {
      if (err) { throw err; }
      console.log('file saved');
    });
  });
});


