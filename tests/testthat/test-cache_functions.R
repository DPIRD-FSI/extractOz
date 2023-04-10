
test_that("cache is created and removed properly", {
  ## Test remove cache by creating a dummy file and deleting it
  if (as.numeric(R.version$major) > 3) {
    daas = NULL
    if (!file.exists(.get_cache_file())) {
      if (!dir.exists(.get_cache_dir())) {
        dir.create(path = .get_cache_dir(), recursive = TRUE)
      }
      save(daas, file = .get_cache_file())
    }
  }
  expect_true(file.exists(.get_cache_file()))

  remove_cache()
  expect_false(file.exists(.get_cache_file()))

})
