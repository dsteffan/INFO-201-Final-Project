library("shiny")
library("dplyr")
library("ggplot2")
library("plotly")



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
  
  output$graph <-  renderPlotly({
    f <- list(
      family = "Courier New, monospace",
      size = 16,
      color = "#7f7f7f"
    )
    x <- list(
      title = "Total",
      titlefont = f
    )
    y <- list(
      title = "Unemployment Rate",
      titlefont = f
    )
    plot_ly(major(), x = major()$Total, y = major()$Unemployment_rate, type = 'scatter', 
            color = major()$Major, hoverinfo = 'text', text = major()$Major) %>% 
      layout(showlegend = FALSE) %>% 
      layout(xaxis = x, yaxis = y) %>% 
      layout(title= 'Total in Major vs Unemployment Rate')
    
  })
  
  output$histogram <- renderPlot({
    ggplot(data = major()) + 
      geom_bar(mapping = aes(x = Major, y = Median), stat = "identity") +
      labs(title = ("Median Pay"))
  })  
}

shinyServer(server)

