
test_that("extract_soil_order() extracts proper orders", {
  # see "tests/helper_locs.R" for 'locs'
  so <- extract_daas_soil_order(x = locs)

  expect_equal(so$location, c("Corrigin", "Merredin", "Tamworth"))
  expect_equal(so$daas_soil_order, c("Sodosol", "Sodosol", "Dermosol"))
  expect_s3_class(so, "data.frame")
  expect_length(so, 4)
})
