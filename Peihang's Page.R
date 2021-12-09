library(shiny)
library("dplyr")
library(fmsb)

raw_df <- read.csv("athlete_events.csv")
df <- filter(raw_df, !is.na(Age) & !is.na(Height) & !is.na(Weight)) %>%
  filter(Season == "Summer") %>%
  filter(Medal == "Gold" | Medal == "Silver" | Medal == "Bronze") %>%
  filter(Name == Name)


visual_panel2 <- tabItem(
  titlePanel("Showing the Age, Height, Weight of the selected player"),
  
  sidebarLayout(
    sidebarPanel(
      p("The data only contains althletes who won medals"),
      selectInput(
        inputId = "sex",
        label = "Select a gender",
        choices = unique(df$Sex)
      ),
      uiOutput("secondSelection"),
      uiOutput("thirdSelection"),
    ),
    mainPanel(
      plotOutput("radar")
    )
  ),
  helpText("Note: The first and the second rows of the table below",
           br(),
           "shows the maximum minimum stat of the players.",
           br(),
           "The remmaining row/rows represents the stat of the player,",
           br(),
           "but the age could differ"),
  tableOutput("table")
)

ui <- navbarPage(
  "testing",
  visual_panel2
)

server <- function(input, output) {
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
}

shinyApp(ui = ui, server = server)