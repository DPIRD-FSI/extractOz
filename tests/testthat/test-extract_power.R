
test_that("extract_power() fetches the expected weather data", {
  skip_if_offline()
  # see "tests/helper_locs.R" for 'locs'
  vcr::use_cassette("extract_power", {
    w_all <- extract_power(
      x = locs,
      first = "19850101",
      last = "19850101",
      community = "ag",
      pars = c("RH2M", "T2M", "PRECTOTCORR"),
      temporal_api = "daily"
    )
  })
  expect_equal(unique(w_all$location),
               c("Merredin", "Corrigin", "Tamworth"))
  expect_s3_class(w_all, "data.frame")
  expect_length(w_all, 11)
})
