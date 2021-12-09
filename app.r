library(plotly)
library(tidyverse)
library(shiny)
library(data.table)
library(leaflet)
library(magrittr)
library(R.utils)
library(rsconnect)
library(plotly)
library(leaflet)
library(shinydashboard)
library(collapsibleTree)
library(shinycssloaders)
library(DT)
library(tigris)
source("Alex's Page.R")
source("Carl's page.R")
source("Peihang's Page.R")

data <- read.csv("athlete_events.csv")
noc <- read.csv("noc_regions.csv")
data <- merge(data, noc, by = "NOC", all.x = T)

ui <- fluidPage(
  dashboardPage(
    skin = "red",
    dashboardHeader(title = 'Olympics: 120Yrs', titleWidth = 200),
    dashboardSidebar(
      width = 200,
      sidebarMenu(
        menuItem("Introduction", tabName = "intro", icon = icon("home")),
        menuItem("Athelete Gender", tabName = "tab1", icon = icon("venus-mars")),
        menuItem("Athlete Stat", tabName = "tab2", icon = icon("users")),
        menuItem("Height Growth Trends", tabName = "tab3", icon = icon("line-chart")),
        menuItem("Summary", tabName = "tab4", icon = icon("book"))
      )
    ),
    dashboardBody(
      tabItems(
        tabItem(tabName = "intro",
                titlePanel("Introduction"),
                p("This project explores data on the modern Olympic Games, including all the 
  Games from Athens 1896 to Rio 2016. Sports are integral parts of our lives—not
  only are they beneficial to maintaining good health but also as sources of 
  enjoyment when we watch athletes compete on Television. Due to the COVID-19 
  pandemic, the 2020 Tokyo Olympics have been postponed for a year, coming to a 
  close in the summer of 2021."),
                
                p("We wanted to understand male and female relationships in Olympic games, 
    since women have generally been underrepresented in the sports field. The 
    first interactive page allows to find difference between number of male and 
    female athletes in either in summer or winter Olympics throughout 120 years
    . Then, how number of medals changes in 120 years in each country? The 
    second page is designed to show this change in each country. The third page 
    shows the growth patterns of average heights of Olympic athletes in 
    different age group. We included this page to help know how well does the 
    global economic development over the last 120 years improve the athletes 
    physical conditions like height in both teenager and adult group, as well 
    as displaying the extent of physical difference between the two sexes."),
                
                img(src="https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fuploads.xuexila.com%2Fallimg%2F1611%2F744-161104091034.jpg&refer=http%3A%2F%2Fuploads.xuexila.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1641595521&t=0b789fe97096c82c9606bee017a8ad06"
                )
                ),
        tabItem(tabName = "tab1",
                titlePanel("This is the visualization"),
                visual_panel1),
        tabItem(tabName = "tab2",
                titlePanel("Showing the Age, Height, Weight of the selected player"),
                visual_panel2),
        tabItem(tabName = "tab3",
                visual_panel3),
        tabItem(tabName = "tab4")
      )
    )
  )
)

server <- function(input, output){
  #server1
  output$olympics <- renderPlotly({
    
    if (input$country == "World"){
      table1 <- data %>% 
        filter(Season == input$season) %>% 
        group_by(Year, Name) %>% 
        filter(row_number()==1) %>% 
        group_by(Year) %>% 
        summarize(Male = sum(Sex == "M"), Female = sum(Sex == "F")) %>% 
        gather(key = "Sex", value = "Count", -Year)
    } else {
      table1 <- data %>% 
        filter(Season == input$season) %>% 
        filter(region == input$country)
      
      if (nrow(table1) == 0){
        showModal(modalDialog(
          sprintf("%s did not participate in any %s Olympics.", input$country, input$season),
          easyClose = T
        ))
      } else {
        table1 <- table1 %>% 
          group_by(Year, Name) %>% 
          filter(row_number()==1) %>% 
          group_by(Year) %>% 
          summarize(Male = sum(Sex == "M"), Female = sum(Sex == "F")) %>% 
          gather(key = "Sex", value = "Count", -Year)
      } 
      
    }
    
    
    plot1 <- ggplot(table1, aes(Year, Count, color = Sex)) + geom_point(shape = 12, alpha = 0.9, show.legend = FALSE) +
      labs(title = sprintf("Number of Male and Female Athletes in %s Olympics Over Time", input$season)) +
      theme(legend.position = c(0.9, 0.2)) +
      scale_color_discrete(labels = c("Female", "Male")) +
      theme_bw()
    
    if (input$line) {
      plot1 <- plot1 + geom_point(alpha = .5) +
        geom_line()
    }
    
    # if (input$line) {
    #   the_plot <- the_plot + geom_point(alpha = .5) + geom_line()
    # }
    
    ggplotly(plot1)
    
  })
  #server2
  output$secondSelection <- renderUI({
    selectInput(
      inputId = "event",
      label = "Select an event",
      choices = unique(filter(df, Sex == input$sex)$Event)
    )
  })
  output$thirdSelection <- renderUI({
    selectInput(
      inputId = "player",
      label = "Select an athlete of interest",
      choices = filter(df, Sex == input$sex & Event == input$event)$Name
    )
  })
  
  radar_table <- function(name) {
    rd_df <- select(df, c(Age, Height, Weight))
    max_df <- summarise_all(rd_df, max)
    min_df <- summarise_all(rd_df, min)
    input_df <- df[df$Name == input$player, ]
    input_df <- input_df[input_df$Event == input$event, ]
    #input_df <- input_df[input_df$Age == max(input_df$Age)]
    #filter(df, Name == input$player & Event == input$Event)
    input_df <- select(input_df, c(Age, Height, Weight))
    
    final_df <- do.call("rbind", list(max_df, min_df, input_df) )
    return(final_df)
  }
  
  output$table <- renderTable({
    radar_table(
      input$player
    )
  })
  
  output$radar <- renderPlot({
    radarchart(
      radar_table(input$player),
      title = "(Age, Height, and Weight Radarchart)",
      vlcex=1,
      axistype = 2,
      pcol=rgb(0.2,0.5,0.5,0.9),
      plwd=2 
    )
  })
  #sever3
  output$plot3 <- renderPlotly({
    # Function of plotting.
    height_growth <- function(selected_age, selected_season){
      
      heights <- data3 %>%
        filter(Season == selected_season) %>%
        filter(Age == as.numeric(selected_age)) %>%
        # drop_na(Height) %>%
        group_by(Year, Name) %>%
        filter(row_number()==1) %>%
        group_by(Year, Sex) %>%
        summarize(mean_height = mean(Height, na.rm = TRUE))
      
      plot3 <- ggplot(data = heights, mapping = aes(x = Year))+
        geom_line(aes(y = mean_height, 
                      # group = Sex, 
                      colour = Sex), size = 1.7)+
        ggtitle("Average Heights of Adult Athletes")+
        xlab("Year")+
        ylab("Average Height (cm)")
      
      ggplotly(plot3)
    }
    
    # Run function.
    height_growth(input$ch3Age, input$ch3Season)
  })
}

shinyApp(ui = ui, server = server)