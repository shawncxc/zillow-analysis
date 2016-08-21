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
        

## First Demo (House Prices Visualization in San Francisco):
* normalize the data, get the overall summary
* group the data by three catergories:  overvalued, average, undervalued

Question: Should I use one standard deviation (sd) method or quantile segmentation (qs)?

---------   overvalued ----------- average ----------- undervalued 
   
1 sd:  -----   > +1sd  ------   -1sd<= x <= +1sd   ------     < -1sd 

qs: -----   1st quantile  ----   2nd & 3r quantile  ---- 4thquantile

Actually, this demo performs exploratory data analysis.
