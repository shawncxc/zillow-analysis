# Subset data by input$nBeds & input$nBaths
SubDataFunc <- function(data, beds, baths)
{
  beds <- as.character(beds)
  baths <- as.character(baths)
  
  subData <- data[data$bedrooms == beds & data$bathrooms == baths, ]
  
  subData
}


# Retrieve price infomation by house type
ClassifiedPrice <- function(data, beds, baths)
{
  # Missing data or invalid input
  if(is.null(data) || is.na(beds) || is.na(baths))
  {
    return()
  }
  
  else
  {
    
    tryCatch(SubDataFunc(data, beds, baths), error = function(e){return()})

  }
}


# Preprocessing data
PreprocesData <- function()
{
  #Imoort data
  data_sf <- read.csv("result_deleted_redundant_columns.csv", stringsAsFactors=FALSE)
  
  # Munge data
  temp <- gsub("[\"\\[\\]]*", "", data_sf$latlon)
  temp <- unlist(strsplit(temp, ",", fixed = T))
  temp <- as.data.frame(matrix(temp, ncol = 2, byrow = T))
  colnames(temp) <- c("lat", "lon")
  data_sf <- cbind(data_sf, temp)
  
  # Initially, lat and lon columns are factors
  data_sf$lat <- as.numeric(levels(data_sf$lat))[data_sf$lat]
  data_sf$lon <- as.numeric(levels(data_sf$lon))[data_sf$lon]
  
  # Obtain numeric price
  data_sf$price <- gsub(",", "", data_sf$price)
  data_sf$price <- as.numeric(data_sf$price)
  data_sf <- data_sf[!is.na(data_sf$price), ]
  
  # New: 09/01/2016
  # Remove duplicated row s
  data_sf <- data_sf[!duplicated(data_sf$zpid), ]
  
  # Seperate 3 data sets: overvalued, average, undervalued
  data_sf <- data_sf[order(data_sf$price, decreasing = F), ]
  
  data_sf$label <- "overvalued"
  data_sf$label[data_sf$price >= quantile(data_sf$price, 0.25) & 
                  data_sf$price <= quantile(data_sf$price, 0.75)] <- "average"
  data_sf$label[data_sf$price < quantile(data_sf$price, 0.25)] <- "undervalued"
  
  
  # New: 09/01/2016
  # Calculate per sqft price for house, without unknown data
  data_sf$finishedSqFt[data_sf$finishedSqFt == "UNKNOWN"] <- NA
  data_sf$finishedSqFt <- as.numeric(data_sf$finishedSqFt)
  data_sf$perSqFtPrice <- data_sf$price / data_sf$finishedSqFt
  
  # Price per sqrt
  perSqFtPrice <- data_sf[!is.na(data_sf$perSqFtPrice), c( "lon", "lat",
                                                           "bedrooms", "bathrooms",
                                                           'street', "city", "state", 
                                                           "zipcode", "perSqFtPrice")]
                                                           
  # Drop redundant columns
  data_sf = data_sf[, c( "lon", "lat",
                         "bedrooms", "bathrooms",
                         'street', "city", "state", 
                         "zipcode", "price", "label")]                                                         
  
  data_tot = list(data_sf = data_sf, perSqFtPrice = perSqFtPrice)
  
  data_tot
}


# Add palette function
pal <- colorFactor(c("dimgrey", "red", "blue"), 
                   domain = c("average", "overvalued", "undervalued"),
                   ordered = T)


# New: 09/23/2016
# House prices should be classified by subdata, label change interactively
InteractLabel <- function(data, label_react, beds, baths)
{
  subdata <- SubDataFunc(data, beds, baths)
  subdata <- na.omit(subdata)
  
  if(nrow(subdata) == 1)
  {
    subdata$label <- "average"
  }
  
  else
  {
    subdata$label <- "overvalued"
    
    subdata$label[subdata[label_react] >= quantile(subdata[[label_react]], 0.25) & 
                  subdata[label_react] <= quantile(subdata[[label_react]], 0.75)] <- "average"
    subdata$label[subdata[label_react] < quantile(subdata[[label_react]], 0.25)] <- "undervalued"
  }

  
  subdata
}
