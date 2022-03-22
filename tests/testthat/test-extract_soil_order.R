
test_that("extract_soil_order() extracts proper orders", {
  locs <- data.frame(
    site = c("Merredin", "Corrigin", "Tamworth"),
    "x" = c(118.28, 117.87, 150.84),
    "y" = c(-31.48, -32.33, -31.07)
  )
  so <- extract_soil_order(x = locs, coords = c("x", "y"))

  expect_equal(so$site, c("Merredin", "Corrigin", "Tamworth"))
  expect_equal(so$soil, c("Sodosol", "Sodosol", "Dermosol"))
  expect_s3_class(so, "data.frame")
  expect_length(so, 4)
})
