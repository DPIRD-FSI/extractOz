
#' Retrieve data from SILO (Scientific Information for Land Owners) API
#'
#' A modified wrapper version of [weatherOz::get_silo] that allows for fetching
#' many geophysical points or a single geophysical point.  Download weather data
#' from the \acronym{SILO} \acronym{API} from the gridded data
#' (PatchedPointData) only.  There are three formats available: 'alldata' and
#' 'apsim' with daily frequency and 'monthly' with, that's right, monthly
#' frequency.
#'
#' @param lonlat `Vector` of length 2 with longitude and latitude values in that
#'  order expressed as decimal degrees, optionally named, *e.g.*, "lon" or "x"
#'  (`[1]`) and "lat" or "y" (`[2]`), or a named `list` object of `vectors`.  A
#'  single `vector` representing a single point-of-interest (longitude and
#'  latitude in that order) or a preferably named `list` of longitude and
#'  latitude `vectors` representing the points-of-interest.  When a named `list`
#'  object is provided the "location" column will include the name values, else
#'  it will default to an integer referring to the order in the list in which a
#'  location occurred.  Defaults to `NULL`.  If this argument is used in
#'  conjunction with the argument, `station_id`, this argument will be ignored.
#' @param first `Integer`. A string representing the start date of the query in
#'  the format 'yyyymmdd' (ISO-8601).
#' @param last `Integer`. A string representing the end date of the query in the
#' format 'yyyymmdd' (ISO-8601).
#' @param data_format `Character`. A string specifying the type of data to
#'  retrieve.  Valid values are 'alldata', 'monthly' or 'apsim' (formatted for
#'  use in APSIM modelling).  Note that 'apsim' and 'alldata' only retrieve
#'  daily time-step data.
#' @param email `Character`. A string specifying a valid email address to use
#'  for the request.  The query will return an error if a valid email address is
#'  not provided.
#'
#' @note Where multiple `lonlat` values are provided in a single request and the
#' `data_format` is `apsim`, an extra column, "location" will be provided with
#' the list names names as the values.  Users may then use `split()` to create a
#' list of `data.table` objects that drops this column or subset and remove the
#' "location" column and enable the use of the data in APSIM modelling work.
#'
#' @return A `data.table` containing the retrieved data from the \acronym{SILO}
#'  \acronym{API}.
#'
#' @examplesIf interactive()
#' # Source data from a single point, Southwood, QLD in the 'apsim' format.
#' wd <- get_silo_multi(lonlat = c(lon = 150.05, lat = -27.85),
#'                     first = "20221001",
#'                     last = "20221201",
#'                     data_format = "apsim",
#'                     email = "YOUR EMAIL")
#'
#' # Source data from a list of latitude and longitude coordinates in NSW and WA
#' locs <- list(
#'   "Merredin" = c(x = 118.28, y = -31.48),
#'   "Corrigin" = c(x = 117.87, -32.33),
#'   "Tamworth" = c(x = 150.84, y = -31.07)
#' )
#'
#' wd <- get_silo_multi(lonlat = locs,
#'                     first = "20211001",
#'                     last = "20211201",
#'                     data_format = "apsim",
#'                     email = "YOUR EMAIL")
#'
#' @export

get_silo_multi <- function(lonlat = NULL,
                           first = NULL,
                           last = NULL,
                           data_format = "alldata",
                           email = NULL) {
    return(data.table::rbindlist(
        purrr::map2(
            .x = purrr::map(lonlat, 1),
            .y = purrr::map(lonlat, 2),
            .f = ~ weatherOz::get_silo(
                latitude = .y,
                longitude = .x,
                first = first,
                last = last,
                data_format = data_format,
                email = email
            )
        ),
        idcol = "location"
    ))
}
