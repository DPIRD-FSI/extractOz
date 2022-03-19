## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(extractOz)

## ----create-location----------------------------------------------------------
locs <- data.frame(
  site = c("Merredin", "Corrigin", "Tamworth"),
  "x" = c(118.28, 117.87, 150.84),
  "y" = c(-31.48, -32.33, -31.07)
)

## ----assign-zones-------------------------------------------------------------
z <- assign_zone(x = locs, coords = c("x", "y"))

## ----get-weather, eval=FALSE--------------------------------------------------
#  two_sites  <-
#    get_multi_silodata(
#      latitude = locs$y,
#      longitude = locs$x,
#      Sitename = locs$site,
#      START = "20200101",
#      FINISH = "20201231",
#      email = "MY_EMAIL_ADDRESS"
#    )

## ----join, eval=FALSE---------------------------------------------------------
#  library(dplyr)
#  
#  left_join(z, two_sites, by = c("site" = "Sitename"))

