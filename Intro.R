library(shiny)



# Introduction Part
ui <- fluidPage(
  navbarPage("Olympics"),
    tabPanel("Home"),
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
  
)

server <- function(input, output){
  
}
  
# Run the App
shinyApp(ui = ui, server = server)
