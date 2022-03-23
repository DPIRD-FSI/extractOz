
#' Extract Soil Order from DAAS using Australian GPS Coordinates
#'
#' @param x a `data.frame` of \acronym{GPS} coordinates in two columns.
#' @param coords names or numbers of the numeric columns holding coordinates in
#'  `lonlat`.
#'
#' @return a `data.frame` with the provided \acronym{GPS} coordinates and the
#'  respective Digital Atlas of Australian Soils (\acronym{DAAS} soil order).
#'
#' @family extract functions
#'
#' @examples
#' locs <- data.frame(
#'   site = c("Merredin", "Corrigin", "Tamworth"),
#'   "x" = c(118.28, 117.87, 150.84),
#'   "y" = c(-31.48, -32.33, -31.07)
#' )
#' extract_soil_order(x = locs, coords = c("x", "y"))
#' @export

extract_soil_order <- function(x, coords) {

  points_sf <- sf::st_as_sf(x = x,
                            coords = coords,
                            crs = sf::st_crs(daas))

  intersection <- as.integer(sf::st_intersects(points_sf, daas))
  soil <- ifelse(is.na(intersection), "",
                 as.character(daas$SOIL[intersection]))

  return(cbind(x, soil))
}
