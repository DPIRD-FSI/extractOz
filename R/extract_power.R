
#' Extract Weather Data From the NASA POWER API Using Australian GPS Coordinates
#'
#' Extracts satellite and modelled weather data from the \acronym{NASA}
#'  \acronym{POWER} \acronym{API} at the GPS points provided.  This is a wrapper
#'  for [nasapower::get_power()] that will only work with Australian locations.
#'
#' @inheritParams extract_ae_zone
#' @param start_date `Integer`. A string representing the start date of the query in
#'  the format 'yyyymmdd' (ISO-8601).  Not used when `temporal_api` is set to
#'  \dQuote{climatology}. See argument details for more.
#' @param end_date `Integer`. A string representing the end date of the query in the
#' format 'yyyymmdd' (ISO-8601).  Not used when `temporal_api` is set to
#'  \dQuote{climatology}. See argument details for more.
#' @param community A character vector providing community name: \dQuote{ag},
#'   \dQuote{re} or \dQuote{sb}.  See argument details for more.
#' @param pars A character vector of solar, meteorological or climatology
#'   parameters to download.  When requesting a single point of x, y
#'   coordinates, a maximum of twenty (20) `pars` can be specified at one time,
#'   for \dQuote{daily}, \dQuote{monthly} and \dQuote{climatology}
#'   `temporal_api`s.  If the `temporal_api` is specified as \dQuote{hourly}
#'   only 15 `pars` can be specified in a single query.  See `temporal_api` for
#'   more.
#' @param temporal_api Temporal \acronym{API} end-point for data being queried,
#'   supported values are \dQuote{hourly}, \dQuote{daily}, \dQuote{monthly} or
#'   \dQuote{climatology}.  See argument details for more.
#' @param site_elevation A user-supplied value for elevation at a single point
#'   in metres.  If provided this will return a corrected atmospheric pressure
#'   value adjusted to the elevation provided.
#' @param wind_elevation A user-supplied value for elevation at a single point
#'   in metres.  Wind Elevation values in Meters are required to be between 10m
#'   and 300m.  If this parameter is provided, the `wind-surface` parameter is
#'   required with the request, see
#'    <https://power.larc.nasa.gov/docs/methodology/meteorology/wind/>.
#' @param wind_surface A user-supplied wind surface for which the corrected
#'   wind-speed is to be supplied.  See `wind-surface` section for more detail.
#' @param temporal_average Deprecated. This argument has been superseded by
#'   `temporal_api` to align with the new \acronym{POWER} \acronym{API}
#'   terminology.
#' @param time_standard POWER provides two different time standards:
#'    * Universal Time Coordinated (\acronym{UTC}): is the standard time measure
#'     that used by the world.
#'    * Local Solar Time (\acronym{LST}): a 15 Degrees swath that represents
#'     solar noon at the middle longitude of the swath.
#'    Defaults to `LST`.
#'
#' @section Argument details for \dQuote{community}: there are three valid
#'   values, one must be supplied. This  will affect the units of the parameter
#'   and the temporal display of time series data.
#'
#' \describe{
#'   \item{ag}{Provides access to the Agroclimatology Archive, which
#'  contains industry-friendly parameters formatted for input to crop models.}
#'
#'  \item{sb}{Provides access to the Sustainable Buildings Archive, which
#'  contains industry-friendly parameters for the buildings community to include
#'  parameters in multi-year monthly averages.}
#'
#'  \item{re}{Provides access to the Renewable Energy Archive, which contains
#'  parameters specifically tailored to assist in the design of solar and wind
#'  powered renewable energy systems.}
#'  }
#'
#' @section Argument details for `temporal_api`: There are four valid values.
#'  \describe{
#'   \item{hourly}{The hourly average of `pars` by hour, day, month and year,
#'   the time zone is LST by default.}
#'   \item{daily}{The daily average of `pars` by day, month and year.}
#'   \item{monthly}{The monthly average of `pars` by month and year.}
#'   \item{climatology}{Provide parameters as 22-year climatologies (solar)
#'    and 30-year climatologies (meteorology); the period climatology and
#'    monthly average, maximum, and/or minimum values.}
#'  }
#'
#' @section Argument details for `x`:
#' \describe{
#'  \item{For a single point}{To get a specific cell, 1/2 x 1/2 degree, supply a
#'  length-two numeric vector giving the decimal degree longitude and latitude
#'  in that order for data to download,\cr
#'  _e.g._, `lonlat = c(-179.5, -89.5)`.}
#'
#'  \item{For regional coverage}{To get a region, supply a length-four numeric
#'  vector as lower left (lon, lat) and upper right (lon, lat) coordinates,
#'  _e.g._, `lonlat = c(xmin, ymin, xmax, ymax)` in that order for a
#'  given region, _e.g._, a bounding box for the south western corner of
#'  Australia: `lonlat = c(112.5, -55.5, 115.5, -50.5)`.  *Maximum area
#'  processed is 4.5 x 4.5 degrees (100 points).}
#' }
#'
#' @section Argument details for `dates`: if one date only is provided, it
#'   will be treated as both the start date and the end date and only a single
#'   day's values will be returned, _e.g._, `dates = "1983-01-01"`.  When
#'   `temporal_api` is set to \dQuote{monthly}, use only two year values (YYYY),
#'   _e.g._ `dates = c(1983, 2010)`.  This argument should not be used when
#'   `temporal_api` is set to \dQuote{climatology} and will be ignored if set.
#'
#' @section Argument details for `wind_surface`: There are 17 surfaces that may
#'   be used for corrected wind-speed values using the following equation:
#'   \deqn{WSC_hgt = WS_10m\times(\frac{hgt}{WS_50m})^\alpha}{WSC_hgt = WS_10m*(hgt/WS_50m)^\alpha}
#'   Valid surface types are described here.
#'
#' \describe{
#'   \item{vegtype_1}{35-m broadleaf-evergreen trees (70% coverage)}
#'   \item{vegtype_2}{20-m broadleaf-deciduous trees (75% coverage)}
#'   \item{vegtype_3}{20-m broadleaf and needleleaf trees (75% coverage)}
#'   \item{vegtype_4}{17-m needleleaf-evergreen trees (75% coverage)}
#'   \item{vegtype_5}{14-m needleleaf-deciduous trees (50% coverage)}
#'   \item{vegtype_6}{Savanna:18-m broadleaf trees (30%) & groundcover}
#'   \item{vegtype_7}{0.6-m perennial groundcover (100%)}
#'   \item{vegtype_8}{0.5-m broadleaf shrubs (variable %) & groundcover}
#'   \item{vegtype_9}{0.5-m broadleaf shrubs (10%) with bare soil}
#'   \item{vegtype_10}{Tundra: 0.6-m trees/shrubs (variable %) & groundcover}
#'   \item{vegtype_11}{Rough bare soil}
#'   \item{vegtype_12}{Crop: 20-m broadleaf-deciduous trees (10%) & wheat}
#'   \item{vegtype_20}{Rough glacial snow/ice}
#'   \item{seaice}{Smooth sea ice}
#'   \item{openwater}{Open water}
#'   \item{airportice}{Airport: flat ice/snow}
#'   \item{airportgrass}{Airport: flat rough grass}
#' }
#'
#'
#' @return A `data.table` with data from the \acronym{POWER} \acronym{API}.
#'
#' @source <https://power.larc.nasa.gov/>
#'
#' @examplesIf interactive()
#' locs <- list(
#'   "Merredin" = c(x = 118.28, y = -31.48),
#'   "Corrigin" = c(x = 117.87, y = -32.33),
#'   "Tamworth" = c(x = 150.84, y = -31.07)
#'   )
#'
#' extract_power(
#'   x = locs,
#'   start_date = "19850101",
#'   end_date = "19850101",
#'   community = "ag",
#'   pars = c("RH2M", "T2M", "PRECTOTCORR"),
#'   temporal_api = "daily"
#' )
#'
#' @author Adam H. Sparks, \email{adam.sparks@@dpird.wa.gov.au}
#'
#' @family weather data
#'
#' @export
extract_power <- function(x,
                          start_date,
                          end_date,
                          pars,
                          community,
                          temporal_api = NULL,
                          site_elevation = NULL,
                          wind_elevation = NULL,
                          wind_surface = NULL,
                          temporal_average = NULL,
                          time_standard = "LST") {

  .check_lonlat(x)

  .dates <- c(start_date, end_date)

  out <- data.table::rbindlist(
    purrr::map(
      .x = x,
      .f = nasapower::get_power,
      temporal_api = "daily",
      pars = pars,
      community = community,
      dates = .dates
    ),
    idcol = "location"
  )

  data.table::setnames(out,
                       tolower(names(out)))

  data.table::setnames(out,
                       old = c("lon", "lat"),
                       new = c("longitude", "latitude"))
  return(out[])
}
