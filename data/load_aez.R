delayedAssign("aez", local({
  try(sf::st_zm(sf::read_sf(
    system.file(
      "extdata/aez.gpkg",
      package = "extractOz",
      mustWork = TRUE
    )
  )),
  silent = TRUE)
}))
