#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

# Define UI for application that draws a histogram
shinyUI(dashboardPage(skin = 'green',
  
  # Application title
  dashboardHeader(title = "Soccer Intelligence"),
  # Application sidebar
  dashboardSidebar(
    
    sidebarUserPanel("NYC DSA",
                     image = "https://cdn.pixabay.com/photo/2013/07/13/10/51/football-157930_1280.png"),
    sidebarMenu(
      menuItem("Overview", tabName = "introduction", icon = icon("calendar")),
      menuItem("Team Information", tabName = "teaminformation", icon = icon("tower", lib = "glyphicon")),
      menuItem("Player Information", tabName = "playerinformation", icon = icon("user", lib = "glyphicon")),
      menuItem("Intuitions", tabName = "intuitions", icon = icon("sunglasses", lib = "glyphicon"))
    )
  ),
  
  # Dashboard Body
  dashboardBody(
    tabItems(
      tabItem(tabName = "introduction",  
              fluidRow(
                column(width = 12, offset = 0,
                       tags$h2(strong("Overview"), align = "center")
                       ),
                column(width = 8, offset = 2,
                       tags$h4("In a game as fluid as soccer, with so many variables interacting at once, 
                               we can use analytical techniques to help with game strategy, team build, player training.", align = "justify")
                       ),
                column(width = 10, offset = 3,
                       tags$h4(strong("In this application, you can find: "), align = "left"),
                       tags$h4("1. Team information and comparisons from 11 largest European soccer teams.", align = "left"),
                       tags$h4("2. Soccer players information.", align = "left"),
                       tags$h4("3. Some strategies might be helpful to win!", align = "left")),
                HTML('<center><img src="https://cdn.pixabay.com/photo/2018/06/12/20/17/football-3471402_1280.jpg" width="800" height="450"></center>')
              )),
      
      tabItem(tabName = "teaminformation",  
             fluidRow(
               tabsetPanel(
                 tabPanel("Overview of games by European Leagues from 2008 to 2016",
                          br(),
                          br(),
                          fluidRow(
                            column(width = 4,
                                   box(height = 500, title = strong("Total number of games in every league"), 
                                       width = NULL, solidHeader = TRUE, status = "warning",plotlyOutput("gamenum"))),
                            column(width = 8,
                                   box(height = 500, title = strong("Total number of games in every league"), 
                                       width = NULL, solidHeader = TRUE, status = "warning",plotlyOutput("allgoal"))),
                            column(width = 10, offset = 1,
                                   tags$h4(strong("Dataset: "), "kaggle European Soccer Database", align = "left")))
                          ),
                 
                 tabPanel("Comparison between teams",
                          column(width = 4, sliderInput(inputId = "a", label = h4(strong("year range")),min = 2006, max = 2017,value = c(2010,2014))),
                          column(width = 4, selectizeInput(inputId = "b", label = h4(strong("countries")), choices = NULL, selected = c("Poland") ,multiple = TRUE)),
                          column(width = 4, selectizeInput(inputId = 'c', label = h4(strong("teams")), choices = NULL, selected = c("CHO"), multiple = TRUE)),
                          fluidRow(
                            column(width = 10, offset = 1,
                                   box(
                                     height = 450,
                                     width = NULL, solidHeader = FALSE, status = "warning",
                                     plotlyOutput("all_win_season"))),
                            column(width = 10, offset = 1,
                                   tags$h4(strong("Dataset: "), "kaggle European Soccer Database", align = "left"))
                                  )
                          )
                          )
                      )
            ),
    
    tabItem(tabName = "playerinformation",
            fluidRow(
              column(
                width = 12,
                DT::dataTableOutput("playertable")),
              br(),
              br(),
              column(width = 10, offset = 1,
                     selectizeInput(inputId = "d", label = h4(strong("Player Name")), choices = NULL, multiple = TRUE),
                     box(
                       height = 500, title = strong("Player Overall Rating"), 
                       width = NULL, solidHeader = TRUE, status = "warning",
                       plotlyOutput("playersinfo"))),
              column(width = 10, offset = 1,
                     tags$h4(strong("Dataset: "), "kaggle European Soccer Database", align = "left"))         
                    )
            ),
    
    tabItem(tabName = "intuitions",
            fluidRow(
              tabsetPanel(
                tabPanel("Home or Away",
                         fluidRow(
                           br(),
                           br(),
                           column(width = 8,
                                  box(height = 455, title = strong("Player Overall Rating"), 
                                      width = NULL, solidHeader = TRUE, status = "warning",
                                      plotlyOutput("homeaway"))),
                           column(width = 4,
                                  box(height = 455, title = strong("Conclusion"), width = NULL,
                                      solidHeader = TRUE, status = "warning",
                                      tags$h4(strong("Home Advantage:")),
                                      tags$h4("Plot shows home team wins almost twice number of games of away team,
                                               which is reasonable because in home game court, most of fans and supporters  
                                              are here for the home team.", align = "justify"))),
                           column(width = 10, offset = 1,
                                  tags$h4(strong("Dataset: "), "kaggle European Soccer Database", align = "left"))
                                  )
                        ),
                
                tabPanel("How to be a good player",
                         fluidRow(
                           br(),
                           br(),
                           column(width = 8,
                                  box(height = 455, title = strong("Player Overall Rating"), 
                                      width = NULL, solidHeader = TRUE, status = "warning",
                                      plotlyOutput("coe"))),
                           column(width = 4,
                                  box(height = 455, title = strong("Conclusion"), width = NULL,
                                      solidHeader = TRUE, status = "warning",
                                      tags$h4(strong("Important Features Top 5:"), align = "left"),
                                      tags$h4("1. Reaction", align = "left"),
                                      tags$h4("2. Goal keeper diving", align = "left"),
                                      tags$h4("3. Ball Control", align = "left"),
                                      tags$h4("4. Age", align = "left"),
                                      tags$h4("5. Heading Accuracy", align = "left"))),
                           column(width = 10, offset = 1,
                                  tags$h4(strong("Dataset: "), "kaggle European Soccer Database", align = "left"))
                                  )
                        ),
                
                tabPanel("The importance of market value",
                         fluidRow(
                           br(),
                           br(),
                           column(width = 8,
                                  box(height = 455, title = strong("Player Overall Rating"), 
                                      width = NULL, solidHeader = TRUE, status = "warning",
                                      plotlyOutput("value"))),
                           column(width = 4,
                                  box(height = 455, title = strong("Conclusion"), width = NULL,
                                      solidHeader = TRUE, status = "warning",
                                      tags$h4("", align = "justify"))),
                           column(width = 10, offset = 1,
                                  tags$h4(strong("Dataset: "), "transfermarkt.it", align = "left"))
                                  )
                          )
                          )
                          )
           )

    )  
  )
))
