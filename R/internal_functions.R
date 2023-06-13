

#' Add %notin% function
#'
#' Negates `%in%` for easier (mis)matching.
#'
#' @param x A character string to match.
#' @param table A table containing values to match `x` against.
#'
#' @return A logical vector, indicating if a mismatch was located for any
#'  element of x: thus the values are TRUE or FALSE and never NA.
#' @keywords internal
#' @noRd
`%notin%` <- function(x, table) {
  match(x, table, nomatch = 0L) == 0L
}

#' Create a data.table object from a named list
#'
#' Take a named list and convert it into a `data.table` by creating a
#' long-format object and converting to a wide-format object and returning it.
#'
#' @param x `List` with named locations to convert into a `data.table` object
#'
#' @return A `data.table` object
#'
#' @examples
#' locs <- list(
#'   "Merredin" = c(x = 118.28, y = -31.48),
#'   "Corrigin" = c(x = 117.87, -32.33),
#'   "Tamworth" = c(x = 150.84, y = -31.07)
#'
#' .create_dt(x = locs)
#'
#' @author Adam H. Sparks, \email{adam,sparks@@dpird.wa.gov.au}
#'
#' @noRd
.create_dt <- function(x) {
  x <-
    data.table::rbindlist(lapply(x, utils::stack), idcol = "location")
  return(data.table::dcast(x, location ~ ind, value.var = "values"))
}

#' Check user-input longitude and latitude values for validity
#'
#' @param longitude user provided numeric value as decimal degrees
#' @param latitude user provided numeric value as decimal degrees
#' @noRd
#' @return invisible `NULL`, called for its side-effects

.check_lonlat <- function(x) {
  if (!(is.list(x)) && !("" %in% methods::allNames(x))) {
    stop(call. = FALSE,
         "`x` must be a named list object of lon/lat values.")
  }
  for (i in x)
  {
    if (i[["x"]] < 114.5 || i[["x"]] > 152.5)
    {
      stop(
        call. = FALSE,
        "Please check your longitude, `",
        paste0(x[["x"]]),
        "`, to be sure it is valid for Australian data.\n"
      )
    }
    if (i[["y"]] < -38.5 || i[["y"]] > -23) {
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
