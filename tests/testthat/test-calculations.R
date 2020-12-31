test_that("airport_footprint() works",
          {
            tol = 0.1
            expect_equal(airport_footprint("LAX", "PUS"), 1882.79, tolerance = tol)
            expect_equal(airport_footprint("LAX", "PUS", output = "n2o"),
                         9.336,
                         tolerance = tol)
            expect_equal(airport_footprint("LAX", "PUS", "First"),
                         5767.621,
                         tolerance = tol)
            expect_equal(airport_footprint("LAX", "PUS", "First", "ch4"),
                         0.1924946,
                         tolerance = tol)
            expect_type(airport_footprint("LAX", "PUS"), "double")
            expect_error(airport_footprint("LAX"))
            expect_error(airport_footprint("LAX", "1HR"))
            expect_error(airport_footprint("LAXX", "LHR"))
          })

test_that("latlong_footprint() works", {
  tol = 0.1
  expect_equal(
    latlong_footprint(34.052235,-118.243683, 35.179554, 129.075638),
    1881.589,
    tolerance = tol
  )
  expect_type(latlong_footprint(34.052235,-118.243683, 35.179554, 129.075638),
              "double")
  expect_error(latlong_footprint(34.052235,-118.243683, 35.179554))
  expect_error(latlong_footprint(100.052235,-118.243683, 35.179554, 129.075638))
  expect_error(latlong_footprint(34.052235, -181.243683, 35.179554, 129.075638))
})
