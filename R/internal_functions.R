
#' Create a data.table Object From a Named List
#'
#' Take a named list and convert it into a \CRANpkg{data.table} by creating a
#' long-format object and converting to a wide-format object and returning it.
#'
#' @param x `List` with named locations to convert into a \CRANpkg{data.table}
#'  object.
#'
#' @return A \CRANpkg{data.table} object.
#' @keywords Internal
#' @examples
#' locs <- list(
#'   "Merredin" = c(x = 118.28, y = -31.48),
#'   "Corrigin" = c(x = 117.87, y = -32.33),
#'   "Tamworth" = c(x = 150.84, y = -31.07)
#'
#' .create_dt(x = locs)
#'
#' @author Adam H. Sparks, \email{adamhsparks@gmail.com}
#' @autoglobal
#' @noRd
.create_dt <- function(x) {
  x <-
    data.table::rbindlist(lapply(x, utils::stack), idcol = "location")
  return(data.table::dcast(x, location ~ ind, value.var = "values"))
}

#' Check User-input Longitude and Latitude Values for Validity
#'
#' @param x user provided `list`` of numeric values as decimal degrees
#' @noRd
#' @autoglobal
#' @keywords Internal
#' @return invisible `NULL`, called for its side-effects

.check_lonlat <- function(x) {
  if (!(is.list(x)) && !("" %in% methods::allNames(x))) {
    stop(call. = FALSE,
         "`x` must be a named list object of lon/lat values.")
  }

  for (i in x) {
    if (any(names(i) %notin% c("x", "y"))) {
      stop(call. = FALSE,
           "The vectors of lon/lat must be named 'x' and 'y', respectively")
    }
    if (i[["x"]] < 112 || i[["x"]] > 154) {
      stop(
        call. = FALSE,
        "Please check your longitude, `",
        paste0(x[["x"]]),
        "`, to be sure it is valid for Australian data.\n"
      )
    }
    if (i[["y"]] < -44 || i[["y"]] > -10) {
      stop(
        call. = FALSE,
        "Please check your latitude, `",
        paste0(x[["y"]]),
        "`, value to be sure it is valid for Australian data.\n"
      )
    }
  }
  return(invisible(NULL))
}
