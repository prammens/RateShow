
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ggvis)


shinyUI(fluidPage(

  # Application title
  titlePanel("Watch money grow"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      numericInput("stam",
                   "Amount at begin",
                   min=0,
                   max=100000,
                   value=0,
                   step=1000),
      numericInput("moin",
                  "Amount to be invested monthly:",
                  min = 0,
                  max = 10000,
                  value = 800,
                  step = 100),
      numericInput("intrate",
                   "Fixed interest rate (%, p.a.):",
                   min = -5,
                   max = 100,
                   value = 1,
                   step = 0.1)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
#      plotOutput("invest")
      ggvisOutput("invest"),
      ggvisOutput("invdif")
    )
  )
))
