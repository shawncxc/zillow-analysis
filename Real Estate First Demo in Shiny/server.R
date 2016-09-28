
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com


library(shiny)
library(leaflet)
source("functions.R")

test <- PreprocesData()
data_sf <- test$data_sf
perSqFtPrice <- test$perSqFtPrice


# Shiny Server
shinyServer(function(input, output) {
  ###############################################
  ###############################################
  # 1st Demo

  # Show a notice, New: 09/10/2016
  output$notice1 <- renderUI({
    # Need to be modified: let control flow choose data interactively
    if(input$City == "San Francisco")
    {
      div(strong("Click on the House to Get More Information"), style = "color:blue")
      
    }
    
  })
  
  
  # Output the inital map and data
  output$mymap <- renderLeaflet({
    
    if(input$City == "San Francisco")
    {
      
      leaflet(data_sf) %>%
        addTiles() %>%
        addCircles(lng = ~lon, lat = ~lat, weight = 1, radius = 3, 
                   color = "black", fillOpacity = 0.5,
                   popup = ~paste(paste0("<b>Price", ": $", price, "</b>"),
                                  paste0("Beds: ", bedrooms, " Baths: ", bathrooms),
                                  street, paste(city, state, zipcode), 
                                  sep = "<br/>")) %>%
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
  
  
  # Output the barplot, Modified: 09/17/2016
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
      round(fivenum(data_sf[data_sf$label ==  "undervalued", 'price'] / 1e+06), 1) %>%
        text(labels = paste(., "M", sep = ""), y=2.5 , cex = 0.8)
      
      round(fivenum(data_sf[data_sf$label ==  "overvalued", 'price'] / 1e+06), 1) %>%
        text(labels = paste(., "M", sep = ""), y=1.5, cex = 0.8)
      
      round(fivenum(data_sf[data_sf$label ==  "average", 'price'] / 1e+06), 1) %>%
        text(labels = paste(., "M", sep = ""), y=0.5, cex = 0.8)
      
    }
    
    
  })
  
  
  
  # Output the categorical map by total price
  output$categoricalMap <- renderLeaflet({
    
    if(input$City == "San Francisco")
    {
      leaflet(data_sf) %>%
        addTiles() %>%
        addCircles(lng = ~lon, lat = ~lat,
                   weight = 1, radius = 3, 
                   color =  ~pal(label), fillOpacity = 0.5,
                   popup = ~paste(paste0("<b>Class", ": ", label, "</b>"),
                                  paste0("<b>Price", ": $", price, "</b>"),
                                  paste0("Beds: ", bedrooms, " Baths: ", bathrooms),
                                  street, paste(city, state, zipcode), 
                                  sep = "<br/>")) %>%
        addLegend("bottomright", pal = pal, values = ~label,
                  title = "House Classification by Total Price",
                  opacity = 1)
      
      
    }
    
    
  })
  

  # Output the categorical map by per sqft price
  output$perSqFtPriceMap <- renderLeaflet({
    
    if(input$City == "San Francisco")
    {
      
      leaflet() %>%
        addTiles() %>%
        addCircles(data=perSqFtPrice[perSqFtPrice$perSqFtPrice > quantile(perSqFtPrice$perSqFtPrice, 0.75), ], 
                   lng = ~lon, lat = ~lat, weight = 1, radius = 3, color = "red", fillOpacity = 0.5,
                   popup = ~paste(paste0("<b>Class: overvalued</b>"),
                                  paste0("<b>Sqft Price", ": $", round(perSqFtPrice), "</b>"),
                                  paste0("Beds: ", bedrooms, " Baths: ", bathrooms),
                                  street, paste(city, state, zipcode), 
                                  sep = "<br/>"))%>%
        addCircles(data=perSqFtPrice[perSqFtPrice$perSqFtPrice >= quantile(perSqFtPrice$perSqFtPrice, 0.25)
                                     & perSqFtPrice$perSqFtPrice <= quantile(perSqFtPrice$perSqFtPrice, 0.75), ],
                   lng = ~lon, lat = ~lat, weight = 1, radius = 3, color = "dimgrey", fillOpacity = 0.5,
                   popup = ~paste(paste0("<b>Class: average</b>"),
                                  paste0("<b>Sqft Price", ": $", round(perSqFtPrice), "</b>"),
                                  paste0("Beds: ", bedrooms, " Baths: ", bathrooms),
                                  street, paste(city, state, zipcode), 
                                  sep = "<br/>"))%>%
        addCircles(data=perSqFtPrice[perSqFtPrice$perSqFtPrice < quantile(perSqFtPrice$perSqFtPrice, 0.25), ], 
                   lng = ~lon, lat = ~lat, weight = 1, radius = 3, color = "blue", fillOpacity = 0.5,
                   popup = ~paste(paste0("<b>Class: undervalued</b>"),
                                  paste0("<b>Sqft Price", ": $", round(perSqFtPrice), "</b>"),
                                  paste0("Beds: ", bedrooms, " Baths: ", bathrooms),
                                  street, paste(city, state, zipcode), 
                                  sep = "<br/>")) %>%
        addLegend("bottomright", color = c( "dimgrey", "red", "blue"),
                  title = "House Location by Per Sqft Price",
                  labels = c("average", "overvalued", "undervalued"),
                  opacity = 1)
      
    }
    
    
  })
  
  
  ###############################################
  ###############################################
  # 2nd Demo
  
  # Baths and Beds Input UI
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
      
      p("Invalid Number of Bedrooms or Bathrooms Input:",
        br(),
        span("Range Should from 1 to 10", style = "color:blue"),
        br(),
        "Please Try Again!" , style = "color:red")
  
    }
    
  })
  
  
  # Show a notice, New 09/10/2016
  output$notice2 <- renderUI({

    if( !is.null(input$nBeds) && input$City2 == "San Francisco")
    {
      # Need to be modified: let control flow choose data interactively
      if(!is.null(ClassifiedPrice(data_sf, input$nBeds, input$nBaths)) && nrow(data_sf) != 0)
      {
        #"Click on The House to Get More Information"
        div(strong("Click on the House to Get More Information"), style = "color:blue")

      }
    }

  })

  
  
  # Output the categorical map by house type
  output$classifiedPrice <- renderLeaflet({ 

      if( !is.null(input$nBeds) && input$City2 == "San Francisco")
      {
        # Need to be modified: let control flow choose data interactively  
        if(!is.null(ClassifiedPrice(data_sf, input$nBeds, input$nBaths)) && nrow(data_sf) != 0
           && nrow(ClassifiedPrice(data_sf, input$nBeds, input$nBaths)) != 0)
        {
        
          subdata <- InteractLabel(data_sf, "price", input$nBeds, input$nBaths)
          if(!is.null(subdata_bedNbath))
          {
            leaflet(subdata_bedNbath) %>%
              addTiles() %>%
              addCircles(lng = ~lon, lat = ~lat,
                         weight = 1, radius = 3,
                         color =  ~pal(label), fillOpacity = 0.5,
                         popup = ~paste(paste0("<b>Class: ",label, "</b>"),
                                        paste0("<b>Price", ": $", price, "</b>"),
                                        street, paste(city, state, zipcode),
                                        sep = "<br/>")) %>%
              addLegend("bottomright", pal = pal, values = ~label,
                        title = "House Classification by House Type",
                        opacity = 1)
          }
          
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
   
    
  # New 09/25/16
  # Summary of output the categorical map by house type
  output$summaryBedNBath <- renderPrint({

    if( !is.null(input$nBeds) && input$City2 == "San Francisco")
    {
      # Need to be modified: let control flow choose data interactively  
      if(!is.null(ClassifiedPrice(data_sf, input$nBeds, input$nBaths)) && nrow(data_sf) != 0
         && nrow(ClassifiedPrice(data_sf, input$nBeds, input$nBaths)) != 0)
      {
        
        # Need to be modified: It is not reactive
        subdata_bedNbath <- InteractLabel(data_sf, "price", input$nBeds, input$nBaths)
        
        if(!is.null(subdata_bedNbath))
        {
          # Overall summary
          cat("Overall Price Summary:")
          cat("\n")
          cat("\n")
          cat(paste0("Total Number of ", input$nBeds,"Beds & ", input$nBaths, 
                     "Baths Houses: ", nrow(subdata_bedNbath)))
          cat("\n")
          cat("Overall Price Range(USD): ")
          temp <- summary(subdata_bedNbath$price)
          cat(paste0("Min: $", temp[1], "  Median: $", temp[3],
                     "  Mean: $", temp[4], "  Max: $", temp[6]))
          cat("\n")
          cat("\n")
          cat("\n")

          # House price summary by house type
          cat("Price Summary by House Value(USD):")
          cat("\n")
          cat("\n")
          
          cat(paste0("            ", "Number of Houses  ",
                     "   Min   ", "   Median   ",
                     "    Mean    ", "     Max"))
          cat("\n")
          
          #unique_type <- length(unique(subdata_bedNbath$label))
          unique_type <- unique(subdata_bedNbath$label)
          for(htype in unique_type)
          {
            htype_summ <- summary(subdata_bedNbath$price[subdata_bedNbath$label == htype])
            cat(paste0(htype, "         ", sum(subdata_bedNbath$label == htype),
                       "          ", htype_summ[1], "     ", htype_summ[3], "     ", htype_summ[4],
                       "     ", htype_summ[6]))
            cat("\n")
          }
          
        }
        
        else
        {
          cat("No Price Information")
        }
      
      }

      # No data available
      else 
      {
        cat("No Price Information")
      }
      
    }
    
    else
    {
      cat("No Price Information")
    }

    
})
