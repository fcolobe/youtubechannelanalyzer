% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{extract_numeric_subs}
\alias{extract_numeric_subs}
\title{Extract Numeric Subscriber Count}
\usage{
extract_numeric_subs(subscriber_str)
}
\arguments{
\item{subscriber_str}{A string representing the formatted subscriber count.}
}
\value{
A numeric value representing the subscriber count.
}
\description{
Extracts the numeric subscriber count from a formatted subscriber string.
}
\details{
This function takes a formatted subscriber string (e.g., "1K", "1.5M") and extracts the numeric part as a numeric value.
}
\examples{
extract_numeric_subs("1K") # returns 1
extract_numeric_subs("1.5M") # returns 1.5
}
