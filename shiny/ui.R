
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("US Shootings"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      
        helpText("Create map of victims for each state or for the entire US."),
      
      selectInput("var", 
                  label = "Choose a variable to display",
                  choices = unique(DT$State),
                  selected = "Percent White"),
      
      sliderInput("years", 
                  label = "Range of Years:",
                  min = min(DT$year), max = max(DT$year),
                  value = c(2013,2015), step =1 )
    ),

    # Show a plot of the generated distribution
    mainPanel(
      #plotOutput("plot1"),
      #plotOutput("plot2")
    )
  )
))
