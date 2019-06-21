#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
library(shiny)
library(DT)
library(shiny)
library(shinydashboard)

# Define UI for application that draws a histogram
shinyUI(dashboardPage(
  
  # Application title
  #titlePanel("Soccer Intelligence"),
  dashboardHeader(title = "Soccer Intelligence"),
  
  
  dashboardSidebar(
    
    sidebarUserPanel("NYC DSA",
                     image = "https://cdn.pixabay.com/photo/2013/07/13/10/51/football-157930_1280.png"),
    sidebarMenu(
      menuItem("Map", tabName = "map", icon = icon("map")),
      menuItem("Data", tabName = "data", icon = icon("database"))
    ),
    selectizeInput("selected",
                   "Select Item to Display",
                   choice)
  ),
  
  
  # Sidebar with a slider input for number of bins 
  # sidebarLayout(
  #   sidebarPanel(
  #      sliderInput("bins",
  #                  "Number of bins:",
  #                  min = 1,
  #                  max = 50,
  #                  value = 30)
  #   ),
  #   
    # Show a plot of the generated distribution
    # mainPanel(
    #    plotOutput("distPlot")
  dashboardBody()
  
))
