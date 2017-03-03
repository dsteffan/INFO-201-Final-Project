library("shiny")
library("dplyr")
library("ggplot2")


data <- read.csv('./data/recent-grads.csv', stringsAsFactors = FALSE)



colnames(data) <- new.names

shinyApp(ui = ui, server = server)