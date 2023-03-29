
test_that("extract_area() extracts proper areas", {
  locs <- list(
    "Merredin" = c(x = 118.28, y = -31.48),
    "Corrigin" = c(x = 117.87, y = -32.33),
    "Tamworth" = c(x = 150.84, y = -31.07)
  )

  ae_zones <-
    extract_area(
      x = locs,
      spatial = aez,
      area = "AEZ"
    )

  expect_equal(ae_zones$location, c("Corrigin", "Merredin", "Tamworth"))
  expect_equal(ae_zones$AEZ, c("WA Central", "WA Eastern", "NSW NE/Qld SE"))
  expect_named(ae_zones, c("location", "x", "y", "AEZ"))
  expect_s3_class(ae_zones, "data.frame")
  expect_length(ae_zones, 4)
})
