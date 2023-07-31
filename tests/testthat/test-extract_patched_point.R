
test_that("extract_patched_point() fetches the expected weather data", {
  skip_if_offline()
  # see "tests/helper_locs.R" for 'locs'
  vcr::use_cassette("extract_patched_point", {
    w_all <- extract_patched_point(
      x = locs,
      start_date = "19850101",
      end_date = "19850101",
      values = "all",
      api_key = "slavish_moo_0k@icloud.com"
    )
  })
  expect_equal(unique(w_all$location),
               c("Corrigin", "Merredin", "Tamworth"))
  expect_s3_class(w_all, "data.frame")
  expect_length(w_all, 48)
  expect_equal(nrow(w_all), 24)
})
