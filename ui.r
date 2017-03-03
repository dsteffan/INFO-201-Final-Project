library("shiny")
library("dplyr")
library("ggplot2")


ui <- fluidPage(
  
  titlePanel("Title"),
  
  sidebarLayout(
    
    sidebarPanel(
      h1("Sidebar Panel"),
      
      p("Majors"),
      
      radioButtons('major.select', label = "Select a Major:", choices = unique(data$Major_category))
      
    ),
    
    mainPanel(
      
      h3("Select a tab"),
      
      tabsetPanel(
        
        tabPanel("Plot", p("Plot of the majors by employment rate")),
        
        tabPanel("Histogram", p("Histogram of majors by salary"))
      )
    )
  )
)

shinyUI(ui)