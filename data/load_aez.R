delayedAssign("aez", local({
  try(sf::read_sf(system.file(
    "/extdata/aez.gpkg",
    package = "extractOz",
    mustWork = TRUE
  )),
  silent = TRUE)
}))
