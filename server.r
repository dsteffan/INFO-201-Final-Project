library("shiny")
library("dplyr")
library("ggplot2")
library("plotly")



server <- function(input, output) {
  filtered.pay <- reactive({
    pay <- data %>%
      filter(Median >= input$median.range[1] & Median <= input$median.range[2]) 
    pay$percent_college_jobs <- round(100 * pay$College_jobs / (pay$College_jobs + pay$Non_college_jobs), digits = 2)
    return(pay)
  })
  
  major <- reactive({
    if(input$major.choice == 'All') {
      return(filtered.pay())
    } 
    return(filtered.pay() %>% filter(Major_category == input$major.choice))
  })
  
  output$histogram <- renderPlot({
    ggplot(data = filter(filtered.pay(), Major_category == input$major.choice)) + 
      geom_bar(mapping = aes(x = reorder(Major, Rank), y = Median), stat = "identity") +
      coord_flip() +
      geom_errorbar(aes(x = Major, ymin = P25th, ymax = P75th), width = 0.5) +
      labs(title = ("Median Pay"), x = "Majors")
  })  

  output$table <- renderTable({
    filtered.table <- filtered.pay() %>%
      filter(Major_category == input$major.choice) %>%
      select(Rank, Major, Total, Median, P25th, P75th, College_jobs, Non_college_jobs)
    return(filtered.table)
  })
  
  output$x_value <- renderText({
    if (is.null(input$hist.click$y)) {
      text <- "Click on the bars for more information"
      return(text)
    } else {
      lvls <- filter(filtered.pay(), Major_category == input$major.choice)$Major
      name <- lvls[round(input$hist.click$y)]
      paste0("You've selected ", tolower(name), "! The median pay is $",
             data[data$Major == name, 'Median'], ", rank ",  data[data$Major == name, "Rank"], " overall.\n(25th percentile = $",
             data[data$Major == name, 'P25th'], ", 75th percentile = $",
             data[data$Major == name, 'P75th'], ")")
    }
  })
  
  
   output$college.jobs <- renderPlot({
    ggplot(data = filter(filtered.pay(), Major_category == input$major.choice)) + 
      geom_bar(mapping = aes(x = reorder(Major, Rank), y = percent_college_jobs), stat = "identity") +
       coord_flip() +
      labs(title = ("Majors vs Percent of Jobs Requring College Degree"), y = "Percent of Jobs Requiring College Degree (%)", x = "Majors")
  })  

   percent.info <- reactive({
     if (is.null(input$percent.click$y)) {
       text <- "Click on the bars for more information"
       return(text)
     } else {
       lvls <- filter(filtered.pay(), Major_category == input$major.choice)$Major
       name <- lvls[round(input$percent.click$y)]
       paste0("You've selected ", tolower(name), "! In this major, ",
              filtered.pay()[filtered.pay()$Major == name, "percent_college_jobs"], "% have jobs requiring a college degree.",
              data[data$Major == name, 'College_jobs'], " have jobs requiring a college degree while ",
              data[data$Major == name, 'Non_college_jobs'], " do not have jobs requiring their college degree.")
     }
   })   

   
   output$info <- renderText({
     return(percent.info())
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

  
}

shinyServer(server)

