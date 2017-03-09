library("shiny")
library("dplyr")
library("ggplot2")


server <- function(input, output) {
  filtered.pay <- reactive({
    pay <- data %>%
      filter(Median > input$median.range[1] & Median < input$median.range[2]) 
    return(pay)
  })
  
  major <- reactive({
    if(input$major.choice == 'All') {
      return(filtered.pay())
    } 
    return(filtered.pay() %>% filter(Major_category == input$major.choice))
  })
  
  output$table <- renderTable({
    filtered.table <- major() %>% 
      select(Rank, Major, Total, Median, P25th, P75th, College_jobs, Non_college_jobs)
    return(filtered.table)
  })
  
  output$graph <-  renderPlot({
    ggplot(data = major(), mapping = aes(x = Total, y = Unemployment_rate, color = Major, size = 7)) +
      scale_color_brewer(palette = "Set1") +
      theme(legend.position="none") +
      geom_point() +
      labs(title = ("Total in Major vs Unemployment Rate"), 
           x = "Total",
           y = "Unemployment Rate")
    
    
  })
  
  output$histogram <- renderPlot({
    ggplot(data = major()) + 
      geom_bar(mapping = aes(x = Major, y = Median), stat = "identity") +
      labs(title = ("Median Pay"))
  })  
}

shinyServer(server)

