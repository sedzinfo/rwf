##########################################################################################
# rad2deg
##########################################################################################
test_that("rad2deg converts known angles", {
  expect_equal(rad2deg(pi), 180)
  expect_equal(rad2deg(c(0, pi / 6, pi / 4, pi / 2, 2 * pi, -pi)), c(0, 30, 45, 90, 360, -180))
  # the angle of a 1:1 slope is 45 degrees
  expect_equal(rad2deg(atan2(1, 1)), 45)
  expect_equal(rad2deg(1), 57.29577951308232)
})

test_that("rad2deg keeps NA, Inf and the shape of its input", {
  expect_identical(rad2deg(c(NA, Inf, -Inf)), c(NA, Inf, -Inf))
  m <- matrix(c(0, pi, pi / 2, -pi / 2), 2)
  expect_equal(rad2deg(m), matrix(c(0, 180, 90, -90), 2))
  expect_identical(rad2deg(numeric(0)), numeric(0))
})

##########################################################################################
# deg2rad
##########################################################################################
test_that("deg2rad converts known angles", {
  expect_equal(deg2rad(180), pi)
  expect_equal(deg2rad(c(0, 30, 45, 90, 360, -180)), c(0, pi / 6, pi / 4, pi / 2, 2 * pi, -pi))
  expect_equal(sin(deg2rad(30)), 0.5)
  expect_equal(cos(deg2rad(60)), 0.5)
})

test_that("deg2rad keeps NA, Inf and the shape of its input", {
  expect_identical(deg2rad(c(NA, Inf, -Inf)), c(NA, Inf, -Inf))
  m <- matrix(c(0, 180, 90, -90), 2)
  expect_equal(deg2rad(m), matrix(c(0, pi, pi / 2, -pi / 2), 2))
  expect_identical(deg2rad(numeric(0)), numeric(0))
})

test_that("deg2rad and rad2deg are inverses", {
  withr::local_seed(7)
  degrees <- stats::runif(50, -720, 720)
  expect_equal(rad2deg(deg2rad(degrees)), degrees)
  radians <- stats::runif(50, -10, 10)
  expect_equal(deg2rad(rad2deg(radians)), radians)
})
