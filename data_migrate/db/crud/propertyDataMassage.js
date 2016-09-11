var model = function(x, street_id, inc_id) {
  return {
    zpid:             x.zpid,
    inc_id:           inc_id || 0,
    street_id:        street_id || 'UNKNOWN',
    latlon:           [ parseFloat(x.address.latitude), parseFloat(x.address.longitude) ],
    street:           x.address.street || 'UNKNOWN',
    zipcode:          x.address.zipcode || 'UNKNOWN',
    city:             x.address.city || 'UNKNOWN',
    state:            x.address.state || 'UNKNOWN',
    bedrooms:         x.bedrooms ? parseInt(x.bedrooms) : 0,
    bathrooms:        x.bathrooms ? parseInt(x.bathrooms) : 0,
    finishedSqFt:     x.finishedSqFt ? parseInt(x.finishedSqFt) : 0,
    yearBuilt:        x.yearBuilt || 'UNKNOWN',
    price:            x.zestimate.amount.$t ? parseInt(x.zestimate.amount.$t) : 0,
    rent:             x.rentzestimate.amount.$t ? parseInt(x.rentzestimate.amount.$t) : 0,
    taxYear:          x.taxAssessmentYear || 'UNKNOWN',
    tax:              x.taxAssessment ? parseInt(x.taxAssessment) : 0,
    useCode:          x.useCode || 'UNKNOWN',
  };
};

var canMassage = function(x) {
  return x.zpid && x.address && x.zestimate && x.rentzestimate && 
        x.zestimate.amount && x.rentzestimate.amount;
};

module.exports = function (data, street_id, inc_id) {
  data = data.results.result;
  var temp;

  if (Array.isArray(data)) {
    temp = data.map(x => {
      if (canMassage(x)) {
        return model(x, street_id, inc_id);
      }
      return false;
    }).filter(x => {
      return x;
    });
  } else {
    if (canMassage(data)) {
      temp = [model(data, street_id, inc_id)];
    } else {
      temp = [];
    }
  }

  return temp;
};