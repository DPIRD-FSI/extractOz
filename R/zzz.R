.onLoad <- function(libname, pkgname) {
  datafile = sf::st_zm(sf::read_sf(system.file("extdata", "aez.gpkg",
                                               package = "extractOz")))
  assign("aez", datafile, envir = topenv())
}
