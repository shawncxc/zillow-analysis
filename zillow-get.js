#!/usr/bin/env node

var command = require('commander');
var genCSV = require('./data_migrate/genCSV.js');
var getAllRealProperty = require('./data_migrate/getAllRealProperty.js');
var saveProperty = require('./data_migrate/db/crud/saveProperty.js');

command
  .version('0.0.1')
  .option('-a, --address', 'Add Address')
  .option('-c, --city', 'Add City')
  .option('-s, --state', 'Add State')
  .option('-f, --flag', 'Generate CSV')
  .option('-g, --getAll', 'Get all real property')
  .option('-x, --saveDB', 'Save to mongodb')
  .parse(process.argv);

var args = command.args;
if (command.address && command.city && command.state) {
  genCSV(args[0], args[1], args[2], args[3]);
} else if (command.getAll) {
  getAllRealProperty();
} else if (command.saveDB) {
  if (command.args.length === 0) {
    saveProperty();
  } else {
    var fromNthStreet = command.args[0];
    fromNthStreet = parseInt(fromNthStreet);
    if (Number.isInteger(fromNthStreet)) {
      saveProperty(fromNthStreet);  
    } else {
      console.log('For flag -x, you should pass in an integer.');
    }
  }
} else {
  console.log('You have to pass in all the fields that are required.');
}