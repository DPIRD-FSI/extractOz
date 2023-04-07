
test_that(".get_cache_file() works properly", {
  skip_on_cran()

  if (as.numeric(R.version$major) > 3) {
    cache_file <- .get_cache_file()

    expect_true(file.exists(cache_file))

    ## Cache the "cache", otherwise tests will become annoyingly slow
    file.copy(cache_file, to = paste0(cache_file, "-testthat"))

    ## Reinstate the cache file
    file.copy(from = paste0(cache_file, "-testthat"), cache_file)
  }
})
