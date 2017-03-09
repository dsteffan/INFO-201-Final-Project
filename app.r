library("shiny")
library("dplyr")
library("ggplot2")


data <- read.csv('./data/recent-grads.csv', stringsAsFactors = FALSE)



median.range <- range(data$Median)
majors <- unique(data$Major_category)

shinyApp(ui = ui, server = server)

