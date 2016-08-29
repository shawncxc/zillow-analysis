#!/usr/bin/env node

var command = require('commander');
var genCSV = require('./genCSV.js');
var getAllRealProperty = require('./getAllRealProperty.js');

command
  .version('0.0.1')
  .option('-a, --address', 'Add Address')
  .option('-c, --city', 'Add City')
  .option('-s, --state', 'Add State')
  .option('-f, --flag', 'Generate CSV')
  .option('-g, --getAll', 'Get all real property')
  .parse(process.argv);

var args = command.args;
if (command.address && command.city && command.state) {
  genCSV(args[0], args[1], args[2], args[3]);
} else if (args.length === 1) {
  getAllRealProperty(args[0]);
} else {
  console.log('You have to pass in all the fields that are required.');
}