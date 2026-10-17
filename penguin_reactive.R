library(shiny)
library(bslib)
library(palmerpenguins)
library(dplyr)
library(ggplot2)


ui <- page_sidebar(

  title = "Penguin Explorer",

  sidebar = sidebar(
    selectInput(
      inputId = "species",
      label = "Select species:",
      choices = unique(penguins$species),
      selected = "Adelie"
    )

  ),

  card(
    height = "200px",
    card_header("Number of penguins"),

    textOutput("n_penguins")
  ),

  card(
    card_header("Body mass vs flipper length"),

    plotOutput(
      outputId = "penguin_plot",
      height = "400px",
      fill = FALSE
    )
  ),

  card(
    height = "400px",
    card_header("Filtered data"),
    tableOutput("penguin_table")
  )
)


server <- function(input, output, session) {

  filtered_penguins <- reactive({

    penguins |>
      filter(species == input$species)

  })


  output$n_penguins <- renderText({

    paste(
      "Number of penguins:",
      nrow(filtered_penguins())
    )

  })


  output$penguin_plot <- renderPlot({

    filtered_penguins() |>
      filter(
        !is.na(flipper_length_mm),
        !is.na(body_mass_g)
      ) |>
      ggplot(
        aes(
          x = flipper_length_mm,
          y = body_mass_g
        )
      ) +
      geom_point() +
      labs(
        x = "Flipper length (mm)",
        y = "Body mass (g)"
      ) +
      theme_minimal()

  })


  output$penguin_table <- renderTable({

    filtered_penguins()

  })

}


shinyApp(
  ui = ui,
  server = server
)