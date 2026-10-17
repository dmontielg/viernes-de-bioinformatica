library(shiny)
library(bslib)
library(palmerpenguins)
library(dplyr)
library(ggplot2)


# -------------------------
# User interface
# -------------------------

ui <- page_sidebar(

  title = "Penguin Explorer",

  sidebar = sidebar(

    selectInput(
      inputId = "species",
      label = "Select species:",
      choices = unique(penguins$species),
      selected = "Adelie"
    ),

    actionButton(
      inputId = "update",
      label = "Update"
    )

  ),

  # Number of penguins
  card(
    card_header("Number of penguins"),

    textOutput("n_penguins")
  ),

  # Plot
  card(
    height = "400px",

    card_header("Body mass vs flipper length"),

    plotOutput(
      "penguin_plot",
      fill = FALSE
    )
  ),

  # Table
  card(
    height = "400px",

    card_header("Filtered data"),

    tableOutput("penguin_table")
  )

)


# -------------------------
# Server logic
# -------------------------

server <- function(input, output, session) {

  # Create reactive value
  filtered_penguins <- reactiveVal(
    penguins |>
      filter(species == "Adelie")
  )


  # Update reactive value when button is clicked
  observeEvent(input$update, {

    data <- penguins |>
      filter(species == input$species)

    filtered_penguins(data)

  })


  # Number of penguins
  output$n_penguins <- renderText({

    paste(
      "Number of penguins:",
      nrow(filtered_penguins())
    )

  })


  # Scatter plot
  output$penguin_plot <- renderPlot({

    filtered_penguins() |>
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


  # Table
  output$penguin_table <- renderTable({

    filtered_penguins()

  })

}


# -------------------------
# Run application
# -------------------------

shinyApp(
  ui = ui,
  server = server
)