##########################################################################################
# questions_by_keys
##########################################################################################
keys_reference <- function(key) {
  unname(split(seq_along(key), factor(key, levels = seq_len(max(key)))))
}

test_that("questions_by_keys returns the question indices of each dimension", {
  key <- c(1, 2, 3, 4, 5, 1, 2, 3, 4, 5)
  rwf <- questions_by_keys(key)
  expect_type(rwf, "list")
  expect_length(rwf, 5)
  expect_identical(rwf[[1]], c(1L, 6L))
  expect_identical(rwf[[5]], c(5L, 10L))
  expect_identical(rwf, keys_reference(key))
})

test_that("questions_by_keys matches split() on random keys", {
  withr::local_seed(123)
  for (i in 1:10) {
    key <- sample(1:6, 40, replace = TRUE)
    key[1:6] <- 1:6
    expect_identical(questions_by_keys(key), keys_reference(key))
  }
})

test_that("questions_by_keys covers every question exactly once", {
  key <- c(3L, 1L, 2L, 2L, 3L, 1L, 1L)
  rwf <- questions_by_keys(key)
  expect_identical(sort(unlist(rwf)), seq_along(key))
  expect_identical(lengths(rwf), as.integer(table(key)))
})

test_that("questions_by_keys returns an empty element for a dimension without questions", {
  rwf <- questions_by_keys(c(1, 3, 1, 3))
  expect_length(rwf, 3)
  expect_identical(rwf[[2]], integer(0))
  expect_identical(rwf[[3]], c(2L, 4L))
})

##########################################################################################
# questions_dimensions_dataframe
##########################################################################################
test_that("questions_dimensions_dataframe maps questions to their dimensions", {
  key <- c(2, 1, 2, 1, 3)
  rwf <- questions_dimensions_dataframe(
    key = key, dimensions = c("A", "B", "C"),
    elaborate_dimensions = c("Alpha", "Beta", "Gamma"),
    questions = paste0("Q", 1:5)
  )
  expected <- data.frame(
    ORDER = c(2L, 4L, 1L, 3L, 5L),
    DIMENSION = c("A", "A", "B", "B", "C"),
    `ELABORATE DIMENSION` = c("Alpha", "Alpha", "Beta", "Beta", "Gamma"),
    QUESTION = c("Q2", "Q4", "Q1", "Q3", "Q5"),
    check.names = FALSE
  )
  expect_s3_class(rwf, "data.frame")
  expect_identical(names(rwf), c("ORDER", "DIMENSION", "ELABORATE DIMENSION", "QUESTION"))
  expect_equal(rwf, expected, ignore_attr = "row.names")
})

test_that("questions_dimensions_dataframe agrees with questions_by_keys and the key", {
  key <- c(1, 2, 3, 4, 5, 1, 2, 3, 4, 5)
  dimensions <- paste0("Dimension", 1:10)
  elaborate <- paste0("Elaborated_Dimension", 1:10)
  questions <- paste0("Question", 1:65)
  rwf <- questions_dimensions_dataframe(key, dimensions, elaborate, questions)
  expect_identical(nrow(rwf), length(key))
  expect_identical(rwf$ORDER, unlist(questions_by_keys(key)))
  expect_identical(rwf$QUESTION, questions[rwf$ORDER])
  expect_identical(rwf$DIMENSION, dimensions[key[rwf$ORDER]])
  expect_identical(rwf$`ELABORATE DIMENSION`, elaborate[key[rwf$ORDER]])
})

test_that("questions_dimensions_dataframe skips dimensions without questions", {
  rwf <- questions_dimensions_dataframe(
    key = c(1, 3), dimensions = c("A", "B", "C"),
    elaborate_dimensions = c("a", "b", "c"), questions = c("first", "second")
  )
  expect_identical(nrow(rwf), 2L)
  expect_identical(rwf$DIMENSION, c("A", "C"))
  expect_identical(rwf$QUESTION, c("first", "second"))
})
