
#' Extract Soil Order From DAAS Using Australian GPS Coordinates
#'
#' Extracts the major soil order at the GPS points provided.
#'
#' @inheritParams extract_ae_zone
#' @param cache `Boolean`.  Store soil data locally for later use?  If `FALSE`,
#' the downloaded files are removed when \R session is closed. To take advantage
#' of cached files in future sessions, use `cache = TRUE`.  Defaults to `FALSE`.
#' Value is optional.  All future requests will use the cached data unless
#' `remove_cache()` is used to remove the cached file.
#'
#' @note The first run will take additional time to download and extract the
#' soils data.  If `cache = TRUE`, any use after this will be much faster due to
#' the locally cached geospatial soils data.
#'
#' @return A [data.table::data.table] with the provided \acronym{GPS}
#'  coordinates and the respective Digital Atlas of Australian Soils
#'  (\acronym{DAAS} soil order), "Spatial Data Conversion of the Atlas of
#'  Australian Soils to the Australian Soil Classification v01".
#'
#' @source <https://data.gov.au/dataset/ds-dga-5ccb44bf-93f2-4f94-8ae2-4c3f699ea4e7/distribution/dist-dga-56ba5f25-2324-43b5-8df8-b9c69ae2ea0b/details?q=>
#'
#' @examplesIf interactive()
#' locs <- list(
#'   "Merredin" = c(x = 118.28, y = -31.48),
#'   "Corrigin" = c(x = 117.87, y = -32.33),
#'   "Tamworth" = c(x = 150.84, y = -31.07)
#'   )
#'
#' extract_daas_soil_order(x = locs, cache = FALSE)
#' @export

extract_daas_soil_order <- function(x, cache = FALSE) {
  # check if the DAAS data exists in the local cache and if not, download and
  # mask it before saving in the user cache

  .check_lonlat(x)

  if (file.exists(.get_cache_file())) {
    load(.get_cache_file())
  } else {
    if (isTRUE(cache)) {
      message("This is the first time using caching, a cache will be created.")
      daas <- .get_daas_data(.cache = cache)
    } else {
      daas <- .get_daas_data(.cache = cache)
    }
  }

  x <- .create_dt(x)

  points_sf <- sf::st_as_sf(
    x = x,
    coords = c("x", "y"),
    crs = sf::st_crs(daas)
  )

  intersection <- as.integer(sf::st_intersects(points_sf, daas))
  soil <- data.table::data.table(ifelse(is.na(intersection), "",
                                        as.character(daas$SOIL[intersection])))

  out <- cbind(x, soil)
  data.table::setnames(out, old = "V1", new = "daas_soil_order")

  return(out[])
}


# general functions for using the user cache taken from:
# https://github.com/sonatype-nexus-community/oysteR/blob/master/R/cache.R

#' @noRd
.get_cache_dir <- function() {
  R_user_dir = utils::getFromNamespace("R_user_dir", "tools")
  R_user_dir("extractOz", which = "cache")
}

.get_cache_file <- function() {
  dir = .get_cache_dir()
  path = file.path(dir, "daas.RData")
  return(path)
}

#' @noRd
# nocov start
.get_daas_data <- function(.cache) {
  u_remote <-
    "https://data.gov.au/data/"
  d_remote <-
    "dataset/5ccb44bf-93f2-4f94-8ae2-4c3f699ea4e7/resource/56ba5f25-2324-43b5-8df8-b9c69ae2ea0b/download/"
  filename <- "6f804e8b-2de9-4c88-adfa-918ec327c32f.zip"

  url <- paste0(u_remote, d_remote, filename)
  tryCatch(
    # check for an http error b4 proceeding
    if (!httr::http_error(url)) {
      h <- curl::new_handle()
      curl::handle_setopt(h, CONNECTTIMEOUT = 120L)
      curl::curl_download(
        url = url,
        destfile = file.path(tempdir(), filename),
        quiet = FALSE,
        handle = h,
        mode = "wb"
      )

      utils::unzip(file.path(tempdir(), filename), exdir = tempdir())

      x <-
        sf::st_read(dsn = file.path(tempdir(), "SoilAtlas2M_ASC_Conversion_v01"),
                    layer = "soilAtlas2M_ASC_Conversion")
      x <- x[with(x, SOIL != "Nodata" | SOIL != "Lake"),]
      x <- sf::st_transform(x, crs = sf::st_crs(aez))
      sf::st_agr(x) = "constant"
      sf::st_agr(aez) = "constant"
      daas <- sf::st_intersection(x, aez)
    },
    error = function(x)
      stop(
        call. = FALSE,
        "\nThe file download for DAAS has failed. Please try again.\n"
      )
  )

  if (isTRUE(.cache)) {
    if (!file.exists(.get_cache_file())) {
      if (!dir.exists(.get_cache_dir())) {
        dir.create(path = .get_cache_dir(), recursive = TRUE)
      }
      save(daas, file = .get_cache_file())
    }
  }
  return(daas)
} #nocov end

#' Remove DAAS Soil Order Cache
#'
#' The cache is located at `tools::R_user_dir("extractOz", which = "cache")`
#'
#' @return `NULL`, called for its side-effects
#' @export
remove_cache = function() {
  path = .get_cache_file()
  if (file.exists(path))
    file.remove(path)
  return(invisible(NULL))
}
