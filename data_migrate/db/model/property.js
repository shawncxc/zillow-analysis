var mongoose = require('mongoose');

var propertySchema = new mongoose.Schema({
  // ID
  zpid: String,
  inc_id: Number,
  street_id: String,
  
  // ADDRESS
  latlon: [Number],
  street: String,
  zipcode: String,
  city: String,
  state: String,
  
  // PROPERTY
  useCode: String,
  bedrooms: Number,
  bathrooms: Number,
  finishedSqFt: Number,
  yearBuilt: String,

  // MONEY
  price: Number,
  rent: Number,
  taxYear: String,
  tax: Number,
});

module.exports = mongoose.model('Property', propertySchema);

/*
{  
   zpid:'15195335',
   address:{  
      street:'20 Victoria St',
      zipcode:'94132',
      city:'San Francisco',
      state:'CA',
      latitude:'37.711141',
      longitude:'-122.464988'
   },
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
}
 */