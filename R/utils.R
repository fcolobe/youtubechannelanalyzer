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
