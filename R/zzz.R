.onLoad <- function(libname, pkgname) {
  assign("aez", sf::st_zm(sf::read_sf(
    system.file("extdata", "aez.gpkg",
                package = "extractOz")
  )), envir = topenv())
}
