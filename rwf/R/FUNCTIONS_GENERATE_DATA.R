##########################################################################################
# GENERATE RANDOM NUMBERS
##########################################################################################
#' @title Generate a data frame of random numbers
#'
#' @description Creates a data frame populated with either normally or uniformly
#' distributed random values, useful for testing and simulation.
#'
#' @param nrows Integer. Number of rows to generate. Default is \code{10}.
#' @param ncols Integer. Number of columns to generate. Default is \code{5}.
#' @param mean Numeric. Mean of the normal distribution. Only used when
#'   \code{type = "normal"}. Default is \code{0}.
#' @param sd Numeric. Standard deviation of the normal distribution. Only used
#'   when \code{type = "normal"}. Default is \code{1}.
#' @param min Integer. Minimum value of the uniform distribution. Only used when
#'   \code{type = "uniform"}. Default is \code{1}.
#' @param max Integer. Maximum value of the uniform distribution. Only used when
#'   \code{type = "uniform"}. Default is \code{5}.
#' @param type Character. Distribution to sample from. One of \code{"normal"}
#'   or \code{"uniform"}. Default is \code{"normal"}.
#'
#' @return A data frame with \code{nrows} rows and \code{ncols} columns of
#'   randomly generated numeric values.
#'
#' @keywords generate
#' 
#' @importFrom stats rnorm
#'
#' @export
#' @examples
#' generate_data(nrows = 10, ncols = 5, mean = 0, sd = 1, type = "normal")
#' generate_data(nrows = 10, ncols = 5, min = 1, max = 5, type = "uniform")
generate_data <- function(nrows = 10, ncols = 5, mean = 0, sd = 1, min = 1, max = 5, type = "normal") {
  df <- data.frame(matrix(NA, ncol = ncols, nrow = nrows))
  if (type == "normal") {
    df[] <- sapply(df, function(x) x <- stats::rnorm(n = nrows, mean = mean, sd = sd))
  }
  if (type == "uniform") {
    df[] <- sapply(df, function(x) x <- sample(min:max, nrows, replace = TRUE))
  }
  return(df)
}
##########################################################################################
# GENERATE FACTOR
##########################################################################################
#' @title Generate a data frame of random factor vectors
#'
#' @description Creates a data frame (or single factor) populated with factor
#' values sampled from a supplied pool, either randomly or in a balanced
#' distribution across levels.
#'
#' @param vector Character vector. The pool of factor levels to sample from.
#'   Default is \code{LETTERS[1:5]}.
#' @param nrows Integer. Number of rows to generate. For \code{type = "balanced"},
#'   \code{nrows} should be divisible by \code{length(vector)}. Default is \code{2}.
#' @param ncols Integer. Number of columns to generate. When \code{ncols = 1},
#'   a single factor vector is returned instead of a data frame. Default is \code{10}.
#' @param type Character. Sampling method. One of:
#'   \itemize{
#'     \item \code{"random"} — each value is sampled independently with replacement.
#'     \item \code{"balanced"} — each level appears exactly \code{nrows / length(vector)}
#'       times per column.
#'   }
#'   Default is \code{"random"}.
#'
#' @return A data frame of factors with \code{nrows} rows and \code{ncols} columns,
#'   or a single factor vector when \code{ncols = 1}.
#'
#' @keywords generate
#' 
#' @export
#' @examples
#' generate_factor(vector = LETTERS[1:5], ncols = 5, nrows = 10, type = "random")
#' generate_factor(vector = LETTERS[1:5], ncols = 5, nrows = 10, type = "balanced")
#' generate_factor(vector = LETTERS[1:5], ncols = 1, nrows = 10, type = "balanced")
#' generate_factor(vector = LETTERS[1:5], ncols = 1, nrows = 10, type = "random")
generate_factor <- function(vector = LETTERS[1:5], nrows = 2, ncols = 10, type = "random") {
  df <- data.frame(matrix(NA, ncol = ncols, nrow = nrows))
  result <- data.frame(sapply(df, function(x) {
    df <- factor()
    if (type == "balanced") {
      for (i in 1:length(vector)) {
        df <- c(df, rep(vector[i], nrows / length(vector)))
      }
      result <- factor(df, levels = vector)
    }
    if (type == "random") {
      df <- sample(vector, size = nrows, replace = TRUE)
    }
    result <- factor(df, levels = vector)
  },
  simplify = FALSE, USE.NAMES = FALSE
  ))
  if (ncols == 1) {
    result <- as.factor(result[, 1])
  }
  return(result)
}
##########################################################################################
# GENERATE RANDOM STRING
##########################################################################################
#' @title Generate random strings
#'
#' @description Produces a character vector of random strings by sampling from
#'  a character pool.
#'
#' @param vector Character vector. The pool of characters to sample from.
#'   Default is \code{c(LETTERS, letters, 0:9)}.
#' @param vector_length Integer. Number of strings to generate. Default is \code{1}.
#' @param nchar Integer. Length of each generated string. Default is \code{5}.
#'
#' @return A character vector of length \code{vector_length}.
#'
#' @export
#' @examples
#' generate_string(nchar = 10)
#' generate_string(nchar = 10, vector_length = 10)
generate_string <- function(vector = c(LETTERS, letters, 0:9), vector_length = 1, nchar = 5) {
  result <- c()
  for (i in 1:vector_length) {
    result[i] <- paste(sample(vector, nchar, replace = TRUE), collapse = "")
  }
  return(result)
}
##########################################################################################
# GENERATE MULTIPLE RESPONSE VECTOR
##########################################################################################
#' @title Generate a multiple response vector
#'
#' @description Creates a character vector where each element contains a comma-separated
#' string of randomly sampled categories, simulating multiple response survey data.
#'
#' @param responses Integer or character vector. The pool of unique response
#'   categories to sample from. Default is \code{1:4}.
#' @param responded Integer vector. Controls how many categories are selected
#'   per observation — one value is sampled from this vector at each iteration.
#'   Default is \code{1:4}.
#' @param length Integer. Number of observations to generate. Default is \code{10}.
#'
#' @return A character vector of length \code{length}, where each element is a
#'   comma-separated string of sampled response categories.
#'
#' @export
#' @examples
#' generate_multiple_response_vector(responses = 1:4, responded = 1:4, length = 10)
generate_multiple_response_vector <- function(responses = 1:4, responded = 1:4, length = 10) {
  result <- c()
  for (i in 1:length) {
    result <- c(result, toString(paste0(sample(responses, sample(responded, 1)))))
  }
  return(result)
}
##########################################################################################
# SIMULATE CORRELATION MATRIX
##########################################################################################
#' @title Generate a data frame with a predetermined correlation structure
#'
#' @description Simulates multivariate normal data whose columns reproduce a
#' target correlation matrix, using Cholesky decomposition. If no matrix is
#' supplied, a random symmetric positive-definite matrix is generated automatically.
#'
#' @param correlation_martix A symmetric positive-definite matrix specifying the
#'   desired correlations between columns. Must pass Cholesky decomposition.
#'   If omitted, a random correlation matrix is generated.
#' @param nrows Integer. Number of observations (rows) to generate. Default is \code{10}.
#'
#' @return A data frame with \code{nrows} rows and \code{ncol(correlation_martix)}
#'   columns of simulated numeric values.
#'
#' @details
#' Uses Cholesky decomposition (\code{chol()}) to factor the target correlation
#' matrix, then multiplies by independent standard normal draws to produce correlated
#' columns. The resulting correlations approximate the target matrix, with accuracy
#' improving as \code{nrows} increases.
#'
#' @keywords generate
#' 
#' @importFrom stats rnorm
#'
#' @seealso \code{\link{generate_data}}, \code{\link{symmetric_matrix}}
#'
#' @export
#' @examples
#' df <- data.frame(matrix(.999, ncol = 2, nrow = 2))
#' correlation_martix <- as.matrix(df)
#' diag(correlation_martix) <- 1
#' df <- generate_correlation_matrix(correlation_martix, nrows = 100)
#' stats::cor(df)
generate_correlation_matrix <- function(correlation_martix, nrows = 10) {
  if (missing(correlation_martix)) {
    correlation_martix <- symmetric_matrix(as.matrix(generate_data(ncols = nrows, nrows = nrows, min = 0.1, max = 1, type = "uniform")))
    diag(correlation_martix) <- 1
  }
  L <- chol(correlation_martix)
  nvars <- dim(L)[1]
  t(L) %*% L
  r <- t(L) %*% matrix(stats::rnorm(nvars * nrows), nrow = nvars, ncol = nrows)
  r <- data.frame(t(r))
  return(r)
}
##########################################################################################
# SIMULATE DATA FROM SAMPLE
##########################################################################################
#' @title Simulate data preserving the correlation structure of an input data frame
#'
#' @description Estimates the covariance matrix and column means from the input
#' data, then draws multivariate normal samples that reproduce the same
#' correlation structure.
#'
#' @param cordata A numeric data frame or matrix. The source data from which
#'   the covariance matrix and means are estimated. Missing values are handled
#'   pairwise.
#' @param nrows Integer. Number of observations to simulate. Default is \code{10}.
#'
#' @return A data frame with \code{nrows} rows and the same number of columns as
#'   \code{cordata}, containing simulated values with matching correlation structure.
#'
#' @details
#' Uses \code{mvrnorm} to draw from a multivariate normal distribution
#' parameterised by the sample covariance matrix and column means of \code{cordata}.
#' Accuracy of the reproduced correlations improves with larger \code{nrows}.
#'
#' @keywords generate
#' 
#' @importFrom MASS mvrnorm
#'
#' @seealso \code{\link{generate_correlation_matrix}}
#'
#' @export
#' @examples
#' correlation_matrix <- generate_correlation_matrix()
#' stats::cor(correlation_matrix)
#' stats::cor(simulate_correlation_from_sample(correlation_matrix, nrows = 1000))
simulate_correlation_from_sample <- function(cordata, nrows = 10) {
  cordata_cov <- cov(cordata, use = "pairwise.complete.obs")
  cordata_means <- colMeans(cordata, na.rm = TRUE)
  result <- data.frame(MASS::mvrnorm(nrows, Sigma = cordata_cov, mu = cordata_means))
  return(result)
}
##########################################################################################
# SIMULATE MISSING DATA
##########################################################################################
#' @title Introduce missing values into a vector or data frame
#'
#' @description Randomly replaces a fixed number of values with \code{NA},
#' either in a vector or across every column of a data frame independently.
#'
#' @param df A numeric vector or data frame. The object into which missing values
#'   are introduced.
#' @param missing Integer. Number of values to replace with \code{NA} per vector
#'   or per column. Must not exceed the length of the vector or \code{nrow(df)}.
#'   Default is \code{5}.
#'
#' @return The input object with \code{missing} values replaced by \code{NA}.
#'   Returns the same type as the input (vector or data frame).
#'
#' @keywords generate
#' 
#' @export
#' @examples
#' generate_missing(rnorm(10), missing = 5)
#' generate_missing(generate_data(nrow = 10, ncol = 2), missing = 5)
generate_missing <- function(df, missing = 5) {
  if (is.null(dim(df))) {
    df[sample(1:length(df), missing, replace = FALSE)] <- NA
  } else {
    for (i in names(df)) {
      df[sample(1:nrow(df), missing, replace = FALSE), i] <- NA
    }
  }
  return(df)
}
