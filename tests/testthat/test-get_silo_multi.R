

test_that("get_silo_multi() fetches the expected weather data", {
  # see "tests/helper_locs.R" for 'locs'
  vcr::use_cassette("get_silo_multi_all", {
    w_all <-
      get_silo_multi(x = locs,
                     first = "20220101",
                     last = "20220102",
                     email = Sys.getenv("SILO_API_KEY"))
  })
  expect_equal(unique(w_all$location), c("Merredin", "Corrigin", "Tamworth"))
  expect_s3_class(w_all, "data.frame")
  expect_length(w_all,29)
})
