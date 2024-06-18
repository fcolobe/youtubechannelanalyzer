shiny::shinyUI(
  bslib::page_navbar(
    title = "YouTube Analytics",
    bg = "#303030",
    sidebar = bslib::sidebar(
      title = "Filters",
      shinyWidgets::pickerInput(
        inputId = "youtuber",
        label = "Youtuber Search:",
        choices = LETTERS,
        options = list(
          `actions-box` = TRUE
        ),
        multiple = TRUE
      ),
      shinyWidgets::sliderTextInput(
        inputId = "subscribers",
        label = "Subscribers:",
        choices = c(1, 10, 100, 500, 1000),
        grid = TRUE
      ),
      shinyWidgets::pickerInput(
        inputId = "country",
        label = "Country:",
        choices = c("a", "b", "c", "d"),
        options = list(
          style = "btn-primary"
        )
      ),
      shiny::dateRangeInput(
        inputId = "dates",
        label = "Dates:",
        start = "2001-01-01",
        end = "2010-12-31"
      ),
      shinyWidgets::sliderTextInput(
        inputId = "uploads",
        label = "Uploads:",
        choices = c(1, 10, 100, 500, 1000),
        grid = TRUE
      )
    ),
    theme = bslib::bs_theme(
      bootswatch = "darkly",
      base_font = bslib::font_google("Open Sans")
    ),
    lang = "en",
    bslib::nav_panel(
      title = "Overview",
      icon = icon("magnifying-glass-chart")
    ),
    bslib::nav_panel(
      title = "Channel Analysis",
      icon = icon("chart-pie")
    ),
    bslib::nav_panel(
      title = "Earnings Analysis",
      icon = icon("dollar-sign")
    ),
    bslib::nav_panel(
      title = "Geospatial Visualization",
      icon = icon("earth-europe")
    ),
    bslib::nav_panel(
      title = "Data Table",
      icon = icon("database")
    ),
    bslib::nav_panel(
      title = "About",
      icon = icon("circle-info")
    ),
    bslib::nav_spacer(),
    bslib::nav_menu(
      title = "Links",
      align = "right",
      icon = icon("link"),
      bslib::nav_item("link_shiny"),
      bslib::nav_item("link_posit")
    )
  )
)
