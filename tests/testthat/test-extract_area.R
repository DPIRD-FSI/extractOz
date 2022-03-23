
test_that("extract_area() extracts proper areas", {
  locs <- data.frame(
    site = c("Merredin", "Corrigin", "Tamworth"),
    "x" = c(118.28, 117.87, 150.84),
    "y" = c(-31.48, -32.33, -31.07)
  )

  ae_zones <-
    extract_area(
      x = locs,
      coords = c("x", "y"),
      spatial = aez,
      area = "AEZ"
    )

  expect_equal(ae_zones$site, c("Merredin", "Corrigin", "Tamworth"))
  expect_equal(ae_zones$AEZ, c("WA Eastern", "WA Central", "NSW NE/Qld SE"))
  expect_named(ae_zones, c("site", "x", "y", "AEZ"))
  expect_s3_class(ae_zones, "data.frame")
  expect_length(ae_zones, 4)
})
