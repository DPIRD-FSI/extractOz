
#' Extract GRDC Agroecological Zones Using Australian GPS Coordinates
#'
#' @param x `Vector` of length 2 with longitude and latitude values expressed as
#'  decimal degree values in that order, named "x" and "y". Or a named `list`
#'  object of `vectors` each as previously described.  When a named `list`
#'  object is provided the "location" column will include the name values, else
#'  it will default to an integer referring to the order in the list in which
#'  the location occurred.
#'
#' @return a `data.table` with the provided \acronym{GPS} coordinates and the
#'  respective \acronym{GRDC} agroecological zone.
#'
#' @family extract functions
#'
#' @examples
#' locs <- list(
#'   "Merredin" = c(x = 118.28, y = -31.48),
#'   "Corrigin" = c(x = 117.87, -32.33),
#'   "Tamworth" = c(x = 150.84, y = -31.07)
#'
#' extract_ae_zone(x = locs)
#' @export

extract_ae_zone <- function(x, coords) {

  points_sf <- sf::st_as_sf(x = .create_dt(x),
                            coords = c("x", "y"),
                            crs = sf::st_crs(aez))

  intersection <- as.integer(sf::st_intersects(points_sf, aez))
  zone <- ifelse(is.na(intersection), "",
                 as.character(aez$AEZ[intersection]))

  return(cbind(x, zone))
}
