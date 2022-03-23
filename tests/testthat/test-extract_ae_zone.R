
test_that("extract_ae_zone() extracts proper ae zones", {
  locs <- data.frame(
    site = c("Merredin", "Corrigin", "Tamworth"),
    "x" = c(118.28, 117.87, 150.84),
    "y" = c(-31.48, -32.33, -31.07)
  )
  ae_zones <- extract_ae_zone(x = locs, coords = c("x", "y"))

  expect_equal(ae_zones$site, c("Merredin", "Corrigin", "Tamworth"))
  expect_equal(ae_zones$zone, c("WA Eastern", "WA Central", "NSW NE/Qld SE"))
  expect_s3_class(ae_zones, "data.frame")
  expect_length(ae_zones, 4)
})
