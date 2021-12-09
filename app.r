library(plotly)
library(tidyverse)
library(shiny)
library(data.table)
library(leaflet)
library(magrittr)
library(R.utils)
library(rsconnect)
library(shinydashboard)
library(collapsibleTree)
library(shinycssloaders)
library(DT)
library(tigris)
library(fmsb)
source("Alex's Page.R")
source("Carl's page.R")
source("Peihang's Page.R")

data <- read.csv("athlete_events.csv")
noc <- read.csv("noc_regions.csv")
data <- merge(data, noc, by = "NOC", all.x = T)

ui <- fluidPage(
  dashboardPage(
    skin = "red",
    dashboardHeader(title = 'Olympics in 120Yrs', titleWidth = 200),
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
                p("This project explores data on the modern Olympic Games, including all the 
  Games from Athens 1896 to Rio 2016. The dataset we've used is", 
                a(href = "https://www.kaggle.com/heesoo37/120-years-of-olympic-history-athletes-and-results", "120 years of Olympic history: athletes and results."), ),
                h4("What Can Be Answered in This Project?"),
                p("1. We wanted to understand male and female physical differences in Olympic 
  games, since women have generally been underrepresented in the sports field. 
  The first page allows us to find physical differences between male 
  and female athletes in either summer or winter Olympics throughout the last 120 
  years." ),
                
                p("2. The second page demonstrates data of athletes' physical characteristics grouped by sport events and sex."),
                
                p("3. The third page shows the growth patterns of average heights of Olympic 
  athletes in different age group. We included this page to help know how well 
    does the global economic development over the last 120 years improve the 
    athletes physical characteristics like height in all age groups, as well as 
    displaying the extent of physical difference between the two genders."),
                
                img(src="https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fuploads.xuexila.com%2Fallimg%2F1611%2F744-161104091034.jpg&refer=http%3A%2F%2Fuploads.xuexila.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1641595521&t=0b789fe97096c82c9606bee017a8ad06"
                )
                ),
        tabItem(tabName = "tab1",
                titlePanel("Number of Male and Female Athletes Over Time"),
                p("The following chart shows the number of male and female athletes that have participated in the Olympics over time. The data can be broken down by country and season using the widgets on the left panel."),
                visual_panel1,
                strong("If we only look at Summer Olympics, as a matter of fact, the number of male athletes in the 1952 Olympics",
                  br(), "
                  is more than 8 times the number of female athletes! However, around 1980, the number of female athlete started to increase rapidly",
                  br(),
                  "and approached the number of male athletes in the 2010s.  Up until the 2016 Olympics, male athletes became only around 1.2 times as many. ")
                ),
        tabItem(tabName = "tab2",
                titlePanel("Showing the Age, Height, Weight of the selected player"),
                visual_panel2),
        tabItem(tabName = "tab3",
                visual_panel3),
        tabItem(tabName = "tab4",
                titlePanel("Conclusions"),
                sidebarLayout(
                  sidebarPanel(
                    
                    h2("Takeaway 1"),
                    p("The number of female athletes have lagged behind male athletes in the Olympics in the past, though the gap is now closing in recent years."),
                    p("Some countries have never participated in the Winter Olympics! (Mauritius, Angola, etc)"),
                    h2("Takeaway 2"),
                    p("We found that in some specific events, the medal owners share similar physical statistics. For example, they may have similar weight which means that this
physical attribute positively contribute to wining.
We also found that radar charts are really good at showing the statistics of a person. People could easily identify which aspect is the strength of the person. It will be even more powerful if we have more data."),
                    h2("Takeaway 3"),
                    p("We had an assumption, during our exploratory stage, that there is an essential physical difference between male and female athletes, and thus we grouped the trends by sex. As we expected, the “Height Growth Trend” graph we displayed in our analysis does show a conspicuous height gap between the two trends. Moreover, contradicting our initial hypothesis that the average height of athletes ought to display a natural linear growth, the graphs instead show us some “wavy” irregular growth patterns.")
                    
                  ),
                  
                  mainPanel(
                    
                    fluidRow(
                      column(8, align="center", offset = 2,
                             img(src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTqPbpGTpH0_N0gh6P4J8SCFgM8uxnywDb2wySDz6pWaC5Bp0o1"
                             )
                      ))
                    ,
                    p("Throughout the project, we've explored the Olympics Athlete data through various lenses such as gender, age, and physical characteristics. The dataset gave us a lot more insight into what the Olympics had been like in the past and the trends that it takes toward the present and future. While we do see things such as females being underrepresented in the Olympics or that some physical characteristics yield better performance in games, it, undoubtfully, may be the case given the nature of sports. However, there are still trends that are promising to see. For instance, the fact that in some areas, the gap between females and males is closing, or the fact that some of our findings managed to defy our initial hypothesis."),
                    
                    
                  )
                  
                  
                )
                )
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