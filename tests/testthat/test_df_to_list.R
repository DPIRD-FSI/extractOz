
test_that("df_to_list() produces a named list with vectors", {
  x <- df_to_list(readr::read_csv(system.file(
    "extdata",
    "sample_points.csv",
    package = "extractOz",
    mustWork = TRUE
  )))

  expect_length(x, 3)
  expect_named(x, c("Merredin", "Corrigin", "Tamworth"))
  expect_named(x[[1]], c("x", "y"))
})
