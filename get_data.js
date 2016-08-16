var fs = require('fs');
var http = require('http');
var parseString = require('xml2js').parseString;
var json2csv = require('json2csv');
var zws_id = 'X1-ZWz1febdj6zu2z_axb7v';

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
      var fields = ['zpid', 'links', 'address', 'finishedSqFt', 'bathrooms', 'bedrooms', 'zestimate', 'localRealEstate'];
      var csv = json2csv({ data: res, fields: fields });
       
      fs.writeFile('result.csv', csv, function(err) {
        if (err) throw err;
        console.log('file saved');
      });
    });
  });
});