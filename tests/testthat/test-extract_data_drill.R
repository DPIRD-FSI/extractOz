
test_that("extract_data_drill() fetches the expected weather data", {
  skip_if_offline()
  # see "tests/helper_locs.R" for 'locs'
  vcr::use_cassette("extract_data_drill", {
    w_all <- extract_data_drill(
      x = locs,
      start_date = "19850101",
      end_date = "19850101",
      values = "all",
      api_key = "slavish_moo_0k@icloud.com"
    )
  })
  expect_equal(unique(w_all$location),
               c("Merredin", "Corrigin", "Tamworth"))
  expect_s3_class(w_all, "data.frame")
  expect_length(w_all, 45)
  expect_equal(nrow(w_all), 3)
})
