library(plotly)
library(tidyverse)

data <- read.csv("athlete_events.csv")

noc <- read.csv("noc_regions.csv")

data <- merge(data, noc, by = "NOC", all.x = T)
  
ui <- navbarPage("",
                 tabPanel("Introduction"
                 ),
                 tabPanel("Visualization",
                          titlePanel("This is the visualization"),
                          sidebarLayout(
                            
                            sidebarPanel(
                              
                              selectInput("season", label = h3("Olympics"), 
                                                 choices = list("Summer" = "Summer", "Winter" = "Winter"),
                                                 selected = "Summer"),
                              # select one for summer or winter, both for data combined
                              
                              hr(),
                              
                              selectInput("country", label = h3("By Country"), 
                                          choices = c("World" = "World", unique(data$region)),
                                          selected = "World"
                                          ),
                              
                              hr(),
                              
                              fluidRow(
                                column(8, align="center", offset = 2,
                                       checkboxInput("line", label = "Include Trend Lines", value = T)
                                ))
                              
                            ),
                            
                            mainPanel(
                              tags$style(type="text/css",
                                         ".shiny-output-error { visibility: hidden; }",
                                         ".shiny-output-error:before { visibility: hidden; }"),
                                         
                              plotlyOutput("olympics")
                              
                            )
                          )
                 )
)


server <- function(input, output){
  
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
}

shinyApp(ui = ui, server = server)