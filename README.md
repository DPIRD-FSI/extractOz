
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
    ##   `/private/var/folders/ch/8fqkzddj1kj_qb5ddfdd3p1w0000gn/T/RtmpePjwxl/SoilAtlas2M_ASC_Conversion_v01' 
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

    ##       location      x      y       ae_zone station_code station_name month  day
    ##    1: Corrigin 117.87 -32.33    WA Central       010536           NA  2020 2020
    ##    2: Corrigin 117.87 -32.33    WA Central       010536           NA  2020 2020
    ##    3: Corrigin 117.87 -32.33    WA Central       010536           NA  2020 2020
    ##    4: Corrigin 117.87 -32.33    WA Central       010536           NA  2020 2020
    ##    5: Corrigin 117.87 -32.33    WA Central       010536           NA  2020 2020
    ##   ---                                                                          
    ## 1094: Tamworth 150.84 -31.07 NSW NE/Qld SE       055325           NA  2020 2020
    ## 1095: Tamworth 150.84 -31.07 NSW NE/Qld SE       055325           NA  2020 2020
    ## 1096: Tamworth 150.84 -31.07 NSW NE/Qld SE       055325           NA  2020 2020
    ## 1097: Tamworth 150.84 -31.07 NSW NE/Qld SE       055325           NA  2020 2020
    ## 1098: Tamworth 150.84 -31.07 NSW NE/Qld SE       055325           NA  2020 2020
    ##             date air_tmax air_tmax_source air_tmin air_tmin_source  elev_m
    ##    1: 2020-01-01     37.4              25     15.3              25 295.0 m
    ##    2: 2020-01-02     23.0               0     16.0              25 295.0 m
    ##    3: 2020-01-03     26.0               0     12.5               0 295.0 m
    ##    4: 2020-01-04     34.0               0      8.0               0 295.0 m
    ##    5: 2020-01-05     38.0               0     12.0               0 295.0 m
    ##   ---                                                                     
    ## 1094: 2020-12-27     29.8               0     15.0               0 394.9 m
    ## 1095: 2020-12-28     26.8               0     18.3               0 394.9 m
    ## 1096: 2020-12-29     28.9               0     17.5               0 394.9 m
    ## 1097: 2020-12-30     29.4               0     14.9               0 394.9 m
    ## 1098: 2020-12-31     30.0               0     16.1               0 394.9 m
    ##       et_morton_actual et_morton_actual_source et_morton_potential
    ##    1:              3.1                      26                10.8
    ##    2:              5.0                      26                 5.0
    ##    3:              2.8                      26                 6.9
    ##    4:              4.0                      26                 8.0
    ##    5:              7.9                      26                 9.2
    ##   ---                                                             
    ## 1094:              5.8                      26                 7.1
    ## 1095:              3.7                      26                 4.6
    ## 1096:              2.6                      26                 5.4
    ## 1097:              4.0                      26                 4.7
    ## 1098:              3.0                      26                 6.0
    ##       et_morton_potential_source et_morton_wet et_morton_wet_source
    ##    1:                         26           7.0                   26
    ##    2:                         26           5.0                   26
    ##    3:                         26           4.8                   26
    ##    4:                         26           6.0                   26
    ##    5:                         26           8.5                   26
    ##   ---                                                              
    ## 1094:                         26           6.5                   26
    ## 1095:                         26           4.1                   26
    ## 1096:                         26           4.0                   26
    ## 1097:                         26           4.4                   26
    ## 1098:                         26           4.5                   26
    ##       et_short_crop et_short_crop_source et_tall_crop et_tall_crop_source
    ##    1:           7.9                   26         10.2                  26
    ##    2:           3.6                   26          3.9                  26
    ##    3:           5.1                   26          6.4                  26
    ##    4:           6.7                   26          8.7                  26
    ##    5:           7.5                   26          9.2                  26
    ##   ---                                                                    
    ## 1094:           5.4                   26          6.4                  26
    ## 1095:           3.3                   26          4.0                  26
    ## 1096:           3.8                   26          4.8                  26
    ## 1097:           3.6                   26          4.3                  26
    ## 1098:           4.4                   26          5.6                  26
    ##       evap_comb evap_comb_source evap_morton_lake evap_morton_lake_source
    ##    1:       9.5               25              7.9                      26
    ##    2:      10.4                0              5.1                      26
    ##    3:       8.0                0              5.5                      26
    ##    4:       8.0                0              6.8                      26
    ##    5:      10.6                0              8.8                      26
    ##   ---                                                                    
    ## 1094:       5.5               25              6.7                      26
    ## 1095:       3.6               25              4.2                      26
    ## 1096:       2.6               25              4.0                      26
    ## 1097:       4.3               25              4.4                      26
    ## 1098:       5.0               25              4.6                      26
    ##       evap_pan evap_pan_source evap_syn evap_syn_source  extracted
    ##    1:      9.5              25     11.0              26 2023-08-24
    ##    2:     10.4               0      6.4              26 2023-08-24
    ##    3:      8.0               0      7.9              26 2023-08-24
    ##    4:      8.0               0      9.8              26 2023-08-24
    ##    5:     10.6               0     10.6              26 2023-08-24
    ##   ---                                                             
    ## 1094:      5.5              25      6.9              26 2023-08-24
    ## 1095:      3.6              25      4.3              26 2023-08-24
    ## 1096:      2.6              25      5.1              26 2023-08-24
    ## 1097:      4.3              25      5.0              26 2023-08-24
    ## 1098:      5.0              25      5.9              26 2023-08-24
    ##       station_latitude station_longitude   mslp mslp_source radiation
    ##    1:         -32.3292          117.8733 1012.7          25      30.1
    ##    2:         -32.3292          117.8733 1010.8           0      21.1
    ##    3:         -32.3292          117.8733 1017.2           0      24.1
    ##    4:         -32.3292          117.8733 1020.9           0      28.5
    ##    5:         -32.3292          117.8733 1015.9           0      32.2
    ##   ---                                                                
    ## 1094:         -31.0742          150.8362 1015.7           0      26.2
    ## 1095:         -31.0742          150.8362 1012.7           0      14.2
    ## 1096:         -31.0742          150.8362 1011.4           0      14.3
    ## 1097:         -31.0742          150.8362 1014.2           0      15.1
    ## 1098:         -31.0742          150.8362 1015.8           0      17.0
    ##       radiation_source rainfall rainfall_source rh_tmax rh_tmax_source rh_tmin
    ##    1:               25      0.0               0    22.6             26    83.5
    ##    2:               25      0.0               0    71.2             26   100.0
    ##    3:               25      0.0               0    37.5             26    87.0
    ##    4:               25      0.0               0    26.3             26   100.0
    ##    5:               25      0.0               0    33.4             26   100.0
    ##   ---                                                                         
    ## 1094:               25      2.0               0    46.5             26   100.0
    ## 1095:               25     10.2               0    61.9             26   100.0
    ## 1096:               25      1.0               0    50.0             26    99.6
    ## 1097:               25     18.8               0    52.7             26   100.0
    ## 1098:               25      0.0               0    44.5             26   100.0
    ##       rh_tmin_source   vp vp_deficit vp_deficit_source vp_source
    ##    1:             26 14.5       32.7                26        25
    ##    2:             26 20.0        5.2                26         0
    ##    3:             26 12.6       14.9                26         0
    ##    4:             26 14.0       22.7                26         0
    ##    5:             26 22.1       24.1                26         0
    ##   ---                                                           
    ## 1094:             26 19.5       14.3                26         0
    ## 1095:             26 21.8        9.3                26         0
    ## 1096:             26 19.9       13.8                26         0
    ## 1097:             26 21.6       11.6                26         0
    ## 1098:             26 18.9       15.8                26         0
    ##       daas_soil_order
    ##    1:         Sodosol
    ##    2:         Sodosol
    ##    3:         Sodosol
    ##    4:         Sodosol
    ##    5:         Sodosol
    ##   ---                
    ## 1094:        Dermosol
    ## 1095:        Dermosol
    ## 1096:        Dermosol
    ## 1097:        Dermosol
    ## 1098:        Dermosol

## Code of Conduct

Please note that the {extractOz} project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
