
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
        # nothing in the side bar for now
    ),

    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("plot1"),
      plotOutput("plot2")
    )
  )
))
