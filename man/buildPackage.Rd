% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/buildPackage.R
\name{buildPackage}
\alias{buildPackage}
\title{Build package utility}
\usage{
buildPackage(lib = ".", quiet = FALSE, ignore_lintr = FALSE)
}
\arguments{
\item{lib}{Path to library}

\item{quiet}{If CMD check output is sent to terminal. Set to TRUE if
additional info is not needed}

\item{ignore_lintr}{If lintr should be ignored for readability}
}
\description{
Build package utility
}
\examples{
\dontrun{
buildPackage()
}
}
\author{
Abhijeet Mishra
}
