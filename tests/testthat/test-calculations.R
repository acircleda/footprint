test_that("airport_footprint() works", {
  tol = 0.1
  expect_equal(airport_footprint("LAX", "PUS"), 1882.79, tolerance = tol)
  expect_equal(airport_footprint("LAX", "PUS", "First"), 5767.621, tolerance = tol)
  expect_equal(airport_footprint("LAX", "PUS", "First", "ch4"), 0.1924946, tolerance = tol)
  expect_type(airport_footprint("LAX", "PUS"), "double")
  expect_error(airport_footprint("LAX"))
})
