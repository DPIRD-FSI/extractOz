% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/extract_daas_soil_order.R
\name{extract_daas_soil_order}
\alias{extract_daas_soil_order}
\title{Extract Soil Order From DAAS Using Australian GPS Coordinates}
\source{
\url{https://data.gov.au/dataset/ds-dga-5ccb44bf-93f2-4f94-8ae2-4c3f699ea4e7/distribution/dist-dga-56ba5f25-2324-43b5-8df8-b9c69ae2ea0b/details?q=}
}
\usage{
extract_daas_soil_order(x, cache = FALSE, aez_only = TRUE)
}
\arguments{
\item{x}{\code{List}. An object with names containing \code{vector} pairings of
longitude and latitude values expressed as decimal degree values in that
order, each individual \code{vectors}' items should be named "x" (longitude) and
"y" (latitude), respectively.  The \code{list} item names should be descriptive
of the individual \code{vectors} and will be included in a "location" column of
the output.}

\item{cache}{\code{Boolean}.  Store soil data locally for later use?  If \code{FALSE},
the downloaded files are removed when \R session is closed. To take advantage
of cached files in future sessions, use \code{cache = TRUE}.  Defaults to \code{FALSE}.
Value is optional.  All future requests will use the cached data unless
\code{\link[=remove_cache]{remove_cache()}} is used to remove the cached file.}

\item{aez_only}{\code{Boolean}.  Only use soils in the GRDC agroecozones?  Use
\code{aez = FALSE} to extract soil data from anywhere in Australia. Use
\code{aez = TRUE} to only work with soils in the GRDC agroecozones. Defaults to
\code{TRUE}.}
}
\value{
A \link[data.table:data.table]{data.table::data.table} with the provided \acronym{GPS}
coordinates and the respective Digital Atlas of Australian Soils
(\acronym{DAAS} soil order), "Spatial Data Conversion of the Atlas of
Australian Soils to the Australian Soil Classification v01".
}
\description{
Extracts the major soil order at the GPS points provided assuming that they
are land-based coordinates.
}
\note{
The first run will take additional time to download and extract the
soils data.  If \code{cache = TRUE}, any use after this will be much faster due to
the locally cached geospatial soils data.
}
\examples{
\dontshow{if (interactive()) (if (getRversion() >= "3.4") withAutoprint else force)(\{ # examplesIf}
locs <- list(
  "Merredin" = c(x = 118.28, y = -31.48),
  "Corrigin" = c(x = 117.87, y = -32.33),
  "Tamworth" = c(x = 150.84, y = -31.07)
)

extract_daas_soil_order(x = locs, cache = FALSE)

# extract soils data for Mt. Isa, Qld (not in the GRDC AEZ)
locs <- list("Mt_Isa" = c(x = 139.4930, y = -20.7264))
extract_daas_soil_order(x = locs, aez = FALSE)
\dontshow{\}) # examplesIf}
}
