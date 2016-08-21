# zillow-analysis

#### This repo is used to get data from Zillow API by typing in command line. (Simple real estate analysis for self purpose)

## Simple instruction

* npm install
* get yourself a zillow api token
* set up the config.json which contains the zillow api token
* `node zillow-get -a "ADDRESS" -c "CITY" -s "STATE"`

That's it! 

      Usage: zillow-get [options]
    
      Options:
    
        -h, --help     output usage information
        -V, --version  output the version number
        -a, --address  Add Address
        -c, --city     Add City
        -s, --state    Add State