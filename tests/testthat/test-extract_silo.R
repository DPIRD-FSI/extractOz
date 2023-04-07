

test_that("extract_silo() fetches the expected weather data", {
  skip_if_offline()
  # see "tests/helper_locs.R" for 'locs'
  vcr::use_cassette("extract_silo", {
    w_all <-
      extract_silo(x = locs,
                     first = "20220101",
                     last = "20220102",
                     email = Sys.getenv("SILO_API_KEY"))
  })
  expect_equal(unique(w_all$location), c("Merredin", "Corrigin", "Tamworth"))
  expect_s3_class(w_all, "data.frame")
  expect_length(w_all,29)
})
