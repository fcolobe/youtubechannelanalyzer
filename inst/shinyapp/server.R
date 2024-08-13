shiny::shinyServer(function(input, output, session) {
  shiny::observeEvent(input[["dark_mode"]], {
    if (input[["dark_mode"]] == "dark") {
      shiny::showNotification("Welcome to the dark side!")
    }
  })

  filtered_channel_type <- shiny::reactive({
    shiny::req(input[["nb_subscribers"]])

    min_subs <- extract_numeric_subs(input[["nb_subscribers"]][1])
    max_subs <- extract_numeric_subs(input[["nb_subscribers"]][2])

    youtube_channel_stats |>
      dplyr::filter(
        extract_numeric_subs(formatted_subscribers) >= min_subs &
          extract_numeric_subs(formatted_subscribers) <= max_subs
      ) |>
      dplyr::distinct(channel_type) |>
      dplyr::arrange(channel_type)
  })

  shiny::observe({
    channel_type <- filtered_channel_type() |>
      dplyr::pull(channel_type)

    shinyWidgets::updatePickerInput(
      inputId = "channel_types",
      choices = channel_type,
      selected = channel_type
    )
  })

  filtered_countries <- shiny::reactive({
    shiny::req(input[["channel_types"]])
    youtube_channel_stats |>
      dplyr::filter(
        channel_type %in% input[["channel_types"]]
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

  rv_display <- shiny::reactiveValues(display = TRUE)
  shiny::observeEvent(input[["calculate_button"]], {
    rv_display[["display"]] <- FALSE
  })

  init_filtered_youtube_data <- filter_youtube_data(
    youtube_data = youtube_channel_stats,
    nb_subscribers = init_nb_subscribers,
    channel_types = init_channel_types,
    countries = init_countries
  )

  filtered_youtube_data <- shiny::eventReactive(input[["calculate_button"]], {
    shiny::req(
      input[["nb_subscribers"]],
      input[["channel_types"]],
      input[["countries"]]
    )
    filter_youtube_data(
      youtube_data = youtube_channel_stats,
      nb_subscribers = input[["nb_subscribers"]],
      channel_types = input[["channel_types"]],
      countries = input[["countries"]]
    )
  })

  output[["total_channels"]] <- shiny::renderUI({
    if (shiny::isTruthy(rv_display[["display"]])) {
      total_channels <- init_filtered_youtube_data |> nrow()
    } else {
      total_channels <- filtered_youtube_data() |> nrow()
    }
    bslib::value_box(
      title = "Total Channels",
      value = format_number(total_channels),
      showcase = shiny::icon("display")
    )
  })

  output[["avg_subs"]] <- shiny::renderUI({
    if (shiny::isTruthy(rv_display[["display"]])) {
      avg_subs <- mean(init_filtered_youtube_data[["subscribers"]], na.rm = TRUE)
    } else {
      avg_subs <- mean(filtered_youtube_data()[["subscribers"]], na.rm = TRUE)
    }
    bslib::value_box(
      title = "Average Subscribers",
      value = format_number(avg_subs),
      showcase = shiny::icon("users")
    )
  })

  output[["avg_views"]] <- shiny::renderUI({
    if (shiny::isTruthy(rv_display[["display"]])) {
      avg_views <- mean(init_filtered_youtube_data[["video_views"]], na.rm = TRUE)
    } else {
      avg_views <- mean(filtered_youtube_data()[["video_views"]], na.rm = TRUE)
    }
    bslib::value_box(
      title = "Average Views",
      value = format_number(avg_views),
      showcase = shiny::icon("eye")
    )
  })

  output[["plot_avg_subs"]] <- plotly::renderPlotly({
    if (shiny::isTruthy(rv_display[["display"]])) {
      youtube_data <- init_filtered_youtube_data
    } else {
      youtube_data <- filtered_youtube_data()
    }
    avg_subs_by_year <- youtube_data |>
      dplyr::filter(!is.nan(created_year)) |>
      dplyr::mutate(
        created_year = as.Date(paste0(created_year, "-01-01"), format = "%Y-%m-%d")
      ) |>
      dplyr::group_by(created_year) |>
      dplyr::summarise(avg_subscribers = mean(subscribers))

    y_labels <- auto_unit_format(avg_subs_by_year[["avg_subscribers"]])

    gg <- ggplot2::ggplot(avg_subs_by_year, ggplot2::aes(x = created_year, y = avg_subscribers)) +
      ggplot2::geom_line(color = "steelblue", linewidth = 1.2) +
      ggplot2::geom_point(color = "darkred", size = 3) +
      ggplot2::scale_x_date(date_labels = "%Y") +
      ggplot2::scale_y_continuous(labels = y_labels) +
      ggplot2::labs(
        x = "Year",
        y = "Average Number of Subscribers"
      ) +
      ggplot2::theme_minimal()
    plotly::ggplotly(gg)
  })

  output[["plot_avg_views"]] <- plotly::renderPlotly({
    if (shiny::isTruthy(rv_display[["display"]])) {
      youtube_data <- init_filtered_youtube_data
    } else {
      youtube_data <- filtered_youtube_data()
    }
    avg_views_by_year <- youtube_data |>
      dplyr::filter(!is.nan(created_year)) |>
      dplyr::mutate(
        created_year = as.Date(paste0(created_year, "-01-01"), format = "%Y-%m-%d")
      ) |>
      dplyr::group_by(created_year) |>
      dplyr::summarise(avg_video_views = mean(video_views, na.rm = TRUE))

    y_labels <- auto_unit_format(avg_views_by_year[["avg_video_views"]])

    gg <- ggplot2::ggplot(avg_views_by_year, ggplot2::aes(x = created_year, y = avg_video_views)) +
      ggplot2::geom_line(color = "steelblue", linewidth = 1.2) +
      ggplot2::geom_point(color = "darkred", size = 3) +
      ggplot2::scale_x_date(date_labels = "%Y") +
      ggplot2::scale_y_continuous(labels = y_labels) +
      ggplot2::labs(
        x = "Year",
        y = "Average Number of Video Views"
      ) +
      ggplot2::theme_minimal()
    plotly::ggplotly(gg)
  })

  output[["plot_avg_subs2"]] <- plotly::renderPlotly({
    if (shiny::isTruthy(rv_display[["display"]])) {
      youtube_data <- init_filtered_youtube_data
    } else {
      youtube_data <- filtered_youtube_data()
    }
    category_subscribers <- youtube_data |>
      dplyr::group_by(category) |>
      dplyr::summarise(total_subscribers = sum(subscribers, na.rm = TRUE))

    gg <- ggplot2::ggplot(category_subscribers, ggplot2::aes(x = reorder(category, -total_subscribers), y = total_subscribers)) +
      ggplot2::geom_bar(stat = "identity", fill = "steelblue") +
      ggplot2::coord_flip() +
      ggplot2::labs(title = "Distribution des abonnés par catégorie de chaîne",
           x = "Catégorie",
           y = "Total des abonnés") +
      ggplot2::theme_minimal()
    plotly::ggplotly(gg)
  })

  output[["export"]] <- DT::renderDT({
    if (shiny::isTruthy(rv_display[["display"]])) {
      youtube_data <- init_filtered_youtube_data
    } else {
      youtube_data <- filtered_youtube_data()
    }
    youtube_data <- youtube_data |>
      dplyr::select(-tail(names(youtube_data), 4))
  })
})
