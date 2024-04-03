
if (!require("shiny")) install.packages("shiny")
if (!require("ggplot2")) install.packages("ggplot2")
if (!require("DT")) install.packages("DT")
library(shiny)
library(ggplot2)
library(DT)


victim_data <- data.frame(
  Nationality = c("Jewish", "Polish", "Soviet POWs", "Roma", "Other groups"),
  Number = c(1000000, 70000, 14000, 21000, 12000)
)

ui <- fluidPage(
  titlePanel("Auschwitz Holocaust Victims by Nationality/Category"),
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput("nationalities", "Select Nationalities/Categories:",
                         choices = victim_data$Nationality, selected = victim_data$Nationality)
    ),
    mainPanel(
      plotOutput("barPlot"),
      DTOutput("dataTable")
    )
  )
)


server <- function(input, output) {
  filteredData <- reactive({
    victim_data[victim_data$Nationality %in% input$nationalities, ]
  })
  
  output$barPlot <- renderPlot({
    ggplot(filteredData(), aes(x = Nationality, y = Number, fill = Nationality)) +
      geom_bar(stat = "identity") +
      theme_minimal() +
      labs(title = "Number of Holocaust Victims by Nationality/Category",
           y = "Number of Victims",
           x = NULL)
  })
  
  output$dataTable <- renderDT({
    datatable(filteredData(), options = list(pageLength = 5))
  })
}


shinyApp(ui = ui, server = server)
