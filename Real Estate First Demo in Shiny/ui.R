
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com


library(shiny)
library(leaflet)

# Shiny UI
shinyUI(navbarPage(

                   title = "Real Estate Analysis and Data Visualization",
                   
                   tabPanel("Overview",
                            titlePanel("First Demo"), # Application title,
                            
                            sidebarLayout(
                              
                              sidebarPanel(
                                selectInput(
                                  'City', 'Select a City', choices = c("None", "San Francisco"), 
                                  selected = "None", selectize = FALSE),
                                
                                uiOutput("notice1"),
                                br(),
                                br(),
                                
                                img(src = "Zillowlogo.png")
                                
                              ),
                              
                              mainPanel(
                                h2("Overview of the House Price"),
                                br(),
                                
                                leafletOutput("mymap"),
                                br(),
                                
                                plotOutput("boxPlot"),
                                br(),
                                
                                # verbatimTextOutput("summary"),
                                #br(),
                                
                                leafletOutput("categoricalMap"),
                                br(),
                                
                                # New: 09/01/2016
                                leafletOutput("perSqFtPriceMap"),
                                br()
                                
                                
                                
                              )
                            )
                   ),
                   
                   
                   tabPanel("House Type Classification",
                            
                            
                            titlePanel("Second Demo"), # Application title,
                            
                            sidebarLayout(
                              
                              
                              sidebarPanel(
                                selectInput('City2', 'Select a City',
                                            choices = c("None", "San Francisco"),
                                            selected = "None", selectize = FALSE),
                                
                                
                                
                                # uiOutput create a Shiny interactive UI element
                                uiOutput("BathsNBeds"),
                                uiOutput("warning"),
                                
                                br(),
                                br(),
                                
                                img(src = "Zillowlogo.png")
                                
                              ),
                              
                              mainPanel(
                                h2("Price Visualization Based on House Type"),
                                br(),
                                
                                uiOutput("notice2"),
                                leafletOutput("classifiedPrice")
                                br(),
                                br()
                              )
                              
                            )),
                   
                   
                   tabPanel("To Be Continued...")
                   
                   
))
