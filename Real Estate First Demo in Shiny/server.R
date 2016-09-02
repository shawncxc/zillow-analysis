
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(leaflet)
source("data_preparation.R")


# Shiny Server
shinyServer(function(input, output) {
#  city <- reactive(input$City)

    
    # Output the inital map and data
    output$mymap <- renderLeaflet({
      
      if(input$City == "San Francisco")
      {
        
        leaflet(data_sf) %>%
          addTiles() %>%
          addCircles(lng = ~lon, lat = ~lat, weight = 1, radius = 3,
                     color = "black", fillOpacity = 0.5)
        
      }

      else
      {
        leaflet() %>%
          addTiles() %>%  # Add default OpenStreetMap map tiles
          setView(lng=-74.0265753, lat=40.7452317, zoom = 12)
        
      }
      
      
    })
    
    
    # Output the boxplot
    output$boxPlot <- renderPlot({
      
      if(input$City == "San Francisco")
      {
        
        boxplot((price/(1e+06))~label, data = data_sf, col = c("dimgrey", "red", "blue"),
                horizontal = T, main = "Boxplot for House Price", ylab ="Category",
                xlab ="House Price", axes= F)
        box()
        mtext("* M means million US Dollars", side = 1, line = 4)
        
        axis(2, at = c(1,2,3), labels = c("average", "overvalued", "undervalued"))
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
                     weight = 1, radius = 3, color = "blue", fillOpacity = 0.5)%>%
          addLegend("bottomright", color = c( "dimgrey", "red", "blue"),
                    title = "House Location",
                    labels = c("average", "overvalued", "undervalued"),
                    opacity = 1)

      }
      

    })



})
