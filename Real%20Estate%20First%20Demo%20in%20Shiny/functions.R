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