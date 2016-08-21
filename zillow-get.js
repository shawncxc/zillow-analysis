#!/usr/bin/env node

var command = require('commander');
var genCSV = require('./genCSV.js');

command
  .version('0.0.1')
  .option('-a, --address', 'Add Address')
  .option('-c, --city', 'Add City')
  .option('-s, --state', 'Add State')
  .parse(process.argv);

if (command.address && command.city && command.state) {
  var args = command.args;
  genCSV(args[0], args[1], args[2]);
} else {
  console.log('You have to pass in all the fields that are required.');
}