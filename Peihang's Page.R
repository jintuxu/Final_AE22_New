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
