
test_that("Test cache", {
  skip_on_cran()
  ## Test remove cache
  if (as.numeric(R.version$major) > 3) {

    expect_false(file.exists(.get_cache_file()))

    ## Cache the "cache", otherwise tests will become annoyingly slow
    file.copy(cache_file, to = paste0(cache_file, "-testthat"))

    ## Reinstate the cache file
    file.copy(from = paste0(cache_file, "-testthat"), cache_file)
  }
})
