var mongoose = require('mongoose');

var streetSchema = new mongoose.Schema({
  name: String
});

module.exports = mongoose.model('Street', streetSchema);