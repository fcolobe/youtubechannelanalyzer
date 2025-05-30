% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{auto_unit_format}
\alias{auto_unit_format}
\title{Automatic Unit Format}
\usage{
auto_unit_format(x)
}
\arguments{
\item{x}{A numeric vector to be formatted.}
}
\value{
A function that formats numbers with the appropriate unit.
}
\description{
This function automatically determines the appropriate unit format for a numeric vector
and returns a function that formats numbers with the correct unit (e.g., "K" for thousands,
"M" for millions, "B" for billions).
}
\examples{
y_labels <- auto_unit_format(c(1500, 2500000, 3500000000))
y_labels(c(1500, 2500000, 3500000000))
}
