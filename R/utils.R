#' Format Number with Suffixes
#'
#' This function formats a numeric value by adding appropriate suffixes such as "K" for thousands,
#' "M" for millions, and "B" for billions.
#'
#' @param x A numeric value to be formatted.
#' @return A character string representing the formatted number with the appropriate suffix.
#' @examples
#' format_number(1500)
#' format_number(2500000)
#' format_number(3500000000)
#' @export
format_number <- function(x) {
  if (x >= 1e9) {
    return(paste0(round(x / 1e9, 1), "B"))
  } else if (x >= 1e6) {
    return(paste0(round(x / 1e6, 1), "M"))
  } else if (x >= 1e3) {
    return(paste0(round(x / 1e3, 1), "K"))
  } else {
    return(as.character(x))
  }
}

#' Automatic Unit Format
#'
#' This function automatically determines the appropriate unit format for a numeric vector
#' and returns a function that formats numbers with the correct unit (e.g., "K" for thousands,
#' "M" for millions, "B" for billions).
#'
#' @param x A numeric vector to be formatted.
#' @return A function that formats numbers with the appropriate unit.
#' @examples
#' y_labels <- auto_unit_format(c(1500, 2500000, 3500000000))
#' y_labels(c(1500, 2500000, 3500000000))
#' @export
auto_unit_format <- function(x) {
  max_val <- max(x, na.rm = TRUE)
  sep = ""
  if (max_val >= 1e9) {
    scales::unit_format(unit = "B", scale = 1e-9, sep = sep)
  } else if (max_val >= 1e6) {
    scales::unit_format(unit = "M", scale = 1e-6, sep = sep)
  } else if (max_val >= 1e3) {
    scales::unit_format(unit = "K", scale = 1e-3, sep = sep)
  } else {
    scales::unit_format(unit = "", scale = 1, sep = sep)
  }
}

#' Calculate Q1 and Mean Indices
#'
#' This function calculates the indices of the first quartile (Q1) and the mean of a numeric vector.
#'
#' @param x A numeric vector.
#' @return A named list containing the indices of the first quartile (Q1) and the mean.
#' @examples
#' calculate_q1_mean_indices(c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10))
#' @export
calculate_q1_mean_indices <- function(x) {
    ordered_x <- sort(x)
    q1_val <- stats::quantile(ordered_x, 0.25)
    mean_val <- mean(ordered_x)

    q1_index <- which.min(abs(ordered_x - q1_val))
    mean_index <- which.min(abs(ordered_x - mean_val))
    return(list(q1_index = q1_index, mean_index = mean_index))
}

# Example usage of the function
# indices <- calculate_q1_mean_indices(youtube_channel_stats[["subscribers"]])
# print(indices$q1_index)
# print(indices$mean_index)
