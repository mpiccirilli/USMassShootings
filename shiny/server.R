
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
load('../data.RData')
print(p1)
print(p2)

shinyServer(function(input, output) {

  output$plot1 <- renderPlot({p1})

  output$plot2 <- renderPlot({p2})
})
