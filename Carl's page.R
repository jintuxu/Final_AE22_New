library(shiny)
library(data.table)
library(leaflet)
library(dplyr)
library(magrittr)
library(ggplot2)
library(R.utils)
library(rsconnect)
library(tidyverse)
library(plotly)

# Dataset
data <- read.csv("athlete_events.csv")
data3 <- data[order(data$Year),]

ui <- fluidPage(
  navbarPage(
    tabPanel("Chart 3",
     # Title of the page.
     
     withTags({
       body(
         class = "header",
         titlePanel("Height Growth at Different Ages"),
         # description.
         p("
        The following graph shows the average height growth trends through the last 120 years' 
        summer olympics according to different ages. The growth trends are divided into males 
        and females due to the essential physical nuances which may affect the mean significantly. 
        The slopes or general tendencies of the graphs display the extents in which the 
        historical and economic development has contributed to the athletes physical condition 
        by different age groups, and see whether there's a significant difference in 
        change in heights in respect to sexes.
        "),
         
         sidebarLayout(
           sidebarPanel(
             sliderInput(
               inputId = "ch3Age",
               label = "Please select an age:",
               min = min(data3$Age, na.rm = TRUE),
               max = max(data3$Age, na.rm = TRUE),
               value = 18
               # step = 1,
               # animate = TRUE
             ),
             selectInput(
               inputId = "ch3Season",
               label = "Please select a season:",
               choices = unique(data3$Season),
               selected = ""
             )
           ),
           
           
           
           mainPanel(
             plotlyOutput("plot3")
           )
         
       )
       )
     })
    )
  )
)

server <- function(input, output){
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









