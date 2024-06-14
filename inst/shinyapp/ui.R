shiny::shinyUI(
  bslib::page_sidebar(
    theme = bslib::bs_theme(
      bootswatch = "darkly",
      base_font = bslib::font_google("Open Sans"),
      navbar_bg = "#303030"
    )
  )
)
