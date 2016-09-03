
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com


library(shiny)
library(leaflet)
source("data_preparation.R")
source("functions.R")


# Shiny Server
shinyServer(function(input, output) {
  ###############################################
  ###############################################
  # 1st Demo
  
  
  # Output the inital map and data
  output$mymap <- renderLeaflet({
    
    if(input$City == "San Francisco")
    {
      
      leaflet(data_sf) %>%
        addTiles() %>%
        addCircles(lng = ~lon, lat = ~lat, weight = 1, radius = 3, 
                   color = "black", fillOpacity = 0.5) %>%
        addLegend("bottomright", color = "black",
                  labels = "House Location",
                  opacity = 1)
      
    }
    
    else
    {
      leaflet() %>%
        addTiles() %>%  # Add default OpenStreetMap map tiles
        setView(lng=-74.0265753, lat=40.7452317, zoom = 12)
      
    }
    
  })
  
  
  # Output the barplot
  output$boxPlot <- renderPlot({
    
    if(input$City == "San Francisco")
    {
      
      boxplot((price/(1e+06))~label, data = data_sf, col = c("dimgrey", "red", "blue"),
              horizontal = T, main = "Boxplot for House Price", ylab ="Category",
              xlab ="House Price", axes= F)
      box()
      mtext("* M means million US Dollars", side = 1, line = 4)
      
      axis(2, at = c(1,2,3), labels = c("average", "overvalued", "undervalued"))
      
      # Need to be modified, if prices in an area are less than one million
      price <-  pretty(data_sf$price / (1e+06))
      axis(1, at = price, 
           labels = paste(price, "M", sep = ""))
      
      # Add median, quartlie infomation
      # Use "magrittr": "%>%", forward-pipe operator, to minimize the need for local variables
      round(fivenum(undervalued$price / 1e+06), 1) %>%
        text(labels = paste(., "M", sep = ""), y=2.5 , cex = 0.8)
      
      round(fivenum(overvalued$price / 1e+06), 1) %>%
        text(labels = paste(., "M", sep = ""), y=1.5, cex = 0.8)
      
      round(fivenum(average$price / 1e+06), 1) %>%
        text(labels = paste(., "M", sep = ""), y=0.5, cex = 0.8)
      
    }
    
  })
  

  
  # Output the categorical map by total price
  output$categoricalMap <- renderLeaflet({
    
    if(input$City == "San Francisco")
    {
      
      leaflet() %>%
        addTiles() %>%
        addCircles(data=overvalued, lng = ~lon, lat = ~lat, 
                   weight = 1, radius = 3, color = "red", fillOpacity = 0.5)%>%
        addCircles(data=average, lng = ~lon, lat = ~lat, 
                   weight = 1, radius = 3, color = "dimgrey", fillOpacity = 0.5)%>%
        addCircles(data=undervalued, lng = ~lon, lat = ~lat, 
                   weight = 1, radius = 3, color = "blue", fillOpacity = 0.5) %>%
        addLegend("bottomright", color = c( "dimgrey", "red", "blue"),
                  title = "House Location by Total Price",
                  labels = c("average", "overvalued", "undervalued"),
                  opacity = 1)
      
    }
    
    
  })
  
  
  # New: 09/01/2016
  # Output the categorical map by per sqft price
  output$perSqFtPriceMap <- renderLeaflet({
    
    if(input$City == "San Francisco")
    {
      
      leaflet() %>%
        addTiles() %>%
        addCircles(data=perSqFtPrice[perSqFtPrice$perSqFtPrice > quantile(perSqFtPrice$perSqFtPrice, 0.75), ], 
                   lng = ~lon, lat = ~lat, weight = 1, radius = 3, color = "red", fillOpacity = 0.5)%>%
        addCircles(data=perSqFtPrice[perSqFtPrice$perSqFtPrice >= quantile(perSqFtPrice$perSqFtPrice, 0.25)
                                     & perSqFtPrice$perSqFtPrice <= quantile(perSqFtPrice$perSqFtPrice, 0.75), ],
                   lng = ~lon, lat = ~lat, weight = 1, radius = 3, color = "dimgrey", fillOpacity = 0.5)%>%
        addCircles(data=perSqFtPrice[perSqFtPrice$perSqFtPrice < quantile(perSqFtPrice$perSqFtPrice, 0.25), ], 
                   lng = ~lon, lat = ~lat, weight = 1, radius = 3, color = "blue", fillOpacity = 0.5) %>%
        addLegend("bottomright", color = c( "dimgrey", "red", "blue"),
                  title = "House Location by Per Sqft Price",
                  labels = c("average", "overvalued", "undervalued"),
                  opacity = 1)
      
    }
    
    
  })
  
  ###############################################
  ###############################################
  # 2nd Demo
  
  
  output$BathsNBeds <- renderUI({
    
    
    if(input$City2 != "None")
    {
      fluidRow(
        column(12,numericInput("nBeds", "Number of Bedrooms:",
                               value = 1,min = 0, max = 10, step =  1)),
        column(12,numericInput("nBaths", "Number of Bathrooms:",
                               value = 1,min = 0, max = 10, step =  0.5))
      )
      
      
    }
    
  })
  
  
  # Get a message if input of bedrooms or bathrooms is illegal
  output$warning <- renderUI({
    
    # Have not generated nBeds & nBaths
    if(is.null(input$nBeds))
    {
      return()
    }
    
    # Invalid inputs for nBeds & nBaths
    else if((input$nBeds > 10 || input$nBaths > 10) || (input$nBeds < 0 || input$nBaths < 0)
            || (!is.numeric(input$nBeds) || !is.numeric(input$nBaths)))
    {
      return("Invalid Number of Bedrooms or Bathrooms Input: Range from 1 to 10")
    }
    
    
    
  })
  
  
  #### New add
  
  # Output the categorical map by house type
  output$classifiedPrice <- renderLeaflet({ 

      if( !is.null(input$nBeds) && input$City2 == "San Francisco")
      {
        # Need to be modified: let control flow choose data interactively  
        if(!is.null(ClassifiedPrice(data_sf, input$nBeds, input$nBaths)) && nrow(data_sf) != 0)
        {
          # Need to be modified: It is not reactive
          subdata <- SubDataFunc(data_sf, input$nBeds, input$nBaths)
          
          leaflet() %>%
            addTiles() %>%
            addCircles(data= subdata[subdata$label == "overvalued", ], 
                       lng = ~lon, lat = ~lat,
                       weight = 1, radius = 3, color = "red", fillOpacity = 0.5)%>%
            addCircles(data= subdata[subdata$label == "average", ], 
                       lng = ~lon, lat = ~lat,
                       weight = 1, radius = 3, color = "dimgrey", fillOpacity = 0.5)%>%
            addCircles(data= subdata[subdata$label == "undervalued", ], 
                       lng = ~lon, lat = ~lat,
                       weight = 1, radius = 3, color = "blue", fillOpacity = 0.5) %>%
            addLegend("bottomright", color = c( "dimgrey", "red", "blue"),
                      title = "House Location by Total Price",
                      labels = c("average", "overvalued", "undervalued"),
                      opacity = 1)
        }
        
        # No data available
        else 
        {
          leaflet() %>%
            addTiles() %>%  # Add default OpenStreetMap map tiles
            addPopups(lng=-74.0265753, lat=40.7452317, popup =paste(sep = "<br/>",
                                                                    "<b>No Data Available:</b>",
                                                                    "<b>Please Try Again</b>"),
                      options = popupOptions(closeButton = FALSE))
        
        }
        
      }
    
    else
    {
      leaflet() %>%
        addTiles() %>%  # Add default OpenStreetMap map tiles
        setView(lng=-74.0265753, lat=40.7452317, zoom = 12)
      
    }
      

    })
    
  #### New add

  
  
})
