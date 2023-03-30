#' Extract GRDC Agroecological Zones Using Australian GPS Coordinates
#'
#' @param x `List`. An object with names containing `vector` pairings of
#'  longitude and latitude values expressed as decimal degree values in that
#'  order, each individual `vectors`' items should be named "x" (longitude) and
#'  "y" (latitude), respectively.  The `list` item names should be descriptive
#'  of the individual `vectors` and will be included in a "location" column of
#'  the output.
#'
#' @return A `data.table` with the provided \acronym{GPS} coordinates and the
#'  respective \acronym{GRDC} agroecological zone.
#'
#' @examples
#'
#' locs <- list(
#'   "Merredin" = c(x = 118.28, y = -31.48),
#'   "Corrigin" = c(x = 117.87, y = -32.33),
#'   "Tamworth" = c(x = 150.84, y = -31.07)
#'   )
#'
#' extract_ae_zone(x = locs)
#'
#' @export

extract_ae_zone <- function(x) {
  .check_lonlat(x)

  x <- .create_dt(x)
  points_sf <- sf::st_as_sf(
    x = x,
    coords = c("x", "y"),
    crs = sf::st_crs(aez)
  )



  intersection <- as.integer(sf::st_intersects(points_sf, aez))
  zone <- data.table::data.table(ifelse(is.na(intersection), "",
                                        as.character(aez$AEZ[intersection])))
  out <- cbind(x, zone)

  data.table::setnames(out, old = "V1", new = "ae_zone")

  return(out[])
}
