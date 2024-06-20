shiny::shinyServer(function(input, output, session) {
  shiny::observeEvent(input[["dark_mode"]], {
    if (input[["dark_mode"]] == "dark") {
      shiny::showNotification("Welcome to the dark side!")
    }
  })

  shiny::observe({
    shiny::req(
      input[["nb_subscribers"]],
      youtube_channel_stats
    )

    categories <- youtube_channel_stats |>
      dplyr::filter(
        sorted_formatted_subscribers %in% input[["nb_subscribers"]] &
          category != "nan"
      ) |>
      dplyr::select(dplyr::all_of("category")) |>
      dplyr::distinct() |>
      dplyr::pull()

    shinyWidgets::updatePickerInput(
      inputId = "categories",
      choices = categories,
      selected = categories[1]
    )
  })

  shiny::observe({
    shiny::req(
      input[["categories"]],
      youtube_channel_stats
    )

    country_flag <- youtube_channel_stats |>
      dplyr::filter(
        category %in% input[["categories"]] &
          country != "nan"
      ) |>
      dplyr::select(dplyr::all_of(c("country", "flag_path"))) |>
      dplyr::distinct() |>
      dplyr::arrange(country)

    countries <- country_flag |>
      dplyr::select(dplyr::all_of("country")) |>
      dplyr::pull()

    flags <- country_flag |>
      dplyr::select(dplyr::all_of("flag_path")) |>
      dplyr::pull()

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
})
