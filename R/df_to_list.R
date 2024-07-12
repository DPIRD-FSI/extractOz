
#' Convert a Data Frame Object to a List Suitable For Use
#'
#' A helper function to convert `data.frames` or objects inheriting from
#'  `data.frame`, *e.g.* [tibble::tibble()] or [data.table::data.table()] into
#'  a list suitable for use in \pkg{extractOz} functions.
#'
#' @param x `data.frame`. A three column object with the first column being the
#'  location name, the second longitude, named "x", and the third, latitude,
#'  named "y", as decimal degrees in `numeric` format.
#' @param names `Integer`. The column in which the location names are located.
#'  Defaults to 1.
#' @param lonlat `Vector`. A set of `integer` values indicating the column index
#'  in which the longitude and latitude values are contained. Defaults to `2:3`.
#'
#' @examples
#' library(readr)
#'
#' read_csv(system.file(
#'   "extdata",
#'   "sample_points.csv",
#'   package = "extractOz",
#'   mustWork = TRUE
#' )) |>
#'   df_to_list(names = 1, lonlat = 2:3)
#'
#' @author Adam H. Sparks, \email{adam.sparks@@dpird.wa.gov.au}
#'
#' @return A `list` object suitable for use in any of the `extract` functions
#'  in \pkg{extractOz}.
#' @autoglobal
#' @export
#'
df_to_list <- function(x, names = 1, lonlat = 2:3) {
  y <- asplit(x[, lonlat], 1)

  names(y) <- unlist(x[, names])

  return(y)
}
