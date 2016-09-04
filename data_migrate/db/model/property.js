var mongoose = require('mongoose');

var propertySchema = new mongoose.Schema({
  // ID
  zpid: String,
  
  // ADDRESS
  latlon: [String, String],
  street: String,
  zipcode: String,
  city: String,
  state: String,
  
  // PROPERTY
  bedrooms: String,
  bathrooms: String,
  finishedSqFt: String,
  yearBuilt: String,

  // MONEY
  price: String,
  rent: String,
  taxYear: String,
  tax: String,
  hoa: Number,
});

module.exports = mongoose.model('Property', propertySchema);