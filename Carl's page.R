# Dataset
data <- read.csv("athlete_events.csv")
data3 <- data[order(data$Year),]

visual_panel3 <- tabItem("Chart 3",
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







