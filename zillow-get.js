#!/usr/bin/env node

var command = require('commander');
var genCSV = require('./genCSV.js');

command
  .version('0.0.1')
  .option('-a, --address', 'Add Address')
  .option('-c, --city', 'Add City')
  .option('-s, --state', 'Add State')
  .option('-f, --flag', 'Generate CSV')
  .parse(process.argv);

var args = command.args;
if (command.address && command.city && command.state) {
  genCSV(args[0], args[1], args[2], args[3]);
} else if (command.city && command.state) {
  var addresses = ['1190 Mission St', '1188 Mission St', '500 Market St'];
  addresses.forEach(addr => {
    genCSV(addr, args[0], args[1], args[2]);  
  });
} else {
  console.log('You have to pass in all the fields that are required.');
}