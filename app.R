library(ggiraph)
library(ggplot2)
library(shiny)
library(ragg)
library(htmltools)

# Register the font
if (!("Airnon" %in% systemfonts::system_fonts()$family)) {
  systemfonts::register_font(
    name = "Airnon",
    plain = "www/Airnon.ttf"
  )
}

# Create a font dependency
font_dependency <- htmlDependency(
  name = "airnon-font",
  version = "1.0.0",
  src = "www",
  stylesheet = "airnon-font.css"
)

# Make sure to create a CSS file (airnon-font.css) in the www folder with:
# @font-face {
#   font-family: 'Airnon';
#   src: url('Airnon.ttf') format('truetype');
# }

options(shiny.useragg = TRUE)

ui <- fluidPage(
  tags$head(
    font_dependency
  ),
  sidebarLayout(
    sidebarPanel(
      sliderInput("num_rows", "Number of rows:",
                  min = 15, max = 32, value = 20)
    ),
    mainPanel(girafeOutput("custofontplot", height = "600px"))
  )
)

server <- function(input, output) {
  output$custofontplot <- renderGirafe({
    dat <- mtcars[seq_len(input$num_rows), ]
    dat$carname <- row.names(dat)
    gg <- ggplot(dat, aes(drat, carname)) +
      geom_point() +
      theme_minimal(base_family = "Airnon") +
      theme(text = element_text(family = "Airnon"))

    girafe(ggobj = gg)
  })
}

# Run the application
shinyApp(ui = ui, server = server)
