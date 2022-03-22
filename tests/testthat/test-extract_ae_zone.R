
test_that("extract_soil_order() extracts proper orders", {
  locs <- data.frame(
    site = c("Merredin", "Corrigin", "Tamworth"),
    "x" = c(118.28, 117.87, 150.84),
    "y" = c(-31.48, -32.33, -31.07)
  )
  aez <- extract_ae_zone(x = locs, coords = c("x", "y"))

  expect_equal(aez$site, c("Merredin", "Corrigin", "Tamworth"))
  expect_equal(aez$zone, c("WA Eastern", "WA Central", "NSW NE/Qld SE"))
  expect_s3_class(aez, "data.frame")
  expect_length(aez, 4)
})
