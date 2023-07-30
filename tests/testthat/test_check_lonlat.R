

test_that(".check_lonlat() stops if x is not a list", {
  bad_x <- c(x = -118.28, y = -31.48)
  expect_error(.check_lonlat(x = bad_x))
})

test_that(".check_lonlat() stops if lon is outside bounds", {
  bad_lon <- list(
    "Merredin" = c(x = -118.28, y = -31.48),
    "Corrigin" = c(x = 117.87, y = -32.33),
    "Tamworth" = c(x = 150.84, y = -31.07)
  )

  expect_error(.check_lonlat(x = bad_lon))
})


test_that(".check_lonlat() stops if lon is outside bounds", {
  bad_lat <- list(
    "Merredin" = c(x = 118.28, y = -31.48),
    "Corrigin" = c(x = 117.87, y = -32.33),
    "Tamworth" = c(x = 150.84, y = 31.07)
  )

  expect_error(.check_lonlat(x = bad_lat))
})

test_that(".check_lonlat() stops if a vector object is unnamed", {
  y_no_name <- list(
    "Merredin" = c(x = 118.28, y = -31.48),
    "Corrigin" = c(x = 117.87, -32.33),
    "Tamworth" = c(x = 150.84, y = 31.07)
  )

  expect_error(.check_lonlat(x = y_no_name))
})
