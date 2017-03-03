library("shiny")
library("dplyr")
library("ggplot2")


data <- read.csv('./data/recent-grads.csv', stringsAsFactors = FALSE)

shinyApp(ui = ui, server = server)