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

/*
{  
   zpid:'15195335',
   links:{  
      homedetails:'http://www.zillow.com/homedetails/20-Victoria-St-San-Francisco-CA-94132/15195335_zpid/',
      graphsanddata:'http://www.zillow.com/homedetails/20-Victoria-St-San-Francisco-CA-94132/15195335_zpid/#charts-and-data',
      mapthishome:'http://www.zillow.com/homes/15195335_zpid/',
      comparables:'http://www.zillow.com/homes/comps/15195335_zpid/'
   },
   address:{  
      street:'20 Victoria St',
      zipcode:'94132',
      city:'San Francisco',
      state:'CA',
      latitude:'37.711141',
      longitude:'-122.464988'
   },
   FIPScounty:'6075',
   useCode:'SingleFamily',
   taxAssessmentYear:'2015',
   taxAssessment:'327881.0',
   yearBuilt:'1951',
   lotSizeSqFt:'2500',
   finishedSqFt:'1025',
   bathrooms:'1.0',
   totalRooms:'4',
   lastSoldDate:'08/16/1988',
   lastSoldPrice:{  
      currency:'USD',
      '$t':'210000'
   },
   zestimate:{  
      amount:{  
         currency:'USD',
         '$t':'734006'
      },
      'last-updated':'09/04/2016',
      oneWeekChange:{  
         deprecated:'true'
      },
      valueChange:{  
         duration:'30',
         currency:'USD',
         '$t':'-8230'
      },
      valuationRange:{  
         low:[  
            Object
         ],
         high:[  
            Object
         ]
      },
      percentile:'0'
   },
   rentzestimate:{  
      amount:{  
         currency:'USD',
         '$t':'3600'
      },
      'last-updated':'09/04/2016',
      oneWeekChange:{  
         deprecated:'true'
      },
      valueChange:{  
         duration:'30',
         currency:'USD',
         '$t':'0'
      },
      valuationRange:{  
         low:[  
            Object
         ],
         high:[  
            Object
         ]
      }
   },
   localRealEstate:{  
      region:{  
         name:'Ingleside Heights',
         id:'417507',
         type:'neighborhood',
         zindexValue:'688,100',
         links:[  
            Object
         ]
      }
   }
}
 */