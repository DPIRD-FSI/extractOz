
# {extractOz} <img src="man/figures/logo.png" align="right" />

<!-- badges: start -->
[![tic](https://github.com/adamhsparks/extractOz/workflows/tic/badge.svg?branch=main)](https://github.com/DPIRD-FSI/extractOz/actions)
[![codecov](https://codecov.io/gh/DPIRD-FSI/extractOz/branch/main/graph/badge.svg?token=PBtL3rNIYb)](https://codecov.io/gh/DPIRD-FSI/extractOz)
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
<!-- badges: end -->

Extract the GRDC agroecological zone, major soil order and weather data from your GPS sampling points.
Datasets for the GRDC agroecological zones and functions that automatically download modified data from the Digital Atlas of Australian Soils are included in this package for ease of use.
You may also use your own geospatial vector format file to extract similar information using the generic function, `extract_area()`.

## Quick start

```r
if (!require("remotes")) {
  install.packages("remotes")
}

remotes::install_github("DPIRD-FSI/extractOz", build_vignettes = TRUE)

library(extractOz)
library(dplyr)
```

## Create locations in WA and NSW

```r
locs <- list(
  "Merredin" = c(x = 118.28, y = -31.48),
  "Corrigin" = c(x = 117.87, y = -32.33),
  "Tamworth" = c(x = 150.84, y = -31.07)
)
```

## Extract the GRDC AgroEcological Zones

See `?extract_ae_zone()` for more help on how to use this function.

```r
z <- extract_ae_zone(x = locs)
```

## Extract the soil order

See `?extract_soil_order()` for more help on how to use this function.

```r
s <- extract_soil_order(x = locs)
```

## Get Weather Data for these Locations in 2020

Using the previously used list of GPS points, fetch weather data from SILO for 2020.
This is just a non-working example, replace `YOUR_EMAIL_ADDRESS` with your email address below.
See `?get_silo_multi()` for more help on how to use this function.

```r
three_sites <-
  get_silo_multi(
    x = locs,
    first = "20200101",
    last = "20201231",
    email = "YOUR_EMAIL_ADDRESS"
  )
```

## Join the Weather Data with AE Zone, Soil Order and Site Information

Now using `dplyr::left_join()`, create a single `data.frame()` of the location, GPS coordinates, agroecological zone and weather data.

```r
left_join(z, three_sites, by = c("location" = "location")) %>% 
  left_join(s)
```

## Code of Conduct

Please note that the {extractOz} project is released with a [Contributor Code of Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html). By contributing to this project, you agree to abide by its terms.
