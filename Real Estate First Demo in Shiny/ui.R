
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(leaflet)

# Shiny UI
shinyUI(fluidPage(

  # Application title
  titlePanel("Real Estate First Demo"),
  
  sidebarLayout(
    
    sidebarPanel(
      selectInput(
        'City', 'Select a City', choices = c("None", "San Francisco"), selected = "None",
        selectize = FALSE
      ),
      
      br(),
      br(),
      
      img(src = "Zillowlogo.png")
      
    ),
    
    mainPanel(
      h2("Analysis and Data Visualization"),
      
      leafletOutput("mymap"),
      br(),
    
      plotOutput("boxPlot"),
      br(),
      
     # verbatimTextOutput("summary"),
    #br(),
    
      leafletOutput("categoricalMap"),
      br()
  
    )
  )


))
