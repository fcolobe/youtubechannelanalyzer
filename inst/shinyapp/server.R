shiny::shinyServer(function(input, output, session) {
  shiny::observeEvent(input[["dark_mode"]], {
    if (input[["dark_mode"]] == "dark") {
      shiny::showNotification("Welcome to the dark side!")
    }
  })

  filtered_categories <- shiny::reactive({
    shiny::req(input[["nb_subscribers"]])

    regex <- "\\d+(\\.\\d+)?"

    min_subs_str <- stringr::str_extract(
      string = input$nb_subscribers[1],
      pattern = regex
    )
    max_subs_str <- stringr::str_extract(
      string = input$nb_subscribers[2],
      pattern = regex
    )

    min_subs <- as.numeric(min_subs_str)
    max_subs <- as.numeric(max_subs_str)

    youtube_channel_stats |>
      dplyr::filter(
        as.numeric(stringr::str_extract(
          string = formatted_subscribers,
          pattern = regex
        )) >= min_subs &
          as.numeric(stringr::str_extract(
            string = formatted_subscribers,
            pattern = regex
          )) <= max_subs &
          category != "nan"
      ) |>
      dplyr::distinct(category)
  })

  shiny::observe({
    categories <- filtered_categories() |>
      dplyr::pull(category)

    shinyWidgets::updatePickerInput(
      inputId = "categories",
      choices = categories,
      selected = categories[1]
    )
  })

  filtered_countries <- shiny::reactive({
    shiny::req(input[["categories"]])
    youtube_channel_stats |>
      dplyr::filter(
        category %in% input[["categories"]] &
          country != "nan"
      ) |>
      dplyr::distinct(country, flag_path) |>
      dplyr::arrange(country)
  })

  shiny::observe({
    country_flag <- filtered_countries()

    countries <- country_flag |>
      dplyr::pull(country)

    flags <- country_flag |>
      dplyr::pull(flag_path)

    choices <- stats::setNames(
      countries,
      lapply(seq_along(countries), function(i) {
        shiny::HTML(paste(
          shiny::tags$img(
            src = flags[i],
            width = 20,
            height = 15
          ),
          countries[i]
        ))
      })
    )

    shinyWidgets::updateMultiInput(
      session = session,
      inputId = "countries",
      choices = choices,
      selected = choices
    )
  })

  output[["total_channels"]] <- shiny::renderUI({
    bslib::value_box(
      title = "Total Channels",
      value = "12",
      showcase = shiny::icon("display")
    )
  })

  output[["avg_subs"]] <- shiny::renderUI({
    bslib::value_box(
      title = "Average Subscribers",
      value = "12",
      showcase = shiny::icon("users")
    )
  })

  output[["avg_views"]] <- shiny::renderUI({
    bslib::value_box(
      title = "Average Views",
      value = "12",
      showcase = shiny::icon("eye")
    )
  })
})
