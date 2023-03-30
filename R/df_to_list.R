
#' Convert a data.frame or Tibble to a list suitable for use in extractOz
#'
#' A helper function to convert `data.frames` or objects inheriting from
#'  `data.frame`, *e.g.* [tibble::tibble()] or [data.table::data.table()] into
#'  a list suitable for use in \pkg{extractOz} functions.
#'
#' @param x `data.frame` a three column object with the first column being the
#'  location name, the second longitude, named "x", and the third, latitude,
#'  named "y", as decimal degrees in `numeric` format
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
#'   df_to_list()
#'
#' @author Adam H. Sparks, \email{adam.sparks@@dpird.wa.gov.au}
#'
#' @return A `list` object suitable for use in any of the `extract` functions
#'  in \pkg{extractOz}.
#'
#' @export
#'
df_to_list <- function(x) {
  y <- asplit(x[, 2:3], 1)

  names(y) <- unlist(x[, 1])

  return(y)
}
