
test_that("extract_soil_order() extracts proper orders", {
  # see "tests/helper_locs.R" for 'locs'
  skip_if_offline()
  skip_on_ci() # the downloading of the large data file doesn't work well with CI
  so <- extract_daas_soil_order(x = locs, cache = FALSE)

  expect_equal(so$location, c("Corrigin", "Merredin", "Tamworth"))
  expect_equal(so$daas_soil_order, c("Sodosol", "Sodosol", "Dermosol"))
  expect_s3_class(so, "data.frame")
  expect_length(so, 4)
})
