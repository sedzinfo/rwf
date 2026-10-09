##########################################################################################
# ADJUST
##########################################################################################
#' @title Compute multiple comparison alpha adjustments
#'
#' @description Calculates Bonferroni and Šidák corrected alpha thresholds for
#' a given family-wise alpha level and number of tests.
#'
#' @param a Numeric. The desired family-wise alpha level (e.g. \code{0.05}).
#' @param ntests Integer. The number of tests (comparisons) being performed.
#'
#' @return A named list with two elements:
#'   \describe{
#'     \item{sidak}{Šidák corrected alpha: \eqn{1 - (1 - \alpha)^{1/k}}.}
#'     \item{bonferroni}{Bonferroni corrected alpha: \eqn{\alpha / k}.}
#'   }
#'
#' @export
#' @examples
#' compute_adjustment(0.05, 100)
compute_adjustment <- function(a, ntests) {
  sidak <- 1 - ((1 - a)^(1 / ntests))
  bonferroni <- a / ntests
  result <- list(sidak = sidak, bonferroni = bonferroni)
  return(result)
}
##########################################################################################
# STANDARDIZE
##########################################################################################
#' @title Compute standard scores from a numeric vector
#'
#' @description Transforms a numeric vector into one of several standard score
#' formats, including z-scores, T-scores, stens, stanines, percentiles, and
#' others. Can operate on raw scores or pre-standardised z-scores.
#'
#' @param vector Numeric vector of raw scores or z-scores (see \code{input}).
#' @param mean Numeric. Population mean used for \code{"uz"} and density types.
#'   Default is \code{0}.
#' @param sd Numeric. Population standard deviation used for \code{"uz"} and
#'   density types. Default is \code{1}.
#' @param type Character. The output score type. One of:
#'   \describe{
#'     \item{\code{"z"}}{Z-scores (mean=0, sd=1).}
#'     \item{\code{"uz"}}{Unstandardise: convert z-scores back to raw scores
#'       using supplied \code{mean} and \code{sd}.}
#'     \item{\code{"sten"}}{Sten scores (1--10, mean=5.5, sd=2).}
#'     \item{\code{"t"}}{T-scores (mean=50, sd=10).}
#'     \item{\code{"stanine"}}{Stanine scores (1--9, mean=5, sd=2).}
#'     \item{\code{"center"}}{Mean-centred scores.}
#'     \item{\code{"center_reversed"}}{Reversed mean-centred scores.}
#'     \item{\code{"percent"}}{Percentage of the maximum observed value.}
#'     \item{\code{"percentile"}}{Cumulative normal percentile (0--100).}
#'     \item{\code{"scale_zero_one"}}{Min-max scaled scores (0--1).}
#'     \item{\code{"normal_density"}}{Normal density values.}
#'     \item{\code{"cumulative_density"}}{Cumulative sum of the input vector.}
#'     \item{\code{"all"}}{Returns a data frame with all score types, sorted
#'       by z-score.}
#'   }
#' @param input Character. Whether \code{vector} contains raw scores
#'   (\code{"non_standard"}) or already-standardised z-scores
#'   (\code{"standard"}). Default is \code{"non_standard"}.
#'
#' @return A numeric vector of transformed scores, or a data frame when
#'   \code{type = "all"}.
#'
#' @importFrom stats pnorm
#'
#' @export
#' @examples
#' vector <- c(rnorm(10), NA, rnorm(10))
#' compute_standard(vector, type = "z")
#' compute_standard(vector, mean = 0, sd = 1, type = "uz")
#' compute_standard(vector, type = "sten")
#' compute_standard(vector, type = "t")
#' compute_standard(vector, type = "stanine")
#' compute_standard(vector, type = "center")
#' compute_standard(vector, type = "center_reversed")
#' compute_standard(vector, type = "percent")
#' compute_standard(vector, type = "scale_zero_one")
#' ndf <- compute_standard(seq(-6, 6, .01), mean = 0, sd = 1, type = "normal_density")
#' plot(ndf)
#' cdf <- compute_standard(ndf, mean = 0, sd = 1, type = "cumulative_density")
#' plot(cdf)
#' compute_standard(vector, type = "all")
#' compute_standard(seq(-6, 6, .1), type = "all", input = "standard")
compute_standard <- function(vector, mean = 0, sd = 1, type = "z", input = "non_standard") {
  if (input == "non_standard") {
    z <- (vector - mean(vector, na.rm = TRUE)) / stats::sd(vector, na.rm = TRUE)
  }
  if (input == "standard") {
    z <- vector
  }
  if (type == "z") {
    result <- z
  }
  if (type == "uz") {
    result <- vector * sd + mean
  }
  if (type == "sten") {
    result <- round((z * 2) + 5.5, 0)
    result[result < 1] <- 1
    result[result > 10] <- 10
  }
  if (type == "t") {
    result <- (z * 10) + 50
  }
  if (type == "stanine") {
    result <- (z * 2) + 5
    result[result < 1] <- 1
    result[result > 9] <- 9
    result <- round(result, 0)
  }
  if (type == "center") {
    result <- vector - mean(vector, na.rm = TRUE)
  }
  if (type == "center_reversed") {
    result <- mean(vector, na.rm = TRUE) - vector
  }
  if (type == "percent") {
    result <- (vector / max(vector, na.rm = TRUE)) * 100
  }
  if (type == "percentile") {
    result <- pnorm(z) * 100
  }
  if (type == "scale_zero_one") {
    result <- (vector - min(vector, na.rm = TRUE)) / (max(vector, na.rm = TRUE) - min(vector, na.rm = TRUE))
  }
  if (type == "normal_density") {
    # result <- (1 / (sqrt(sd * pi))) * exp(-0.5 * ((vector - mean) / sd)^2)
    result <- (1 / (sd * sqrt(2 * pi))) * exp(-0.5 * ((vector - mean) / sd)^2)
  }
  if (type == "cumulative_density") {
    result <- cumsum(vector)
    # result<-cumprod(vector)
    # result<-cummax(vector)
    # result<-cummin(vector)
  }
  if (type == "all") {
    mydata <- data.frame(score = vector)
    mydata$z <- compute_standard(mydata$score, type = "z", input = input)
    mydata$sten <- compute_standard(mydata$score, type = "sten", input = input)
    mydata$t <- compute_standard(mydata$score, type = "t", input = input)
    mydata$stanine <- compute_standard(mydata$score, type = "stanine", input = input)
    mydata$percent <- compute_standard(mydata$score, type = "percent", input = input)
    mydata$percentile <- compute_standard(mydata$score, type = "percentile", input = input)
    mydata$scale_0_1 <- compute_standard(mydata$score, type = "scale_zero_one", input = input)
    result <- data.frame(mydata[order(mydata$z), ])
  }
  return(result)
}
##########################################################################################
# COMPUTE DISSATENUATION
##########################################################################################
#' @title Compute the disattenuation correction for measurement error
#'
#' @description Estimates the true correlation between two variables by
#' correcting the observed correlation for attenuation due to measurement error
#' in both variables.
#'
#' @param variable1 Numeric vector. True scores for the first variable.
#' @param error1 Numeric vector. Measurement error for \code{variable1}.
#'   Must be the same length as \code{variable1}.
#' @param variable2 Numeric vector. True scores for the second variable.
#' @param error2 Numeric vector. Measurement error for \code{variable2}.
#'   Must be the same length as \code{variable2}.
#'
#' @return A numeric scalar. The disattenuated (corrected) correlation
#'   between \code{variable1} and \code{variable2}.
#'
#' @details
#' The observed correlation is computed from the error-contaminated scores
#' (\code{variable + error}). Reliability for each variable is estimated as
#' the ratio of true score variance to total observed variance. The
#' disattenuated correlation is then:
#' \deqn{\rho = \frac{r_{obs}}{\sqrt{R_1 \cdot R_2}}}
#' where \eqn{R_1} and \eqn{R_2} are the reliability estimates.
#'
#' @importFrom stats var cov
#'
#' @export
#' @examples
#' set.seed(1)
#' compute_dissatenuation(rnorm(10), rnorm(10), rnorm(10), rnorm(10))
compute_dissatenuation <- function(variable1, error1, variable2, error2) {
  correlation <- stats::cov(variable1 + error1, variable2 + error2) / sqrt(stats::var(variable1 + error1) * stats::var(variable2 + error2))
  Rb <- stats::var(variable1) / (stats::var(variable1) + stats::var(error1))
  Rth <- stats::var(variable2) / (stats::var(variable2) + stats::var(error2))
  p <- correlation / sqrt(Rb * Rth)
  return(p)
}
##########################################################################################
# COMPUTE SKEWNESS
##########################################################################################
#' @title Compute skewness of a numeric vector
#'
#' @description Calculates the skewness of a numeric vector using the \eqn{b_1}
#' formula consistent with MINITAB and BMDP. Missing values are removed before
#' computation.
#'
#' @param vector Numeric vector.
#'
#' @return A numeric scalar. Positive values indicate right skew, negative
#'   values indicate left skew.
#'
#' @note Formula used: \eqn{b_1 = m_3 / s^3 = g_1 ((n-1)/n)^{3/2}}.
#'   Used in MINITAB and BMDP.
#'   Results match \code{e1071::skewness()} with \code{type = 2}.
#'
#'
#' @export
#' @examples
#' set.seed(1)
#' vector <- rnorm(1000)
#' compute_skewness(vector)
#' e1071::skewness(vector)
compute_skewness <- function(vector) {
  vector <- na.omit(vector)
  n <- length(vector)
  x <- vector - mean(vector)
  y <- sqrt(n) * sum(x^3) / (sum(x^2)^(3 / 2))
  y <- y * ((1 - 1 / n))^(3 / 2)
  return(y)
}
##########################################################################################
# COMPUTE KURTOSIS
##########################################################################################
#' @title Compute kurtosis of a numeric vector
#'
#' @description Calculates the excess kurtosis of a numeric vector using the
#' \eqn{b_2} formula consistent with MINITAB and BMDP. Missing values are
#' removed before computation.
#'
#' @param vector Numeric vector.
#'
#' @return A numeric scalar. A value of 0 indicates a normal distribution;
#'   positive values indicate heavier tails (leptokurtic); negative values
#'   indicate lighter tails (platykurtic).
#'
#' @note Formula used: \eqn{b_2 = m_4 / s^4 - 3 = (g_2 + 3)(1 - 1/n)^2 - 3}.
#'   Used in MINITAB and BMDP.
#'   Results match \code{e1071::kurtosis()} with \code{type = 2}.
#'
#' @export
#' @examples
#' set.seed(1)
#' vector <- rnorm(1000)
#' compute_kurtosis(vector)
#' e1071::kurtosis(vector)
compute_kurtosis <- function(vector) {
  vector <- na.omit(vector)
  n <- length(vector)
  x <- vector - mean(vector)
  r <- n * sum(x^4) / (sum(x^2)^2)
  y <- r * (1 - 1 / n)^2 - 3
  return(y)
}
##########################################################################################
# COMPUTE STANDARD ERROR
##########################################################################################
#' @title Compute the standard error of the mean
#'
#' @param vector Numeric vector. Missing values are removed before computation.
#'
#' @return A numeric scalar. The standard error of the mean.
#'
#' @export
#' @examples
#' set.seed(1)
#' vector <- rnorm(1000)
#' compute_standard_error(vector)
compute_standard_error <- function(vector) {
  x <- na.omit(vector)
  y <- sqrt(var(x) / length(x))
  return(y)
}
##########################################################################################
# COMPUTE CONFIDENCE INTERVAL
##########################################################################################
#' @title Compute confidence interval
#' @param vector vector
#' @keywords functions statistical
#' @export
#' @examples
#' set.seed(1)
#' vector <- rnorm(1000)
#' compute_confidence_inteval(vector)
compute_confidence_inteval <- function(vector) {
  x <- na.omit(vector)
  n <- length(x)
  s <- sd(x)
  y <- qnorm(0.975) * s / sqrt(n)
  return(y)
}
