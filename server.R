#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#


# Define server logic required to draw a histogram
shinyServer(function(input, output,session) {
  
  conn <- dbConnector(session, dbname = dbname)
  q1 <- reactive(dbGetData(conn = conn, tblname = qq1))
  q2 <- reactive(dbGetData(conn = conn, tblname = qq2))
  q3 <- reactive(dbGetData(conn = conn, tblname = qq3))
  q4 <- reactive(dbGetData(conn = conn, tblname = qq4))
  q5 <- reactive(dbGetData(conn = conn, tblname = qq5))
  q6 <- reactive(dbGetData(conn = conn, tblname = qq6))
  
  #output$year_range <- renderPrint({input$year})
  
  # observeEvent(input$name, {
  #   choices = unique(q1()$team_long_name)
  #   updateSelectizeInput(session, inputId = "name", choices = choices)
  # })
  
  # output$win_season <- renderPlotly({
  #   p1 = q1() %>%
  #     filter(team_long_name == input$name & start %in% input$year[1]:input$year[2]) %>%
  #     ggplot(., aes(x = season, y = win_pctg)) + 
  #     geom_line(group = 1) + 
  #     geom_point(size=2, shape=20) +
  #     labs(x = "win percentage",
  #          y = "season") +
  #     theme(axis.text = element_text(size = 9),
  #           axis.title = element_text(size = 12))
  #   
  #   ggplotly(p1)
  #   
  # })
  # 
  
# win percentage for every team, every country from 2008 to 2016
  observe({updateSelectizeInput(session, 'b',
                       choices = unique(q1()$country),
                       server = TRUE
  )})

  observeEvent(input$b, {
    choices = unique(q1()$team_long_name[q1()$country %in% input$b])
    updateSelectizeInput(session, inputId = "c", choices = choices)
  })

  output$all_win_season <- renderPlotly({
    p2 <- q1() %>%
      filter(start %in% input$a[1]:input$a[2] & country %in% input$b  & team_long_name %in% input$c) %>%
      ggplot(., aes(x = season, y = win_pctg)) + 
      geom_smooth(aes(group = team_long_name, color = team_long_name), se = FALSE) + 
      geom_point(size=2, shape=20, aes(color = team_long_name)) +
      ylab("Win Percentage") 

    ggplotly(p2)
  })
  
# datatable of players  
  output$playertable <- DT::renderDataTable(DT::datatable({
    data <- q2() %>%
      select(player_name, height, weight, date, overall_rating, potential, preferred_foot) %>%
      rename(rating = overall_rating)
    data
  }))
  
# overall rating for every players changing with year  
  output$playersinfo <- renderPlotly({
    q2() %>%
      select(player_name, date, overall_rating, potential, preferred_foot) %>%
      filter(player_name %in% input$d) %>%
      ggplot(., aes(x = date, y = overall_rating)) +
      geom_smooth(aes(group = player_name, color = player_name), se = FALSE) + 
      theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
      theme(legend.position="bottom", legend.box = "horizontal")

  })

  observe({updateSelectizeInput(session, 'd',
                       choices = unique(q2()$player_name),
                       server = TRUE
  )})

# intuition 1: Home Advantage
  output$homeaway <- renderPlotly({
    p4 <- q3() %>%
      ggplot() +
      geom_col(aes(x = start, y = n, fill = win), position = "dodge") +
      ylab("Number of Matches") + 
      scale_fill_brewer(palette = "OrRd")
    
    ggplotly(p4)
  })

# tabName = "teaminformation" plot1
  output$allgoal <- renderPlotly({
    p5 <- q4() %>%
      group_by(name, season) %>%
      summarise(goal = sum(goal), n = n(), avg_goal = sum(goal)/n()) %>%
      ggplot() +
      geom_col(aes(x = season, y = avg_goal, fill = name), position = "dodge") +
      ylab("Average Goal Number") +
      scale_fill_brewer(palette = "Set3")
    ggplotly(p5)
  })

# tabName = "teaminformation" plot2
  output$gamenum <- renderPlotly({
    tmp <- q4() %>%
      group_by(name) %>%
      count() 
    tmp$name <- factor(tmp$name, levels = tmp$name[order(tmp$n)])
    p6 <- tmp %>%
      ggplot() +
      geom_col(aes(x = name, y = n,fill = name)) +
      scale_fill_brewer(palette = "Set3") +
      ylab("Number of Games") +
      xlab("League(Country)") +
      coord_flip() + theme(legend.position = "none") 
    
    ggplotly(p6)
  })
  
# intuition 2: how to be a good player
  output$coe <- renderPlotly({
    q5() %>%
      ggplot() +
      geom_col(aes(x = index, y = coe, fill = index)) + 
      coord_flip() + theme(legend.position = "none") 
  })
  
# intuition 3: market value
  output$value <- renderPlotly({
    p7 <- q6() %>%
      ggplot(aes(x = Value, y = win_pctg)) + 
      geom_point(aes(color = country)) +
      xlab("Market Value of Team (million pounds)")
  })

})
