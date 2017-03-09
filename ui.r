library("shiny")
library("dplyr")
library("ggplot2")

median.range <- range(data$Median)


ui <- fluidPage(
  
  titlePanel("Title"),
  
  sidebarLayout(
    
    sidebarPanel(
      h1("Sidebar Panel"),
      
      p("Majors"),
      selectInput('major.choice', label = "Select Major Category:", choices = majors, selected = 'All'),
      sliderInput('median.range', label = "Median Pay", min = median.range[1], max = median.range[2], value = median.range)
      
      
    ),
    
    mainPanel(
      
      h3("Select a tab"),
      
      tabsetPanel(
        
        tabPanel("Table", p("Table of Majors"), tableOutput('table')),
        
        tabPanel("Plot", p("Plot of the majors by employment rate"), plotlyOutput('graph')),
        
        tabPanel("Histogram", p("Histogram of majors by salary"), plotOutput('histogram'))
      )
    )
  )
)

shinyUI(ui)

