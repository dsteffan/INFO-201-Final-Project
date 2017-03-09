library("shiny")
library("dplyr")
library("ggplot2")

median.range <- range(data$Median)


ui <- fluidPage(
  
  titlePanel("College Majors"),
  
  sidebarLayout(
    
    sidebarPanel(
      h3("Narrow your search"),
      
      selectInput('major.choice', label = "Select Major Category:", choices = data$Major_category, selected = 'All'),
      sliderInput('median.range', label = "Median Pay", min = median.range[1], max = median.range[2], value = median.range)
      
      
    ),
    
    mainPanel(
      
      h3("Select a tab"),
      
      tabsetPanel(
        
        tabPanel("Introduction", p("This app looks at the college majors of recent graduate students data set from FiveThirtyEight who organized and
                                   filtered the data from the American Community Survey 2010-2012 Public Use Microdata Series. With this
                                   data, we created separate tabs for each set of information including table of information about each major,
                                    the employment rate, salary, and how useful a college degree is for that major allowing students and parents to learn
                                   more information about certain majors. They can also refine their search by focusing on a specific major category 
                                   and median salary of those majors."), a("Click here to view the original data", href = "http://www.census.gov/acs/www/data_documentation/pums_data/"),
                                   p(), a("Click here to view the data organized by FiveThirtyEight", href = "https://github.com/fivethirtyeight/data/tree/master/college-majors")),
        
        tabPanel("Major Information", p("Table of Majors"), tableOutput('table')),
        tabPanel("Employment", p("Plot of the majors by employment rate"), plotlyOutput('graph')),
        tabPanel("Salary", p("Bar chart of majors by salary"), 
                 plotOutput('histogram', click = 'hist.click'), 
                 textOutput("x_value")),
        
        tabPanel("College Degree", p("Percentage of jobs requiring college degrees given a major
                                            category."), 
                 plotOutput('college.jobs', click = 'percent.click'),
                 textOutput("info"))
      )
    )
  )
)

shinyUI(ui)
?a()
