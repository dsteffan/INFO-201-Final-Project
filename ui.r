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
      
      radioButtons('major.select', label = "Select a Major:", choices = unique(data$Major_category)),
      
      sliderInput('median.range', label = "Median Pay", min = median.range[1], max = median.range[2], value = median.range)
      
      
    ),
    
    mainPanel(
      
      h3("Select a tab"),
      
      tabsetPanel(
        
        tabPanel("Table", p("Table of Majors"), tableOutput('table')),
        
        tabPanel("Plot", p("Plot of the majors by employment rate"), plotOutput('graph')),
        
        tabPanel("Bar Chart", p("Bar chart of majors by salary"), 
                 plotOutput('histogram', click = 'hist.click'), 
                 verbatimTextOutput("x_value")),
        
        tabPanel("Jobs Requiring Degree", p("Bar chart of percentage of jobs requiring college degree based on major."), 
                 plotOutput('college.jobs', click = 'percent.click'),
                 verbatimTextOutput("info"))
      )
    )
  )
)

shinyUI(ui)