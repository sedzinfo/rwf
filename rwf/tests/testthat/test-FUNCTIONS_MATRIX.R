##########################################################################################
# matrix_triangle
##########################################################################################
reference_triangle <- function(m, off_diagonal = NA, diagonal = NULL, type = "lower") {
  m <- as.matrix(m)
  if (type == "lower") m[upper.tri(m)] <- off_diagonal else m[lower.tri(m)] <- off_diagonal
  if (!is.null(diagonal)) diag(m) <- diagonal
  m
}

test_that("matrix_triangle keeps the lower or upper triangle", {
  m <- matrix(1:9, nrow = 3, ncol = 3)
  expect_equal(matrix_triangle(m), matrix(c(1, 2, 3, NA, 5, 6, NA, NA, 9), 3))
  expect_equal(matrix_triangle(m, type = "upper"), matrix(c(1, NA, NA, 4, 5, NA, 7, 8, 9), 3))
  expect_equal(matrix_triangle(m, diagonal = NA, type = "lower"), matrix(c(NA, 2, 3, NA, NA, 6, NA, NA, NA), 3))
  expect_equal(matrix_triangle(m, off_diagonal = 0, diagonal = 1, type = "upper"), matrix(c(1, 0, 0, 4, 1, 0, 7, 8, 1), 3))
})

test_that("matrix_triangle matches base lower.tri / upper.tri on a correlation matrix", {
  r <- stats::cor(mtcars)
  for (type in c("lower", "upper")) {
    for (diagonal in list(NULL, NA, 0)) {
      result <- matrix_triangle(r, diagonal = diagonal, type = type)
      expect_equal(result, reference_triangle(r, diagonal = diagonal, type = type))
      expect_identical(dim(result), dim(r))
      expect_identical(dimnames(result), dimnames(r))
    }
  }
  # the kept triangle is left exactly as it was
  lower <- matrix_triangle(r)
  expect_identical(lower[lower.tri(r, diag = TRUE)], r[lower.tri(r, diag = TRUE)])
  expect_true(all(is.na(lower[upper.tri(r)])))
})

test_that("matrix_triangle accepts data frames, non-square matrices and NA values", {
  r <- as.data.frame(stats::cor(mtcars[, 1:4]))
  result <- matrix_triangle(r, off_diagonal = 0)
  expect_true(is.matrix(result))
  expect_equal(result, reference_triangle(r, off_diagonal = 0))
  wide <- matrix(1:6, nrow = 2, dimnames = list(c("r1", "r2"), c("a", "b", "c")))
  expect_equal(matrix_triangle(wide), reference_triangle(wide))
  expect_equal(matrix_triangle(wide, type = "upper"), reference_triangle(wide, type = "upper"))
  expect_identical(dim(matrix_triangle(t(wide))), c(3L, 2L))
  with_na <- matrix(c(1, NA, 3, 4, 5, Inf, 7, 8, 9), 3)
  expect_equal(matrix_triangle(with_na), reference_triangle(with_na))
  expect_equal(matrix_triangle(with_na, type = "upper", off_diagonal = -1), reference_triangle(with_na, type = "upper", off_diagonal = -1))
})

##########################################################################################
# display_upper_lower_triangle
##########################################################################################
test_that("display_upper_lower_triangle combines the upper triangle of one matrix with the lower of another", {
  m1 <- matrix(1:9, nrow = 3, ncol = 3)
  m2 <- matrix(11:19, nrow = 3, ncol = 3)
  result <- display_upper_lower_triangle(m_upper = m1, m_lower = m2)
  expect_true(is.matrix(result))
  expect_identical(dim(result), c(3L, 3L))
  expect_equal(unname(result), matrix(c(NA, 12, 13, 4, NA, 16, 7, 8, NA), 3))
  expect_equal(unname(display_upper_lower_triangle(m1, m2, diagonal = "upper")), matrix(c(1, 12, 13, 4, 5, 16, 7, 8, 9), 3))
  expect_equal(unname(display_upper_lower_triangle(m1, m2, diagonal = "lower")), matrix(c(11, 12, 13, 4, 15, 16, 7, 8, 19), 3))
  expect_equal(unname(display_upper_lower_triangle(m1, m2, diagonal = 1)), matrix(c(1, 12, 13, 4, 1, 16, 7, 8, 1), 3))
  expect_equal(unname(display_upper_lower_triangle(m1, m2, diagonal = c(1, 2, 3))), matrix(c(1, 12, 13, 4, 2, 16, 7, 8, 3), 3))
  labelled <- display_upper_lower_triangle(m1, m2, diagonal = c("X1", "X2", "X3"))
  expect_identical(unname(diag(labelled)), c("X1", "X2", "X3"))
  expect_identical(unname(labelled[2, 1]), "12")
})

test_that("display_upper_lower_triangle places two correlation matrices around the diagonal", {
  r_pearson <- stats::cor(mtcars[, 1:5])
  r_spearman <- stats::cor(mtcars[, 1:5], method = "spearman")
  result <- display_upper_lower_triangle(m_upper = r_pearson, m_lower = r_spearman, diagonal = 1)
  expect_identical(rownames(result), rownames(r_pearson))
  expect_identical(colnames(result), colnames(r_pearson))
  expect_identical(result[upper.tri(result)], r_pearson[upper.tri(r_pearson)])
  expect_identical(result[lower.tri(result)], r_spearman[lower.tri(r_spearman)])
  expect_true(all(diag(result) == 1))
})

test_that("display_upper_lower_triangle works for non-square matrices", {
  upper <- matrix(1:6, nrow = 2)
  lower <- matrix(11:16, nrow = 2)
  result <- display_upper_lower_triangle(upper, lower, diagonal = 0)
  expect_identical(dim(result), c(2L, 3L))
  expect_equal(unname(result), matrix(c(0, 12, 3, 0, 5, 6), 2))
})

test_that("display_upper_lower_triangle keeps column names that are not syntactic", {
  skip("rwf bug: display_upper_lower_triangle passes the result through data.frame(), which mangles column names and adds X1, X2, ... to unnamed matrices")
  r <- stats::cor(mtcars[, 1:3])
  dimnames(r) <- list(c("item 1", "βάρος", "x-y"), c("item 1", "βάρος", "x-y"))
  result <- display_upper_lower_triangle(r, r, diagonal = 1)
  expect_identical(dimnames(result), dimnames(r))
  expect_null(dimnames(display_upper_lower_triangle(matrix(1:4, 2), matrix(1:4, 2))))
})

##########################################################################################
# symmetric_matrix
##########################################################################################
test_that("symmetric_matrix mirrors the lower or upper triangle", {
  m_lower <- matrix_triangle(matrix(1:9, nrow = 3, ncol = 3), type = "lower")
  expect_equal(symmetric_matrix(m_lower, duplicate = "lower"), matrix(c(1, 2, 3, 2, 5, 6, 3, 6, 9), 3))
  m_upper <- matrix_triangle(matrix(11:19, nrow = 3, ncol = 3), type = "upper", diagonal = NA)
  expect_equal(symmetric_matrix(m_upper, duplicate = "upper", diagonal = NA), matrix(c(NA, 14, 17, 14, NA, 18, 17, 18, NA), 3))
  expect_equal(symmetric_matrix(m_lower, diagonal = 0), matrix(c(0, 2, 3, 2, 0, 6, 3, 6, 0), 3))
})

test_that("symmetric_matrix rebuilds a correlation matrix from one triangle", {
  r <- stats::cor(mtcars)
  rebuilt_lower <- symmetric_matrix(matrix_triangle(r, type = "lower"), duplicate = "lower")
  rebuilt_upper <- symmetric_matrix(matrix_triangle(r, type = "upper"), duplicate = "upper")
  expect_identical(rebuilt_lower, r)
  expect_identical(rebuilt_upper, r)
  expect_true(isSymmetric(rebuilt_lower))
})

test_that("symmetric_matrix matches Matrix::forceSymmetric", {
  skip_if_not_installed("Matrix")
  withr::local_seed(7)
  m <- matrix(stats::rnorm(36), 6, dimnames = list(paste0("v", 1:6), paste0("v", 1:6)))
  expect_equal(symmetric_matrix(m, duplicate = "lower"), as.matrix(Matrix::forceSymmetric(m, uplo = "L")))
  expect_equal(symmetric_matrix(m, duplicate = "upper"), as.matrix(Matrix::forceSymmetric(m, uplo = "U")))
})

test_that("symmetric_matrix copies column names to row names", {
  m <- matrix(c(1, 0.5, 0, 1), 2, dimnames = list(NULL, c("βάρος", "ύψος")))
  result <- symmetric_matrix(m)
  expect_identical(dimnames(result), list(c("βάρος", "ύψος"), c("βάρος", "ύψος")))
  expect_equal(unname(result), matrix(c(1, 0.5, 0.5, 1), 2))
})

##########################################################################################
# off_diagonal_index
##########################################################################################
test_that("off_diagonal_index returns the diagonal position and its neighbours", {
  result <- off_diagonal_index(length = 6)
  expect_s3_class(result, "data.frame")
  expect_named(result, c("x1", "x2", "x3", "x4"))
  expect_identical(dim(result), c(6L, 4L))
  expected <- data.frame(x1 = as.numeric(1:6), x2 = as.numeric(1:6), x3 = as.numeric(2:7), x4 = as.numeric(0:5))
  expect_equal(result, expected, ignore_attr = "row.names")
  expect_equal(off_diagonal_index(length = 1), data.frame(x1 = 1, x2 = 1, x3 = 2, x4 = 0))
})

test_that("off_diagonal_index indexes the super- and sub-diagonal of a square matrix", {
  m <- matrix(1:25, 5)
  index <- off_diagonal_index(length = 4)
  # (x1, x3) walks the element above-right, (x3, x1) the element below-left of each diagonal entry
  expect_identical(m[cbind(index$x1, index$x3)], m[row(m) + 1 == col(m)])
  expect_identical(m[cbind(index$x3, index$x1)], m[row(m) == col(m) + 1])
  expect_identical(m[cbind(index$x1, index$x2)], diag(m)[1:4])
})
