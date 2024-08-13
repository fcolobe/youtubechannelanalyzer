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
    footer = shiny::tags$div(
      style = "display: flex; flex-direction: column; align-items: center; width: 100%;",
      shiny::tags$hr(style = "border-color: white; width: 100%;"),
      shiny::tags$div(
        style = "display: flex; justify-content: space-between; align-items: center; width: 100%;",
        shiny::tags$div(
          style = "margin-left: 10px;",
          shiny::HTML(
            'Made with <a href="https://rstudio.github.io/bslib/" target="_blank">{bslib}</a> and <a href="https://shiny.posit.co/" target="_blank">Shiny</a>'
          )
        ),
        shiny::tags$div(
          style = "text-align: right; margin-right: 10px;",
          shiny::HTML(
            'Developed by <a href="https://fcolobe.github.io/portfolio/" target="_blank">Fonty Colo Be</a>'
          )
        )
      )
    ),
    bg = "#303030",
    sidebar = bslib::sidebar(
      bslib::accordion(
        open = c("# Subscribers", "Channel Types", "Actions"),
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
          title = "Channel Types",
          shinyWidgets::pickerInput(
            inputId = "channel_types",
            label = "Channel Types:",
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
        ),
        bslib::accordion_panel(
          title = "Actions",
          shiny::actionButton(
            inputId = "calculate_button",
            label = "Calculate",
            icon = shiny::icon("flask-vial"),
            class = "btn btn-primary btn-block"
          ),
          icon = shiny::icon("play-circle")
        )
      )
    ),
    theme = bslib::bs_theme(
      version = 5,
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
            "Average Subscribers Over Time",
            bslib::tooltip(
              shiny::icon("info-circle", title = "About subscriber trends"),
              "This chart shows the average number of subscribers over time."
            ),
            class = "d-flex justify-content-between align-items-center"
          ),
          plotly::plotlyOutput("plot_avg_subs")
        ),
        bslib::card(
          full_screen = TRUE,
          bslib::card_header(
            "Average Video Views Over Time",
            bslib::tooltip(
              shiny::icon("info-circle", title = "About video views trends"),
              "This chart shows the average number of video views over time."
            ),
            class = "d-flex justify-content-between align-items-center"
          ),
          plotly::plotlyOutput("plot_avg_views")
        )
      )
    ),
    bslib::nav_panel(
      title = "Channel Analysis",
      icon = shiny::icon("chart-pie"),
      bslib::layout_columns(
        col_widths = 6,
        bslib::card(
          full_screen = TRUE,
          bslib::card_header(
            "Average Subscribers Over Time",
            bslib::tooltip(
              shiny::icon("info-circle", title = "About subscriber trends"),
              "This chart shows the average number of subscribers over time.",
              placement = "right"
            ),
            bslib::popover(
              shiny::icon("gear", class = "ms-auto"),
              shinyWidgets::pickerInput("yvar", "Split by", c("sex", "species", "island")),
              shinyWidgets::pickerInput("color", "Color by", c("species", "island", "sex"), "island"),
              title = "Plot settings"
            ),
            class = "d-flex align-items-center gap-1"
          ),
          plotly::plotlyOutput("plot_avg_subs2")
        ),
        bslib::card(
          full_screen = TRUE,
          bslib::card_header(
            "Average Video Views Over Time",
            bslib::tooltip(
              shiny::icon("info-circle", title = "About video views trends"),
              "This chart shows the average number of video views over time.",
              placement = "right"
            ),
            bslib::popover(
              shiny::icon("gear", class = "ms-auto"),
              shinyWidgets::pickerInput("yvar", "Split by", c("sex", "species", "island")),
              shinyWidgets::pickerInput("color", "Color by", c("species", "island", "sex"), "island"),
              title = "Plot settings"
            ),
            class = "d-flex align-items-center gap-1"
          ),
          plotly::plotlyOutput("plot_avg_views2")
        )
      )
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
        bslib::card_header("YouTube Channel Statistics"),
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
