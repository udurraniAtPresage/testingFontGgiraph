library(ggiraph)
library(ggplot2)
library(shiny)
library(gdtools)
library(ragg)

options(shiny.useragg = TRUE)

# Font downloaded from: https://www.dafont.com/airnon.font

registered_fonts <- systemfonts::registry_fonts() |> dplyr::select(family)
this_system_fonts <- systemfonts::system_fonts() |> dplyr::pull(family) |> unique()


if (!("Airnon" %in% registered_fonts$family) | !("Airnon" %in% this_system_fonts)) {
  systemfonts::register_font(
    name = "Airnon",
    plain = "Airnon.ttf"
  )
}

registered_fonts <- systemfonts::registry_fonts() |> dplyr::select(family)
this_system_fonts <- systemfonts::system_fonts() |> dplyr::pull(family) |> unique()

print("Airnon" %in% registered_fonts$family)
print("Airnon" %in% this_system_fonts)

print(font_family_exists("Airnon"))


ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      sliderInput("num_rows", "Number of rows:",
                  min = 15, max = 32, value = 20)
    ),
    mainPanel(girafeOutput("custofontplot"))
  )
)

server <- function(input, output) {
  output$custofontplot <- renderGirafe({
    dat <- mtcars[seq_len(input$num_rows), ]
    dat$carname <- row.names(dat)
    gg <- ggplot(dat, aes(drat, carname)) +
      geom_point() +
      theme_minimal(
        # base_family = "Airnon"
        base_family = "sans"
        )

    girafe(ggobj = gg, fonts = list(sans = "Airnon"))
  })
}

# Run the application
shinyApp(ui = ui, server = server)
