library("shiny")
library("dplyr")
library("ggplot2")


server <- function(input, output) {
  
  filtered.pay <- reactive({
    pay <- data %>%
      filter(Median >= input$median.range[1] & Median <= input$median.range[2]) 
    pay$percent_college_jobs <- round(100 * pay$College_jobs / (pay$College_jobs + pay$Non_college_jobs), digits = 2)
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
      geom_bar(mapping = aes(x = reorder(Major, Rank), y = Median), stat = "identity") +
      geom_errorbar(aes(x = Major, ymin = P25th, ymax = P75th), width = 0.5) +
      labs(title = ("Median Pay"))
  })  

  output$table <- renderTable({
    filtered.table <- filtered.pay() %>%
      filter(Major_category == filteredMajor()) %>%
      select(Rank, Major, Total, Median, P25th, P75th, College_jobs, Non_college_jobs)
    return(filtered.table)
  })
  
  output$hist.desc <- reactive({
    input$hist.click$y
  })

  output$x_value <- renderText({
    if (is.null(input$hist.click$x)) {
      text <- "Click on the bars for more information"
      return(text)
    } else {
      lvls <- filter(filtered.pay(), Major_category == filteredMajor())$Major
      name <- lvls[round(input$hist.click$x)]
      paste0("You've selected ", tolower(name), "! The median pay is $",
             data[data$Major == name, 'Median'], ", rank ",  data[data$Major == name, "Rank"], " overall.\n(25th percentile = $",
             data[data$Major == name, 'P25th'], ",75th percentile = $",
             data[data$Major == name, 'P75th'], ")")
    }
  })
  
  
   output$college.jobs <- renderPlot({
    ggplot(data = filter(filtered.pay(), Major_category == filteredMajor())) + 
      geom_bar(mapping = aes(x = reorder(Major, Rank), y = percent_college_jobs), stat = "identity") +
      labs(title = ("Majors vs Percent of Jobs Requring College Degree"), y = "Percent of Jobs Requiring College Degree (%)")
  })  

   percent.info <- reactive({
     if (is.null(input$percent.click$x)) {
       text <- "Click on the bars for more information"
       return(text)
     } else {
       lvls <- filter(filtered.pay(), Major_category == filteredMajor())$Major
       name <- lvls[round(input$percent.click$x)]
       paste0("You've selected ", tolower(name), "! In this major, ",
              filtered.pay()[filtered.pay()$Major == name, "percent_college_jobs"], "% have jobs requiring a college degree.",
              data[data$Major == name, 'College_jobs'], " have jobs requiring a college degree while ",
              data[data$Major == name, 'Non_college_jobs'], " do not have jobs requiring their college degree.")
     }
   })   

   
   output$info <- renderText({
     return(percent.info())
   })
}

shinyServer(server)