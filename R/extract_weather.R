
#' Extract Weather from SILO and DPIRD Weather Station Networks from Australian GPS Coordinates
#'
#' Extracts weather data for the provided dates from the nearest weather station
#'   to the provided longitude and latitude values in `x`.  Two \acronym{APIs}
#'   are available, 'SILO' or 'DPIRD'.  Either one or both may be used in the
#'   query.  Weather data for the single closest station to the provided
#'   longitude and latitude will always be returned from the selected
#'   \acronym{API(s)}.
#'
#' @inheritParams extract_ae_zone
#' @param first `Integer`. A value representing the start date of the query in
#'   the format 'yyyymmdd' (ISO-8601).
#' @param last `Integer`. A value representing the end date of the query in the
#'   format 'yyyymmdd' (ISO-8601).
#' @param interval `Character`. A string value that indicates whether to
#'  return daily or monthly interval data.  Valid values are 'daily' or
#'   'monthly'.  Defaults to 'daily'.
#' @param n_stations `Integer`. A value indicating how many stations surrounding
#'   the latitude and longitude values found in `x`. Defaults to one (1).
#' @param which_api `Character`. A string value that indicates which API to
#'   use.  Defaults to 'silo'.  Valid values are 'all', for both \acronym{SILO}
#'   (\acronym{BOM}) and \acronym{DPIRD} weather station networks; 'silo' for
#'   only stations in the \acronym{SILO} network; or 'dpird' for stations in the
#'   \acronym{DPIRD} network.
#' @param email `Character`. A string specifying a valid email address to
#'   use for the request. The query will return an error if a valid email
#'  address is not provided.  Only used when `which_api` is set to 'silo' or to
#' 'all'.
#' @param dpird_api_key `Character`. A string value that is the user's
#'   \acronym{API} key from \acronym{DPIRD} (see
#'   <https://www.agric.wa.gov.au/web-apis>).  Only used when `which_api` is
#'   'dpird' or 'all'.
#'
#' @examples
#' \dontrun{
#' # Source data from a list of latitude and longitude coordinates in NSW and WA
#' locs <- list(
#'   "Merredin" = c(x = 118.28, y = -31.48),
#'   "Corrigin" = c(x = 117.87, -32.33),
#'   "Tamworth" = c(x = 150.84, y = -31.07)
#' )
#'
#' # Replace "YOUR API KEY" with a valid DPIRD API key and "YOUR EMAIL"
#' # with a valid email address.
#'
#' w <- extract_weather(
#'   x = locs,
#'   first = "20210101",
#'   last = "20210131",
#'   interval = "daily",
#'   which_api = "all",
#'   dpird_api_key = "YOUR API KEY",
#'   email = "YOUR EMAIL"
#' )
#' }
#'
#' @section SILO data:
#' As evaporation is read at 9am, it has been shifted to the day before, _i.e._
#'   the evaporation measured on 20 April is in the row for 19 April.
#'
#' The 6 Source columns 'smx', 'smn', 'srn', 'sev', 'ssl', 'svp' indicate the
#'   source of the data to their left, namely 'max_temp', 'min_temp',
#'   'rainfall', 'evaporation', 'radiation' and 'vapour_pressure' respectively.
#'   \tabular{rl}{
#'     **0**:\tab Station data, as supplied by the Bureau.\cr
#'     **13**:\tab Deactivated, using nearby station.\cr
#'     **15**:\tab Deaccumulated using interpolated data.\cr
#'     **23**:\tab Nearby station, data from the Bureau.\cr
#'     **25**:\tab Interpolated daily observations.\cr
#'     **75**:\tab Interpolated long-term average.\cr
#' }
#'
#' Relative Humidity has been calculated using 9AM vapour pressure, maximum
#'   temperature and minimum temperature.
#'
#' The accuracy of the data depends on many factors including date, location
#'   and variable.  The original data from \acronym{SILO} include one decimal
#'   place, this has been rounded to whole numbers since the \acronym{SILO}
#'   documentation states, "_For consistency data is supplied using one decimal
#'   place, however it is not accurate to that precision._"
#'
#' @section DPIRD data:
#' \acronym{DPIRD} data will always contain the same columns as \acronym{SILO}
#'   but will have the 6 source columns 'smx', 'smn', 'srn', 'sev', 'ssl', 'svp'
#'   filled with `NA`.
#'
#' @return A [data.table::data.table] of weather station data for the weather
#'   stations nearest the provided longitude and latitude values for the
#'   requested weather station network(s) with the following columns:
#'   \tabular{rl}{
#'     **location**:\tab User supplied name for GPS coordinates in `x`.\cr
#'     **station_code**:\tab Station code as in the respective network.\cr
#'     **station_name**:\tab Station name in the respective network.\cr
#'     **date**:\tab The observation date as an integer, "yyyymmdd".\cr
#'     **year**:\tab Year of observation (YYYY).\cr
#'     **month**:\tab Month of observation (1-12).\cr
#'     **day**:\tab Day of month of observation (1-31).\cr
#'     **jday**:\tab Day of year of the observation. Commonly referred to as the
#'        Julian date.\cr
#'     **min_temperature**:\tab Minimum daily recorded temperature (degrees C).\cr
#'     **max_temperature**:\tab Maximum daily recorded temperature (degrees C).\cr
#'     **accum_days_min**:\tab Accumulated number of days of minimum
#'      temperature.\cr
#'     **accum_days_max**:\tab Accumulated number of days of maximum
#'       temperature.\cr
#'     **rainfall**:\tab Daily recorded rainfall in mm.\cr
#'     **period**:\tab Period over which rainfall was measured.\cr
#'     **solar_exposure**:\tab Daily global solar exposure in MJ/m^2.\cr
#'     **longitude**:\tab Station longitude in decimal degrees (WGS84).\cr
#'     **latitude**:\tab Station latitude in decimal degrees (WGS84).\cr
#'     **state**:\tab State that the station is located in.\cr
#'     **elevation**:\tab Station elevation in metres.\cr
#'     **owner**:\tab Station owner.\cr
#'     **distance**:\tab Distance from specified geolocation in `x`.\cr
#'     **rh_max_t**:\tab Estimated Relative Humidity at Temperature 't_max'.\cr
#'     **rh_min_t**:\tab Estimated Relative Humidity at Temperature 't_min'.\cr
#'   }
#'
#' @author Adam H. Sparks, \email{adam.sparks@@dpird.wa.gov.au}
#'
#' @family weather data
#'
#' @export
#'
extract_weather <-
  function(x,
           first,
           last,
           n_stations = 1L,
           which_api = "silo",
           interval = "daily",
           email = NULL,
           dpird_api_key = NULL) {
    owner <- station_code <- NULL # nocov

    .check_lonlat(x)

    which_api <- .check_which_api(.which_api = which_api)

    n_stations <- as.integer(n_stations)

    if (interval %notin% tolower(c("daily", "monthly"))) {
      stop(call. = FALSE,
           "Only `interval` values of 'daily' or 'monthly' are supported.")
    }

    all_stations <-
      weatherOz::find_nearby_stations(
        latitude = -25.5833,
        longitude = 134.5667,
        distance_km = 10000,
        which_api = which_api,
        api_key = dpird_api_key
      )

    # find the nearest stations for each point and return the row index value
    # for the station in `all_stations`. Return two lists, one with the index
    # for the row in which the minimum distance occurs in `all_stations`, `r`.
    # The second, `s`, contains the distance in kilometres from the requested
    # lat/lon values from `x` in km.

    distance <- row <- vector(mode = "list", length = length(x))
    names(row) <- names(distance) <- names(x)

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

      row[[i]] <- which.min(d)
      distance[[i]] <- min(d)
      t <- data.table(location = as.factor(names(x)), row, distance)
    }

    stations_meta <- all_stations[unlist(t$row), ]
    stations_meta$location <- t$location
    stations_meta$distance <- t$distance

    if (which_api == "silo" || which_api == "all") {
      silo_stations <-
        subset(stations_meta, owner == "BOM")[, c("station_code", "location")]
      silo_stations[, station_code := as.character(station_code)]
      silo_stations <- split(x = silo_stations[, -2],
                             f = silo_stations$location)
    } else if (which_api == "dpird" || which_api == "all") {
      dpird_stations <-
        subset(stations_meta, owner != "BOM")[, c("station_code", "location")]
      dpird_stations[, station_code := as.character(station_code)]
      dpird_stations <- split(x = dpird_stations[, 2],
                              f = dpird_stations$location)
    }

    if (exists("silo_stations")) {
      silo_w <- data.table::rbindlist(
        purrr::map(
          .x = silo_stations,
          .f = weatherOz::get_silo,
          first = first,
          last = last,
          data_format = "alldata",
          email = email
        ),
        idcol = "location"
      )[, -4]
      old_names <-
        c(
          "location",
          "Date",
          "Day",
          "Date2",
          "T.Max",
          "Smx",
          "T.Min",
          "Smn",
          "Rain",
          "Srn",
          "Evap",
          "Sev",
          "Radn",
          "Ssl",
          "VP",
          "Svp",
          "RHmaxT",
          "RHminT",
          "FAO56",
          "Mlake",
          "Mpot",
          "Mact",
          "Mwet",
          "Span",
          "Ssp",
          "EvSp",
          "Ses",
          "MSLPres",
          "Sp"
        )
      new_names <- c("location", "date", "day", "max")
      data.table::setnames(silo_w)
    }
    if (exists("dpird_stations")) {
      dpird_w <- data.table::rbindlist(
        purrr::map(
          .x = dpird_stations,
          .f = weatherOz::get_dpird_summaries,
          first = first,
          last = last,
          interval = "daily",
          api_key = dpird_api_key
        ),
        idcol = "location"
      )
    }

    if (exists(silo_w) && exists(dpird_w)) {
      return(rbind(silo_w, dpird_w))
    } else if (exists(silo_w)) {
      return(silo_w)
    } else {
      return(dpird_w)
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

#' Check user-input API value
#' @param which_api user-provided value for `which_api`
#' @return A lower-case string of a valid API value for \pkg{weatherOz}
#' @noRd
.check_which_api <- function(.which_api) {
  
  .which_api <- tolower(.which_api)

  if (.which_api %notin% c("all", "silo", "dpird")) {
    stop(
      call. = FALSE,
      "You have provided an invalide value for `which_api`.\n",
      "Valid values are 'all', 'silo' or 'dpird'."
    )
  }
}

