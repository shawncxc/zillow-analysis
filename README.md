# Zillow-Aanalysis


----------


## Intro
* **Get data from Zillow API by using NodeJS script**
* **Analyze the real property data using R**
* **Real estate analysis for self purpose**


----------


## Get the data

* npm install
* get yourself a zillow api token
* set up the config.json which contains the zillow api token
* `node zillow-get -a "ADDRESS" -c "CITY" -s "STATE" -f "IF_YOU_WANT_CSV"`

That's it! 

      Usage: zillow-get [options]
    
      Options:
    
        -h, --help     output usage information
        -V, --version  output the version number
      -a, --address  Add Address 
        -c, --city     Add City
        -s, --state    Add State
        -f, --flag     Generate CSV

*Address flag this can be omitted, and will get all the addresses        


----------


## Data Analysis 
#### House Prices Visualization in San Francisco

* Normalize the data, get the overall summary
* Group the data by three catergories:  overvalued, average, undervalued
* Use Leaflet library for interactive maps

Thought: 
Should I use one standard deviation (sd) method or quantile segmentation (qs)?

|Method|    Overvalued    |        Average       |   Undervalued   | 
|------|:----------------:|---------------------:|:---------------:|
|  sd  |   \>+1sd(>84%)   |-1sd<=x<=+1sd(16%-84%)|   <-1sd(<16%)   |
|  qs  |    4th q(>75%)   | 2nd & 3rd q(25%-75%) |      1st q(<25%)      |
*q - quantile

This demo performs exploratory data analysis.
I would prefer the qs method for this demo, because it is more interpretable.
