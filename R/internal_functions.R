#' Create a data.table object from a named list
#'
#' Take a named list and convert it into a `data.table` by creating a
#' long-format object and converting to a wide-format object and returning it.
#'
#' @param x `List` supplied by the user to convert into a `data.table` object
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
  x <- data.table::rbindlist(lapply(x, utils::stack), idcol = "location")
  return(data.table::dcast(x, location ~ ind, value.var = "values"))
}
