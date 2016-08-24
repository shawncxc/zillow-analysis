var dataAdapter = function(data) {
  var code = data['SearchResults:searchresults'].message[0].code[0];
  if (code === '508') {
    return false;
  }

  data = data['SearchResults:searchresults'].response[0].results[0].result;
  data = JSON.stringify(data);
  data = data.replace(/[\[\]]+/g, '');
  data = '[' + data + ']';
  data = JSON.parse(data);

  var res = [];
  data.forEach(d => {
    res.push({
      // ID
      zpid: d.zpid,
      
      // ADDRESS
      latlon: [d.address.latitude, d.address.longitude]         || 'UNKNOWN',
      street: d.address.street                                  || 'UNKNOWN',
      zipcode: d.address.zipcode                                || 'UNKNOWN',
      city: d.address.city                                      || 'UNKNOWN',
      state: d.address.state                                    || 'UNKNOWN',
      
      // PROPERTY
      bedrooms: d.bedrooms                                      || 'UNKNOWN',
      bathrooms: d.bathrooms                                    || 'UNKNOWN',
      finishedSqFt: d.finishedSqFt                              || 'UNKNOWN',
      yearBuilt: d.yearBuilt                                    || 'UNKNOWN',

      // MONEY
      price: d.localRealEstate.region.zindexValue               || 'UNKNOWN',
      rent: d.rentzestimate ? d.rentzestimate.amount._ : 0      || 'UNKNOWN',
      taxYear: d.taxAssessmentYear                              || 'UNKNOWN',
      tax: d.taxAssessment                                      || 'UNKNOWN',
      hoa: 500,
    });
  });

  return res;
};

module.exports = dataAdapter;