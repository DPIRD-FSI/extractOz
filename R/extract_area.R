
#' Extract an Area of Interest Using Australian GPS Coordinates
#'
#' A generic function to extract an area of interest for user-provided
#' \acronym{GPS} coordinates.
#'
#' @param x a `data.frame` of \acronym{GPS} coordinates in two columns.
#' @param coords names or numbers of the numeric columns holding coordinates in
#'  `lonlat`.
#' @param spatial a user-supplied [sf] object that contains information to
#'  derive location information from.
#' @param area the field in `spatial` that should be returned.
#'
#' @return a `data.frame` with the provided \acronym{GPS} coordinates and the
#'  respective `area` value from `spatial`.
#'
#' @family extract functions
#'
#' @examples
#' spatial <- aez
#' locs <- data.frame(
#'   site = c("Merredin", "Corrigin", "Tamworth"),
#'   "x" = c(118.28, 117.87, 150.84),
#'   "y" = c(-31.48, -32.33, -31.07)
#' )
#' extract_area(x = locs, coords = c("x", "y"), spatial = spatial, area = "AEZ")
#' @export

extract_area <- function(x, coords, spatial, area) {
  spatial <- sf::st_transform(spatial, crs = 4326)

  points_sf <- sf::st_as_sf(x = x,
                            coords = coords,
                            crs = sf::st_crs(spatial))

  intersection <- as.integer(sf::st_intersects(points_sf, spatial))
  a <- ifelse(is.na(intersection), "",
              as.character(spatial[[area]][intersection]))

  x <- cbind(x, a)
  names(x)[names(x) == "a"] <- area
  return(x)
}
