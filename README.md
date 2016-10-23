# Zillow-Analysis


----------


## Intro
* **Get data from Zillow API by using NodeJS script**
* **Analyze the real property data using R**
* **Real estate analysis for self purpose**


----------


## Get the data

* Npm install
* Get yourself a zillow api token
* Set up the config.json which contains the zillow api token
* `node zillow-get -a "ADDRESS" -c "CITY" -s "STATE" -f "IF_YOU_WANT_CSV"`
* To get all the real property in one area: `node getAllRealProperty.js`
* But remember zillow has a limit for 1000 request per day

That's it! 

      Usage: zillow-get [options]
    
      Options:
    
        -h, --help     output usage information
        -V, --version  output the version number
        -a, --address  Add Address 
        -c, --city     Add City
        -s, --state    Add State
        -f, --flag     Generate CSV
        -g, --getALL   Get all properties
        -x, --saveDB   Save all properties to mongodb
        (-x will save all properties to your local mongodb, db name: zillow, collection: properties)

*Address flag this can be omitted, and will get all the addresses        


----------


## Data Analysis 
#### Link of the Demo in Shiny: https://xuanzhou.shinyapps.io/Real_Estate_Demo/
#### House Prices Visualization in San Francisco(SF)

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



### Realized 
#### First Demo
* Visulize a part of house prices in SF
* Categorize data into three parts in spite of the types of houses
* Visulize data for each part(average, undervalue and overvalue for per sqft and total prices)
* Add popup window for each house
* Deal with the missing data in the price column: assign the average value calculated from each category to those missing values

#### Second Demo
* Visulize house prices based on house types
* Interactively respond the requests from users
* Add popup window for each house
* Seperate and visulize the data by bedrooms/bathrooms

### Pending 
* Add summary tables for the boxplot
* Histogram in second Demo label colors are not consistant to the precious charts, and the font is too small
* To be continued...
