
#' Extract an Area of Interest Using Australian GPS Coordinates
#'
#' A generic function to extract an area of interest for user-provided
#' \acronym{GPS} coordinates.
#'
#' @inheritParams extract_ae_zone
#'
#' @param spatial a user-supplied [sf] object that contains information to
#'  derive location information from.
#' @param area the field in `spatial` that should be returned.
#'
#' @return A `data.table` with the provided \acronym{GPS} coordinates and the
#'  respective `area` value from `spatial`.
#'
#' @examples
#' # load the `aez` data included in the package for use in example only.
#' # the `extract_ae_zone()` performs this exact task, this is strictly
#' # for demonstration purposes only
#'
#' library(sf)
#'
#' aez <- read_sf(system.file(
#' "extdata",
#' "aez.gpkg",
#' package = "extractOz",
#' mustWork = TRUE
#' ))
#'
#' locs <- list(
#'   "Merredin" = c(x = 118.28, y = -31.48),
#'   "Corrigin" = c(x = 117.87, -32.33),
#'   "Tamworth" = c(x = 150.84, y = -31.07)
#' )
#'
#' extract_area(x = locs, spatial = aez, area = "AEZ")
#' @export

extract_area <- function(x, spatial, area) {
  spatial <- sf::st_transform(spatial, crs = 4326)

  x <- .create_dt(x)

  points_sf <- sf::st_as_sf(
    x = x,
    coords = c("x", "y"),
    crs = sf::st_crs(spatial)
  )

  intersection <- as.integer(sf::st_intersects(points_sf, spatial))
  a <- data.table::data.table(ifelse(is.na(intersection), "",
                                as.character(spatial[[area]][intersection])))

  x <- cbind(x, a)
  data.table::setnames(x, old = "V1", new = area)
  return(x[])
}
