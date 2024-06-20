load("../../data/youtube_channel_stats.rda")

subscribers <- youtube_channel_stats[["subscribers"]]
subs_indices <- calculate_q1_mean_indices(subscribers)
subs_q1_index <- subs_indices$q1_index
subs_mean_index <- subs_indices$mean_index

formatted_subscribers <- sapply(
  X = subscribers,
  FUN = format_number
)

youtube_channel_stats <- youtube_channel_stats |>
  dplyr::mutate("formatted_subscribers" = formatted_subscribers)

sorted_formatted_subscribers <- formatted_subscribers[order(as.numeric(subscribers))]

countries <- unique(youtube_channel_stats[["country"]])
countries <- countries[countries != "nan"]

flags <- c(
  "img/flags/in.svg",
  "img/flags/us.svg",
  "img/flags/jp.svg",
  "img/flags/ru.svg",
  "img/flags/kr.svg",
  "img/flags/gb.svg",
  "img/flags/ca.svg",
  "img/flags/br.svg",
  "img/flags/ar.svg",
  "img/flags/cl.svg",
  "img/flags/cu.svg",
  "img/flags/sv.svg",
  "img/flags/pk.svg",
  "img/flags/ph.svg",
  "img/flags/th.svg",
  "img/flags/co.svg",
  "img/flags/bb.svg",
  "img/flags/mx.svg",
  "img/flags/ae.svg",
  "img/flags/es.svg",
  "img/flags/sa.svg",
  "img/flags/id.svg",
  "img/flags/tr.svg",
  "img/flags/ve.svg",
  "img/flags/kw.svg",
  "img/flags/jo.svg",
  "img/flags/nl.svg",
  "img/flags/sg.svg",
  "img/flags/au.svg",
  "img/flags/it.svg",
  "img/flags/de.svg",
  "img/flags/fr.svg",
  "img/flags/se.svg",
  "img/flags/af.svg",
  "img/flags/ua.svg",
  "img/flags/lv.svg",
  "img/flags/ch.svg",
  "img/flags/vn.svg",
  "img/flags/my.svg",
  "img/flags/cn.svg",
  "img/flags/iq.svg",
  "img/flags/eg.svg",
  "img/flags/ad.svg",
  "img/flags/ec.svg",
  "img/flags/ma.svg",
  "img/flags/pe.svg",
  "img/flags/bd.svg",
  "img/flags/fi.svg",
  "img/flags/ws.svg"
)

country_flag_map <- stats::setNames(flags, countries)

youtube_channel_stats <- youtube_channel_stats |>
  dplyr::mutate(
    flag_path = dplyr::case_when(
      country == "India" ~ country_flag_map["India"],
      country == "United States" ~ country_flag_map["United States"],
      country == "Japan" ~ country_flag_map["Japan"],
      country == "Russia" ~ country_flag_map["Russia"],
      country == "South Korea" ~ country_flag_map["South Korea"],
      country == "United Kingdom" ~ country_flag_map["United Kingdom"],
      country == "Canada" ~ country_flag_map["Canada"],
      country == "Brazil" ~ country_flag_map["Brazil"],
      country == "Argentina" ~ country_flag_map["Argentina"],
      country == "Chile" ~ country_flag_map["Chile"],
      country == "Cuba" ~ country_flag_map["Cuba"],
      country == "El Salvador" ~ country_flag_map["El Salvador"],
      country == "Pakistan" ~ country_flag_map["Pakistan"],
      country == "Philippines" ~ country_flag_map["Philippines"],
      country == "Thailand" ~ country_flag_map["Thailand"],
      country == "Colombia" ~ country_flag_map["Colombia"],
      country == "Barbados" ~ country_flag_map["Barbados"],
      country == "Mexico" ~ country_flag_map["Mexico"],
      country == "United Arab Emirates" ~ country_flag_map["United Arab Emirates"],
      country == "Spain" ~ country_flag_map["Spain"],
      country == "Saudi Arabia" ~ country_flag_map["Saudi Arabia"],
      country == "Indonesia" ~ country_flag_map["Indonesia"],
      country == "Turkey" ~ country_flag_map["Turkey"],
      country == "Venezuela" ~ country_flag_map["Venezuela"],
      country == "Kuwait" ~ country_flag_map["Kuwait"],
      country == "Jordan" ~ country_flag_map["Jordan"],
      country == "Netherlands" ~ country_flag_map["Netherlands"],
      country == "Singapore" ~ country_flag_map["Singapore"],
      country == "Australia" ~ country_flag_map["Australia"],
      country == "Italy" ~ country_flag_map["Italy"],
      country == "Germany" ~ country_flag_map["Germany"],
      country == "France" ~ country_flag_map["France"],
      country == "Sweden" ~ country_flag_map["Sweden"],
      country == "Afghanistan" ~ country_flag_map["Afghanistan"],
      country == "Ukraine" ~ country_flag_map["Ukraine"],
      country == "Latvia" ~ country_flag_map["Latvia"],
      country == "Switzerland" ~ country_flag_map["Switzerland"],
      country == "Vietnam" ~ country_flag_map["Vietnam"],
      country == "Malaysia" ~ country_flag_map["Malaysia"],
      country == "China" ~ country_flag_map["China"],
      country == "Iraq" ~ country_flag_map["Iraq"],
      country == "Egypt" ~ country_flag_map["Egypt"],
      country == "Andorra" ~ country_flag_map["Andorra"],
      country == "Ecuador" ~ country_flag_map["Ecuador"],
      country == "Morocco" ~ country_flag_map["Morocco"],
      country == "Peru" ~ country_flag_map["Peru"],
      country == "Bangladesh" ~ country_flag_map["Bangladesh"],
      country == "Finland" ~ country_flag_map["Finland"],
      country == "Samoa" ~ country_flag_map["Samoa"],
      TRUE ~ NA_character_
    )
  )

month_map <- c(
  "Jan" = "01", "Feb" = "02", "Mar" = "03", "Apr" = "04",
  "May" = "05", "Jun" = "06", "Jul" = "07", "Aug" = "08",
  "Sep" = "09", "Oct" = "10", "Nov" = "11", "Dec" = "12"
)

youtube_channel_stats <- youtube_channel_stats |>
  dplyr::mutate(created_month_num = month_map[created_month])

youtube_channel_stats <- youtube_channel_stats |>
  dplyr::mutate(created_date_combined = paste(
    created_year,
    created_month_num,
    created_date,
    sep = "-"
  ))

youtube_channel_stats <- youtube_channel_stats |>
  dplyr::mutate(
    created_date_combined = as.Date(
      created_date_combined,
      format = "%Y-%m-%d"
    )
  )

youtube_channel_stats[["created_date_combined"]] <- as.Date(
  youtube_channel_stats[["created_date_combined"]],
  format = "%Y-%m-%d"
)
