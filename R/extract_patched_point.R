
#' Extract Weather From the Nearest Patched Point Weather Station in the SILO Network Using Australian GPS Coordinates
#'
#' Extracts station-based weather data for the provided dates from the nearest
#'   weather station to the provided longitude and latitude values in `x`.
#'   Weather data for the single closest station(s) to the provided longitude
#'   and latitude will always be returned.
#'
#' # Column Name Details
#'
#' Column names are converted from the default returns of the API to be
#'    snake_case formatted and where appropriate, the names of the values that
#'    are analogous between \acronym{SILO} and \acronym{DPIRD} data are named
#'    using the same name for ease of interoperability, _e.g._, using
#'    [rbind()] to create a `data.table` that contains data from both APIs.
#'
#' @details The \acronym{SILO} documentation provides the following information
#'   for the PatchedPoint data.
#'
#'   *These data are a continuous daily time series of data at either recording
#'   stations or grid points across Australia:*
#'
#'   * *Data at station locations consists of observational records which have
#'   been supplemented by interpolated estimates when observed data are missing.
#'   Datasets are available at approximately 8,000 Bureau of Meteorology
#'   recording stations around Australia.*
#'
#'   * *Data at grid points consists entirely of interpolated estimates. The
#'   data are taken from the SILO gridded datasets and are available at any
#'   pixel on a 0.05° × 0.05° grid over the land area of Australia (including
#'   some islands).*
#'
#' @inheritParams extract_ae_zone
#' @param start_date A `character` string or `Date` object representing the
#'   beginning of the range to query in the format \dQuote{yyyy-mm-dd}
#'   (ISO8601).  Data returned is inclusive of this date.
#' @param end_date A `character` string or `Date` object representing the end of
#'   the range query in the format  \dQuote{yyyy-mm-dd} (ISO8601).  Data
#'   returned is inclusive of this date.  Defaults to the current system date.
#' @param n_stations An `integer` value that indicates how many stations per
#'   location should be returned.  Defaults to one (1) station with only the
#'   nearest station being returned.  Values greater than 1 will result in the
#'   next nearest stations being returned from 1 to n.
#' @param values A `character` string with the type of weather data to
#'   return.  See **Available Values** for a full list of valid values.
#'   Defaults to `all` with all available values being returned.
#' @param api_key A `character` string specifying a valid email address to use
#'   for the request.  The query will return an error if a valid email address
#'   is not provided.
#'
#' @section Available Values:
#'
#' \describe{
#'  \item{all}{Which will return all of the following values}
#'  \item{rain (mm)}{Rainfall}
#'  \item{max_temp (degrees C)}{Maximum temperature}
#'  \item{min_temp (degrees C)}{Minimum temperature}
#'  \item{vp (hPa)}{Vapour pressure}
#'  \item{vp_deficit (hPa)}{Vapour pressure deficit}
#'  \item{evap_pan (mm)}{Class A pan evaporation}
#'  \item{evap_syn (mm)}{Synthetic
#'    \ifelse{html}{\out{estimate<sup>1</sup>}}{estimate\eqn{^1}}}
#'  \item{evap_comb (mm)}{Combination (synthetic estimate pre-1970, class A pan
#'    1970 onwards)}
#'  \item{evap_morton_lake (mm)}{Morton's shallow lake evaporation}
#'  \item{radiation (Mj/\ifelse{html}{\out{m<sup>2</sup>}}{m\eqn{^2}})}{Solar
#'    exposure, consisting of both direct and diffuse components}
#'  \item{rh_tmax (%)}{Relative humidity at the time of maximum temperature}
#'  \item{rh_tmin (%)}{Relative humidity at the time of minimum temperature}
#'  \item{et_short_crop (mm)}{
#'     \ifelse{html}{\out{FAO56<sup>4</sup>}}{FAO56\eqn{^4}} short crop}
#'  \item{et_tall_crop (mm)}{
#'     \ifelse{html}{\out{ASCE<sup>5</sup>}}{ASCE\eqn{^5}} tall
#'     \ifelse{html}{\out{crop<sup>6</sup>}}{crop\eqn{^6}}}
#'  \item{et_morton_actual (mm)}{Morton's areal actual evapotranspiration}
#'  \item{et_morton_potential (mm)}{Morton's point potential evapotranspiration}
#'  \item{et_morton_wet (mm)}{Morton's wet-environment areal potential
#'    evapotranspiration over land}
#'  \item{mslp (hPa)}{Mean sea level pressure}
#' }
#'
#' @section Value information:
#'
#' Solar radiation: total incoming downward shortwave radiation on a horizontal
#'   surface, derived from estimates of cloud oktas and sunshine
#'   \ifelse{html}{\out{duration<sup>3</sup>}}{duration\eqn{^3}}.
#'
#' Relative humidity: calculated using the vapour pressure measured at 9am, and
#'   the saturation vapour pressure computed using either the maximum or minimum
#'   \ifelse{html}{\out{temperature<sup>6</sup>}}{temperature\eqn{^6}}.
#'
#' Evaporation and evapotranspiration: an overview of the variables provided by
#'   \acronym{SILO} is available here,
#'   <https://data.longpaddock.qld.gov.au/static/publications/Evapotranspiration_overview.pdf>.
#'
#' @section Data codes:
#'
#' The data are supplied with codes indicating how each datum was obtained.
#'
#'   \describe{
#'     \item{0}{Official observation as supplied by the Bureau of Meteorology}
#'     \item{15}{Deaccumulated rainfall (original observation was recorded
#'       over a period exceeding the standard 24 hour observation period).}
#'     \item{25}{Interpolated from daily observations for that date.}
#'     \item{26}{Synthetic Class A pan evaporation, calculated from
#'       temperatures, radiation and vapour pressure.}
#'     \item{35}{Interpolated from daily observations using an anomaly
#'       interpolation method.}
#'     \item{75}{Interpolated from the long term averages of daily
#'       observations for that day of year.}
#'   }
#'
#' @return a [data.table::data.table] with the weather data queried with the
#'   weather variables in alphabetical order.  The first eight columns will
#'   always be:
#'
#'   * `station_code`,
#'   * `station_name`,
#'   * `longitude`,
#'   * `latitude`,
#'   * `elev_m` (elevation in metres),
#'   * `date` (ISO8601 format, "YYYYMMDD"),
#'   * `year`,
#'   * `month`,
#'   * `day`,
#'   * `extracted` (the date on which the query was made)
#'
#' @references
#' 1. Rayner, D. (2005). Australian synthetic daily Class A pan evaporation.
#'   Technical Report December 2005, Queensland Department of Natural Resources
#'   and Mines, Indooroopilly, Qld., Australia, 40 pp.
#'
#' 2. Morton, F. I. (1983). Operational estimates of areal evapotranspiration
#'   and their significance to the science and practice of hydrology, *Journal
#'   of Hydrology*, Volume 66, 1-76.
#'
#' 3. Zajaczkowski, J., Wong, K., & Carter, J. (2013). Improved historical
#'   solar radiation gridded data for Australia, *Environmental Modelling &
#'   Software*, Volume 49, 64–77. DOI: \doi{10.1016/j.envsoft.2013.06.013}.
#'
#' 4. Food and Agriculture Organization of the United Nations,
#'   Irrigation and drainage paper 56: Crop evapotranspiration - Guidelines for
#'   computing crop water requirements, 1998.
#'
#' 5. ASCE’s Standardized Reference Evapotranspiration Equation, proceedings of
#'   the National Irrigation Symposium, Phoenix, Arizona, 2000.
#'
#' 6. For further details refer to Jeffrey, S.J., Carter, J.O., Moodie, K.B. and
#'   Beswick, A.R. (2001). Using spatial interpolation to construct a
#'   comprehensive archive of Australian climate data, *Environmental Modelling
#'   and Software*, Volume 16/4, 309-330. DOI:
#'   \doi{10.1016/S1364-8152(01)00008-1}.
#'
#' @examples
#' \dontrun{
#'
#'   # Source data from a list of latitude and longitude coordinates in NSW & WA
#'
#'   locs <- list(
#'     "Merredin" = c(x = 118.28, y = -31.48),
#'     "Corrigin" = c(x = 117.87, y = -32.33),
#'     "Tamworth" = c(x = 150.84, y = -31.07)
#'   )
#'
#'   # Replace "your_api_key" with a valid email address.
#'
#'   w <- extract_patched_point(
#'     x = locs,
#'     start_date = "20210101",
#'     end_date = "20210131",
#'     api_key = "your_api_key"
#'   )
#' }
#'
#' @author Adam H. Sparks, \email{adamhsparks@gmail.com}
#'
#' @family weather data
#' @family SILO
#'
#' @autoglobal
#' @export
#'
extract_patched_point <- function(x,
                                  start_date,
                                  end_date,
                                  n_stations = 1L,
                                  values = "all",
                                  api_key = NULL) {
  .check_lonlat(x)

  n_stations <- as.integer(n_stations)

  all_stations <-
    weatherOz::find_nearby_stations(
      latitude = -25.5833,
      longitude = 134.5667,
      distance_km = 10000,
      which_api = "silo"
    )[, -c("distance_km")]

  # find the nearest stations for each point and return the row index value
  # for the station in `all_stations`. Return two lists, one with the index
  # for the row in which the minimum distance occurs in `all_stations`, `r`.
  # The second, `s`, contains the distance in kilometres from the requested
  # lat/lon values from `x` in km.

  distance_km <- vector(mode = "list", length = length(x))
  names(distance_km) <- names(x)

  for (i in seq_along(x)) {
    d <- round(
      .haversine_distance(
        lat1 = x[[i]][["y"]],
        lon1 = x[[i]][["x"]],
        lat2 = all_stations$latitude,
        lon2 = all_stations$longitude
      ),
      1
    )

    row_id <-
      as.vector(apply(as.matrix(d), 2, function(x)
        order(x)[seq_len(n_stations)]))
    distance <- d[row_id]

    distance_km[[i]] <- c(row_id = row_id, distance_km = distance)
  }

  distance_km_df <- as.data.frame(t(as.data.frame(distance_km)))
  distance_km_df$location <- row.names(distance_km_df)

  distance_km_df <- data.table::data.table(
    stats::reshape(
      data = distance_km_df,
      idvar = "location",
      varying = list(
        row_id = grep("row_id", names(distance_km_df)),
        distance_km = grep("distance_km", names(distance_km_df))
      ),
      direction = "long",
      v.names = c("row", "distance"),
      sep = "."
    )
  )[, -c("time")]

  stations_meta <- all_stations[unlist(distance_km_df$row), ]
  stations_meta[, location := distance_km_df$location]
  stations_meta[, distance := distance_km_df$location]


  silo_stations <-
    subset(stations_meta, owner == "BOM")[, c("station_code", "location")]
  silo_stations[, station_code := as.character(station_code)]
  data.table::setkey(silo_stations, station_code)

  out <- data.table::rbindlist(
    purrr::map(
      .x = silo_stations$station_code,
      .f = weatherOz::get_patched_point,
      start_date = start_date,
      end_date = end_date,
      values = values,
      api_key = api_key
    )
  )[, -4]

  data.table::setkey(out, station_code)

  data.table::setnames(out,
                       old = c("longitude",
                               "latitude"),
                       new = c("station_longitude",
                               "station_latitude"))

  out <- merge(x = out, y = silo_stations, by = "station_code")

  xx <- unlist(x)
  xx <- data.table::data.table(utils::stack(xx))
  xx[, c("location", "coord") := data.table::tstrsplit(ind, ".", fixed = TRUE)]
  xx[, ind := NULL]
  xx <- data.table::dcast(xx, location ~ coord, value.var = "values")
  out <- merge(out, xx, by = "location")
  data.table::setcolorder(x = out, c("location", "x", "y"))
  return(out[])
}

#' Distance over a great circle. Reasonable approximation.
#' @noRd
.haversine_distance <- function(lat1, lon1, lat2, lon2) {
  # to radians
  lat1 <- lat1 * 0.01745
  lat2 <- lat2 * 0.01745
  lon1 <- lon1 * 0.01745
  lon2 <- lon2 * 0.01745

  delta_lat <- abs(lat1 - lat2)
  delta_lon <- abs(lon1 - lon2)

  # radius of earth
  12742 * asin(sqrt(`+`(
    (sin(delta_lat / 2)) ^ 2,
    cos(lat1) * cos(lat2) * (sin(delta_lon / 2)) ^ 2
  )))
}
