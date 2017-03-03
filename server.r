library("shiny")
library("dplyr")
library("ggplot2")


server <- function(input, output) {
  
  filtered.pay <- reactive({
    pay <- data %>%
      filter(Median >= input$median.range[1] & Median <= input$median.range[2]) 
    return(pay)
  })
  
  
output$graph <-  renderPlot({
  ggplot(data = data, mapping = aes(x = Total, y = Unemployment_rate)) +
    geom_point() +
    labs(title = ("Total in Major vs Unemployment Rate"), 
         x = "Total",
         y = "Unemployment Rate")
})

filteredMajor <- reactive({
  return(input$major.select)
})

output$histogram <- renderPlot({
  ggplot(data = filter(filtered.pay(), Major_category == filteredMajor())) + 
    geom_bar(mapping = aes(x = Major, y = Median), stat = "identity") +
    labs(title = ("Median Pay"))
})  

output$table <- renderTable({
  filtered.table <- filtered.pay() %>%
    filter(Major_category == filteredMajor()) %>%
    select(Rank, Major, Total, Median, P25th, P75th, College_jobs, Non_college_jobs)
  return(filtered.table)
})
  
}

shinyServer(server)