#' GRDC Australian Grains Agroecological Zones
#'
#' An [sf::sf()] object for displaying GRDC Australian Grains Agroecological
#'  Zones.
#'
#' @section Coordinate Reference System:
#' Geodetic CRS:  WGS 84
#'
#' @format An [sf::sf()] polygon object
#'
#' @source The Australian Grains Research and Development Corporation,
#'  \acronym{GRDC}, \url{https://grdc.com.au/}, under CC0 licence.
#'
delayedAssign("aez", local({
  try(
    sf::read_sf(
      system.file("extdata/aez.gpkg", package = "extractOz", mustWork = TRUE)
    ),
    silent = TRUE
  )
}))
