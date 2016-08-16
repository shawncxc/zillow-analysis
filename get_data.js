var fs = require('fs');
var http = require('http');
var parseString = require('xml2js').parseString;
var json2csv = require('json2csv');
var config = require('./config.js');
var zws_id = config.zws_id;
var streets_link = config.streets_link;

// Get all streets
http.get(streets_link, function(response) {
  var data = '';
  response.on('data', function(d) {
    data += d.toString();
  });
  response.on('end', function() {
    data = JSON.parse(data);
    console.log(data);
  });
});

// Hit zillow and convert to csv
http.get({
  host: 'www.zillow.com',
  path: '/webservice/GetDeepSearchResults.htm?zws-id=' + zws_id + '&address=1188%20Mission%20St&citystatezip=San-Francisco%2C+CA'
}, function(response) {
  var xml = '';
  response.on('data', function(d) {
    xml += d;
  });
  response.on('end', function() {
    parseString(xml, function (err, res) {
      res = res['SearchResults:searchresults'].response[0].results[0].result;
      console.log(res);
      var fields = ['zpid', 'links', 'address', 'finishedSqFt', 'bathrooms', 'bedrooms', 'zestimate', 'localRealEstate'];
      var csv = json2csv({ data: res, fields: fields });
       
      fs.writeFile('result.csv', csv, function(err) {
        if (err) throw err;
        console.log('file saved');
      });
    });
  });
});