
test_that("extract_ae_zone() extracts proper ae zones", {
  locs <- list(
    "Merredin" = c(x = 118.28, y = -31.48),
    "Corrigin" = c(x = 117.87, y = -32.33),
    "Tamworth" = c(x = 150.84, y = -31.07)
  )
  ae_zones <- extract_ae_zone(x = locs)

  expect_equal(ae_zones$location, c("Corrigin", "Merredin", "Tamworth"))
  expect_equal(ae_zones$ae_zone, c("WA Central", "WA Eastern", "NSW NE/Qld SE"))
  expect_s3_class(ae_zones, "data.frame")
  expect_length(ae_zones, 4)
})
