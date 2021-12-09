data <- read.csv("athlete_events.csv")

noc <- read.csv("noc_regions.csv")

data <- merge(data, noc, by = "NOC", all.x = T)

visual_panel1 <- tabItem(
         titlePanel("This is the visualization"),
         sidebarLayout(
           
           sidebarPanel(
             
             selectInput("season", label = h3("Olympics"), 
                         choices = list("Summer" = "Summer", "Winter" = "Winter"),
                         selected = "Summer"),
             
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
