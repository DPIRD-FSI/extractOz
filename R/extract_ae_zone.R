
#' Extract GRDC Agroecological Zones Using Australian GPS Coordinates
#'
#' @param x a `data.frame` of \acronym{GPS} coordinates in two columns.
#' @param coords names or numbers of the numeric columns holding coordinates in
#'  `lonlat`.
#'
#' @return a `data.frame` with the provided \acronym{GPS} coordinates and the
#'  respective \acronym{GRDC} agroecological zone.
#'
#' @family extract functions
#'
#' @examples
#' locs <- data.frame(
#'   site = c("Merredin", "Corrigin", "Tamworth"),
#'   "x" = c(118.28, 117.87, 150.84),
#'   "y" = c(-31.48, -32.33, -31.07)
#' )
#' extract_ae_zone(x = locs, coords = c("x", "y"))
#' @export

extract_ae_zone <- function(x, coords) {
  if (missing(x)) {
    stop(call. = FALSE,
         "You must provide a `data.frame` of GPS coordinates.")
  }

  points_sf <- sf::st_as_sf(x = x,
                            coords = coords,
                            crs = sf::st_crs(aez))

  intersection <- as.integer(sf::st_intersects(points_sf, aez))
  zone <- ifelse(is.na(intersection), "",
                 as.character(aez$AEZ[intersection]))

  return(cbind(x, zone))
}
