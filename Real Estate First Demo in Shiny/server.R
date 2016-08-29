
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(leaflet)

#Imoort data
data_sf <- read.csv("data_sf.csv", stringsAsFactors=FALSE)

# Munge data
data_sf$price <- gsub(",", "", data_sf$price)
data_sf$price <- as.numeric(data_sf$price)
data_sf <- data_sf[!is.na(data_sf$price), ]

# Seperate 3 data sets: overvalued, average, undervalued
data_sf <- data_sf[order(data_sf$price, decreasing = F), ]

data_sf$label <- "overvalued"
data_sf$label[data_sf$price >= quantile(data_sf$price, 0.25) & 
                data_sf$price <= quantile(data_sf$price, 0.75)] <- "average"
data_sf$label[data_sf$price < quantile(data_sf$price, 0.25)] <- "undervalued"

overvalued <- data_sf[data_sf$label ==  "overvalued", ]
average <- data_sf[data_sf$label ==  "average", ]
undervalued <- data_sf[data_sf$label ==  "undervalued", ]


# Shiny Server
shinyServer(function(input, output) {
#  city <- reactive(input$City)

    
    # Output the inital map and data
    output$mymap <- renderLeaflet({
      
      if(input$City == "San Francisco")
      {
        
        leaflet(data_sf) %>%
          addTiles() %>%
          addCircles(lng = ~lon, lat = ~lat, weight = 1, radius = 3)
        
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
        boxplot(price~label, data = data_sf, col = c("dimgrey", "red", "green"),
                main = "Boxplot for House Price")
        
      }
      
      
    })
    
    
    # Output the categorical map
    output$categoricalMap <- renderLeaflet({

      if(input$City == "San Francisco")
      {
        
        leaflet() %>%
          addTiles() %>%
          addCircles(data=overvalued, lng = ~lon, lat = ~lat, 
                     weight = 1, radius = 3, color = "red")%>%
          addCircles(data=average, lng = ~lon, lat = ~lat, 
                     weight = 1, radius = 3, color = "dimgrey")%>%
          addCircles(data=undervalued, lng = ~lon, lat = ~lat, 
                     weight = 1, radius = 3, color = "blue")

      }
      

    })



})
