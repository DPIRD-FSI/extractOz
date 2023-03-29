
test_that("extract_area() extracts proper areas", {
  # see "tests/helper_locs.R" for 'locs'

  ae_zones <-
    extract_area(x = locs,
                 spatial = aez,
                 area = "AEZ")

  expect_equal(ae_zones$location, c("Corrigin", "Merredin", "Tamworth"))
  expect_equal(ae_zones$AEZ, c("WA Central", "WA Eastern", "NSW NE/Qld SE"))
  expect_named(ae_zones, c("location", "x", "y", "AEZ"))
  expect_s3_class(ae_zones, "data.frame")
  expect_length(ae_zones, 4)
})
