
# {extractOz}: A Unified Approach to Extracting Data About Australian Locations Using GPS Points <img src='man/figures/logo.png' align='right' />

<!-- badges: start -->

[![tic](https://github.com/adamhsparks/extractOz/workflows/tic/badge.svg?branch=main)](https://github.com/DPIRD-FSI/extractOz/actions)
[![codecov](https://codecov.io/gh/DPIRD-FSI/extractOz/branch/main/graph/badge.svg?token=PBtL3rNIYb)](https://codecov.io/gh/DPIRD-FSI/extractOz)
[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
<!-- badges: end -->

Extract the GRDC agroecological zone, major soil order and weather data
from your GPS sampling points. Datasets for the GRDC agroecological
zones and functions that automatically download modified data from the
Digital Atlas of Australian Soils are included in this package for ease
of use. You may also use your own geospatial vector format file to
extract similar information using the generic function,
`extract_area()`.

## Quick start

You can install {extractOz} like so.

``` r
if (!require("remotes")) {
  install.packages("remotes")
}

remotes::install_github("DPIRD-FSI/extractOz", build_vignettes = TRUE)
```

Load the packages necessary to execute the examples that follow.

``` r
library(extractOz)
library(dplyr)
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

## Create locations in WA and NSW

``` r
locs <- list(
  "Merredin" = c(x = 118.28, y = -31.48),
  "Corrigin" = c(x = 117.87, y = -32.33),
  "Tamworth" = c(x = 150.84, y = -31.07)
)
```

## Extract the GRDC AgroEcological Zones

See `?extract_ae_zone()` for more help on how to use this function.

``` r
z <- extract_ae_zone(x = locs)
```

## Extract the soil order

See `?extract_soil_order()` for more help on how to use this function.

``` r
s <- extract_daas_soil_order(x = locs)
```

    ## Reading layer `soilAtlas2M_ASC_Conversion' from data source 
    ##   `/private/var/folders/gn/jsls6gwj7yj5svyykn8vvsfw0000gp/T/Rtmp1V3C3v/SoilAtlas2M_ASC_Conversion_v01' 
    ##   using driver `ESRI Shapefile'
    ## Simple feature collection with 22584 features and 7 fields
    ## Geometry type: POLYGON
    ## Dimension:     XY
    ## Bounding box:  xmin: 112.8959 ymin: -43.63287 xmax: 153.6362 ymax: -10.49096
    ## Geodetic CRS:  GDA94

## Get Weather Data for these Locations in 2020

Using the previously used list of GPS points, fetch weather data from
SILO for 2020. This is just a non-working example, replace
`your_api_key` with your email address below. See
`?extract_patched_point()` for more help on how to use this function.

### A Note on API Keys

The examples in this README assume that you have stored your API key in
your .Renviron file. See [Chapter
8](https://rstats.wtf/r-startup.html#renviron) in “What They Forgot to
Teach You About R” by Bryan *et al.* for more on storing details in your
.Renviron if you are unfamiliar.

``` r
three_sites <-
  extract_patched_point(
    x = locs,
    start_date = "20200101",
    end_date = "20201231",
    api_key = Sys.getenv("SILO_API_KEY")
  )
```

    ## You have requested station observation data but some rows in this
    ## dataset have data codes for interpolated data.
    ## Check the 'data_source' columns and `get_patched_point()` or
    ## `get_data_drill()` documentation for further details on codes and
    ## references.
    ## 
    ## You have requested station observation data but some rows in this
    ## dataset have data codes for interpolated data.
    ## Check the 'data_source' columns and `get_patched_point()` or
    ## `get_data_drill()` documentation for further details on codes and
    ## references.

## Join the Weather Data with AE Zone, Soil Order and Site Information

Now using `dplyr::left_join()`, create a single `data.frame()` of the
location, GPS coordinates, agroecological zone and weather data.

``` r
left_join(z, three_sites, by = c(
  "location" = "location",
  "x" = "x",
  "y" = "y"
)) %>%
  left_join(s)
```

    ## Joining with `by = join_by(location, x, y)`

    ## data.table [1098, 50]
    ## keys: location
    ## location                   chr  Corrigin Corrigin Corrigin ~
    ## x                          dbl  117.87 117.87 117.87 117.87~
    ## y                          dbl  -32.33 -32.33 -32.33 -32.33~
    ## ae_zone                    chr  WA Central WA Central WA Ce~
    ## station_code               chr  010536 010536 010536 010536~
    ## station_name               lgl  NA NA NA NA NA NA
    ## year                       dbl  2020 2020 2020 2020 2020 20~
    ## day                        dbl  2020 2020 2020 2020 2020 20~
    ## date                       date 2020-01-01 2020-01-02 2020-~
    ## air_tmax                   dbl  37.4 23 26 34 38 37
    ## air_tmax_source            int  25 0 0 0 0 0
    ## air_tmin                   dbl  15.3 16 12.5 8 12 16.5
    ## air_tmin_source            int  25 25 0 0 0 0
    ## elev_m                     chr  295.0 m 295.0 m 295.0 m 295~
    ## et_morton_actual           dbl  3.1 5 2.8 4 7.9 8.2
    ## et_morton_actual_source    int  26 26 26 26 26 26
    ## et_morton_potential        dbl  10.8 5 6.9 8 9.2 9.3
    ## et_morton_potential_source int  26 26 26 26 26 26
    ## et_morton_wet              dbl  7 5 4.8 6 8.5 8.8
    ## et_morton_wet_source       int  26 26 26 26 26 26
    ## et_short_crop              dbl  7.9 3.6 5.1 6.7 7.5 7.2
    ## et_short_crop_source       int  26 26 26 26 26 26
    ## et_tall_crop               dbl  10.2 3.9 6.4 8.7 9.2 8.6
    ## et_tall_crop_source        int  26 26 26 26 26 26
    ## evap_comb                  dbl  9.5 10.4 8 8 10.6 12
    ## evap_comb_source           int  25 0 0 0 0 0
    ## evap_morton_lake           dbl  7.9 5.1 5.5 6.8 8.8 9
    ## evap_morton_lake_source    int  26 26 26 26 26 26
    ## evap_pan                   dbl  9.5 10.4 8 8 10.6 12
    ## evap_pan_source            int  25 0 0 0 0 0
    ## evap_syn                   dbl  11 6.4 7.9 9.8 10.6 10
    ## evap_syn_source            int  26 26 26 26 26 26
    ## extracted                  date 2023-08-22 2023-08-22 2023-~
    ## station_latitude           chr  -32.3292 -32.3292 -32.3292 ~
    ## station_longitude          chr  117.8733 117.8733 117.8733 ~
    ## mslp                       dbl  1012.7 1010.8 1017.2 1020.9~
    ## mslp_source                int  25 0 0 0 0 0
    ## radiation                  dbl  30.1 21.1 24.1 28.5 32.2 31~
    ## radiation_source           int  25 25 25 25 25 25
    ## rainfall                   dbl  0 0 0 0 0 0
    ## rainfall_source            int  0 0 0 0 0 0
    ## rh_tmax                    dbl  22.6 71.2 37.5 26.3 33.4 39~
    ## rh_tmax_source             int  26 26 26 26 26 26
    ## rh_tmin                    dbl  83.5 100 87 100 100 100
    ## rh_tmin_source             int  26 26 26 26 26 26
    ## vp                         dbl  14.5 20 12.6 14 22.1 25
    ## vp_deficit                 dbl  32.7 5.2 14.9 22.7 24.1 22.2
    ## vp_deficit_source          int  26 26 26 26 26 26
    ## vp_source                  int  25 0 0 0 0 0
    ## daas_soil_order            chr  Sodosol Sodosol Sodosol Sod~

## Code of Conduct

Please note that the {extractOz} project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
