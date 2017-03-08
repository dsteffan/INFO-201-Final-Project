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
                 textOutput("x_value")),
        
        tabPanel("Jobs Requiring Degree", p("This bar chart takes the data from American Community Survey 2010-2012 Public Use Microdata Series,
                                            organized by FiveThirtyEight and displays the percentage of jobs requiring college degrees given a major
                                            category."), 
                 plotOutput('college.jobs', click = 'percent.click'),
                 textOutput("info"))
      )
    )
  )
)

shinyUI(ui)