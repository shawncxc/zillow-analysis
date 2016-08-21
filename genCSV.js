var fs = require('fs');
var parseString = require('xml2js').parseString;
var json2csv = require('json2csv');
var getData = require('./getData.js');
var fields = [
  'zpid', 'street', 'zipcode', 'city', 'state', 'latlon',
  'bathrooms', 'bedrooms', 'rentzestimate', 'price',
];

var dataAdapter = function(data) {
  data = data['SearchResults:searchresults'].response[0].results[0].result;
  data = JSON.stringify(data);
  data = data.replace(/[\[\]]+/g, '');
  data = '[' + data + ']';
  data = JSON.parse(data);

  var res = [];
  data.forEach(d => {
    res.push({
      zpid: d.zpid,
      street: d.address.street,
      zipcode: d.address.zipcode,
      city: d.address.city,
      state: d.address.state,
      latlon: [d.address.latitude, d.address.longitude],
      bathrooms: d.bathrooms,
      bedrooms: d.bedrooms,
      rentzestimate: d.rentzestimate ? d.rentzestimate.amount._ : 0,
      price: d.localRealEstate.region.zindexValue,
    });
  });

  return res;
};

function genCSV(address, city, state, genCSV) {
  getData(address, city, state).then(function(data) {
    parseString(data, function (err, res) {
      if (err) {
        console.error(err);
      } else {
        res = dataAdapter(res);
        console.log(res);
        if (genCSV) {
          var csv = json2csv({ data: res, fields: fields }); 
          fs.writeFile('result.csv', csv, function(err) {
            if (err) { throw err; }
            console.log('file saved');
          });
        }
      }
    });
  });
}

module.exports = genCSV;