
#' Extract Weather from SILO PatchedPointData from Australian GPS Coordinates
#'
#' A modified wrapper version of [weatherOz::get_silo()] that allows for
#'  fetching many geophysical points or a single geophysical point.  Extracts
#'  interpolated weather data from the \acronym{SILO} \acronym{API} from the
#'  gridded data, PatchedPointData, data set.  There are three formats
#'  available: 'alldata' and 'apsim' with daily frequency and 'monthly' with,
#'  that's right, monthly frequency.
#'
#' @inheritParams extract_ae_zone
#'
#' @param first `Integer`. A value representing the start date of the query in
#'  the format 'yyyymmdd' (ISO-8601).
#' @param last `Integer`. A value representing the end date of the query in the
#' format 'yyyymmdd' (ISO-8601).
#' @param data_format `Character`. A string specifying the type of data to
#'  retrieve.  Valid values are 'alldata', 'monthly' or 'apsim' (formatted for
#'  use in \acronym{APSIM} modelling).  Note that 'apsim' and 'alldata' only
#'  retrieve daily time-step data.
#' @param silo_api_key `Character`. A string specifying a valid email address to
#'  use for the request.  The query will return an error if a valid email
#'  address is not provided.
#'
#' @note Where multiple `lonlat` values are provided in a single request and the
#' `data_format` is `apsim`, an extra column, "location" will be provided with
#' the list names names as the values.  Users may then use `split()` to create a
#' list of `data.table` objects that drops this column or `subset()` and remove
#' the "location" column and enable the use of the data in APSIM modelling work.
#'
#' @return A `data.table` containing the retrieved data from the \acronym{SILO}
#'  \acronym{API}.
#'
#' @examplesIf interactive()
#'
#' # Source data from a list of latitude and longitude coordinates in NSW and WA
#' locs <- list(
#'   "Merredin" = c(x = 118.28, y = -31.48),
#'   "Corrigin" = c(x = 117.87, -32.33),
#'   "Tamworth" = c(x = 150.84, y = -31.07)
#' )
#'
#' wd <- extract_silo(x = locs,
#'                     first = "20211001",
#'                     last = "20211201",
#'                     data_format = "apsim",
#'                     silo_api_key = "YOUR EMAIL")
#'
#' @family weather data
#'
#' @author Adam H. Sparks, \email{adam.sparks@@dpird.wa.gov.au}
#'
#' @export

extract_silo <- function(x,
                           first,
                           last,
                           data_format = "alldata",
                           silo_api_key) {

    .check_lonlat(x)

    return(data.table::rbindlist(
        purrr::map2(
            .x = purrr::map(x, 1),
            .y = purrr::map(x, 2),
            .f = ~ weatherOz::get_silo(
                latitude = .y,
                longitude = .x,
                first = first,
                last = last,
                data_format = data_format,
                email = silo_api_key
            )
        ),
        idcol = "location"
    ))
}
