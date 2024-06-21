shiny::shinyUI(
  bslib::page_navbar(
    title = shiny::tags$span(
      shiny::tags$img(
        src = "img/logo.svg",
        width = "46px",
        height = "auto",
        alt = "YouTube logo"
      ),
      "Analytics"
    ),
    footer = p("Developed by Fonty Colo Be"),
    bg = "#303030",
    sidebar = bslib::sidebar(
      bslib::accordion(
        open = c("# Subscribers", "Categories"),
        bslib::accordion_panel(
          title = "# Subscribers",
          shinyWidgets::sliderTextInput(
            inputId = "nb_subscribers",
            label = "Number of subscribers:",
            choices = sorted_formatted_subscribers,
            selected = c(
              sorted_formatted_subscribers[subs_q1_index],
              sorted_formatted_subscribers[subs_mean_index]
            )
          ),
          icon = shiny::icon("users")
        ),
        bslib::accordion_panel(
          title = "Categories",
          shinyWidgets::pickerInput(
            inputId = "categories",
            label = "Channel categories:",
            choices = NULL,
            options = list(
              `actions-box` = TRUE
            ),
            multiple = TRUE
          ),
          icon = icon("icons")
        ),
        bslib::accordion_panel(
          title = "Countries",
          shinyWidgets::multiInput(
            inputId = "countries",
            label = "Countries:",
            choices = character(0)
          ),
          icon = shiny::icon("globe")
        )
      )
    ),
    theme = bslib::bs_theme(
      bootswatch = "darkly",
      base_font = bslib::font_google("Open Sans")
    ),
    lang = "en",
    bslib::nav_panel(
      title = "Overview",
      icon = shiny::icon("magnifying-glass-chart"),
      bslib::layout_columns(
        col_widths = 4,
        fill = FALSE,
        shiny::uiOutput("total_channels"),
        shiny::uiOutput("avg_subs"),
        shiny::uiOutput("avg_views")
      ),
      bslib::layout_columns(
        col_widths = 6,
        bslib::card(
          full_screen = TRUE,
          bslib::card_header(
            "Flight paths",
            bslib::tooltip(
              shiny::icon("info-circle", title = "About marker areas"),
              "Marker areas are proportional to mean arrival delay"
            ),
            class = "d-flex justify-content-between align-items-center"
          ),
          shiny::plotOutput("plot1")
        ),
        bslib::card(
          full_screen = TRUE,
          bslib::card_header(
            "Flight paths",
            bslib::tooltip(
              shiny::icon("info-circle", title = "About marker areas"),
              "Marker areas are proportional to mean arrival delay"
            ),
            class = "d-flex justify-content-between align-items-center"
          ),
          shiny::plotOutput("plot2")
        )
      )
    ),
    bslib::nav_panel(
      title = "Channel Analysis",
      icon = shiny::icon("chart-pie")
    ),
    bslib::nav_panel(
      title = "Earnings Analysis",
      icon = shiny::icon("dollar-sign")
    ),
    bslib::nav_panel(
      title = "Geospatial Visualization",
      icon = shiny::icon("earth-europe")
    ),
    bslib::nav_panel(
      title = "Data Table",
      icon = shiny::icon("database"),
      bslib::card(
        bslib::card_header("Flight data"),
        DT::dataTableOutput("export")
      )
    ),
    bslib::nav_panel(
      title = "About",
      icon = shiny::icon("circle-info")
    ),
    bslib::nav_spacer(),
    bslib::nav_item(
      shiny::tags$a(
        shiny::tags$span(
          shiny::icon("code"),
          "Source code"
        ),
        href = "https://github.com/fcolobe/youtubechannelanalyzer",
        target = "_blank"
      )
    ),
    bslib::nav_item(
      bslib::input_dark_mode(
        id = "dark_mode",
        mode = "dark"
      )
    )
  )
)
