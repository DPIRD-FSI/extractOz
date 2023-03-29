
test_that("extract_soil_order() extracts proper orders", {
  locs <- list(
    "Merredin" = c(x = 118.28, y = -31.48),
    "Corrigin" = c(x = 117.87, y = -32.33),
    "Tamworth" = c(x = 150.84, y = -31.07)
  )
  so <- extract_soil_order(x = locs)

  expect_equal(so$location, c("Corrigin", "Merredin", "Tamworth"))
  expect_equal(so$daas_soil_order, c("Sodosol", "Sodosol", "Dermosol"))
  expect_s3_class(so, "data.frame")
  expect_length(so, 4)
})
