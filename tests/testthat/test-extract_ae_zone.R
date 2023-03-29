
test_that("extract_ae_zone() extracts proper ae zones", {
  # see "tests/helper_locs.R" for 'locs'
  ae_zones <- extract_ae_zone(x = locs)

  expect_equal(ae_zones$location, c("Corrigin", "Merredin", "Tamworth"))
  expect_equal(ae_zones$ae_zone, c("WA Central", "WA Eastern", "NSW NE/Qld SE"))
  expect_s3_class(ae_zones, "data.frame")
  expect_length(ae_zones, 4)
})
