##########################################################################################
# FLATTEN LIST
##########################################################################################
#' @title Flatten a two-dimensional list into a data frame
#'
#' @description Converts a two-dimensional list to a data frame by applying
#' \code{ldply} across the top-level elements.
#'
#' @param mydata A list where each element can be coerced to a data frame.
#'
#' @return A data frame combining all list elements row-wise, with an
#'   additional \code{.id} column containing the top-level list names.
#'   
#' @keywords recode
#' 
#' @importFrom plyr ldply
#'
#' @export
flatten_list <- function(mydata) {
  result <- plyr::ldply(lapply(mydata, function(x) {
    data.frame(x, stringsAsFactors = FALSE)
  }))
  return(result)
}
##########################################################################################
# SWAP
##########################################################################################
#' @title Reverse-score a numeric vector
#'
#' @description Reverses the order of values in a vector by mapping each value
#' to its mirror equivalent based on the observed levels. Useful for
#' reverse-scoring Likert scale items.
#'
#' @param vector Numeric vector to reverse-score.
#'
#' @return A numeric vector of the same length with values reverse-mapped
#'   across the observed range.
#'   
#' @keywords recode
#'
#' @export
#' @examples
#' swap(c(1:10, 1, 2, 3))
swap <- function(vector) {
  f <- factor(vector)
  y <- rev(levels(f))[f]
  class(y) <- class(vector)
  return(y)
}
##########################################################################################
# DUMMY ARRANGE
##########################################################################################
#' @title Dummy-code a multiple response vector into a binary data frame
#'
#' @description Splits a vector of comma-separated multiple response values and
#' returns a binary data frame where each unique response becomes a column, with
#' \code{1} indicating the response was selected and \code{0} indicating it was
#' not.
#'
#' @param vector A character or numeric vector where each element contains one
#'   or more comma-separated response values (e.g. from a multiple choice question).
#'   Single-value responses are also accepted.
#'
#' @return A binary data frame with one row per element of \code{vector} and one
#'   column per unique response value, sorted alphabetically by column name.
#'   Values are \code{1} (selected) or \code{0} (not selected).
#'
#' @importFrom stringr str_split_fixed
#' 
#' @keywords recode
#'
#' @seealso \code{\link{generate_multiple_response_vector}}
#'
#' @export
#' @examples
#' vector1 <- gsub(" ", "",
#'   generate_multiple_response_vector(
#'     responses = c("Agree", "Hi", "All"),
#'     responded = 1:3, length = 10
#'   ),
#'   fixed = TRUE
#' )
#' vector2 <- gsub(" ", "",
#'   generate_multiple_response_vector(responses = 1:4, responded = 1:4, length = 10),
#'   fixed = TRUE
#' )
#' vector3 <- sample(1:4, 10, replace = TRUE)
#' vector4 <- sample(LETTERS[1:3], 10, replace = TRUE)
#' dummy_arrange(vector = vector1)
#' dummy_arrange(vector = vector2)
#' dummy_arrange(vector = vector3)
#' dummy_arrange(vector = vector4)
dummy_arrange <- function(vector) {
  result <- change_data_type(remove_nc(data.frame(stringr::str_split_fixed(vector, ",", n = Inf), check.names = FALSE), value = NA), type = "character")
  mydata <- change_data_type(data.frame(matrix(nrow = length(vector), ncol = ncol(result))), type = "character")
  names(mydata) <- names(result)
  for (r in 1:nrow(result)) {
    for (c in 1:ncol(result)) {
      value <- result[r, c]
      if (!is.na(value)) {
        mydata[r, value] <- value
      }
    }
  }
  mydata <- remove_nc(mydata, remove_rows = FALSE, aggressive = FALSE, remove_cols = TRUE, remove_zero_variance = FALSE)
  mydata[!is.na(mydata)] <- 1
  mydata[is.na(mydata)] <- 0
  mydata <- mydata[, sort(names(mydata))]
  return(mydata)
}
##########################################################################################
# DROP LEVELS
##########################################################################################
#' @title Drop unused factor levels and collapse rare levels into "Other"
#'
#' @description Removes unused factor levels from a data frame and renames any
#' level whose frequency is at or below a threshold to \code{"Other"}, then
#' drops all unused levels.
#'
#' @param df A data frame containing one or more factor columns.
#' @param factor_index Integer vector or \code{NULL}. Column indices of factors
#'   to process. If \code{NULL}, all columns identified by \code{is.factor()}
#'   are processed. Default is \code{NULL}.
#' @param minimum_frequency Integer. Levels with a frequency less than or equal
#'   to this value are collapsed into \code{"Other"}. Default is \code{5}.
#'
#' @return A data frame with the same structure as \code{df}, with rare factor
#'   levels renamed to \code{"Other"} and all unused levels dropped.
#'
#' @keywords recode
#' 
#' @export
#' @examples
#' factor1 <- factor(c(rep("A", 10), rep("B", 10)), levels = c("A", "B", "C", "D"))
#' factor2 <- factor(c(rep("A", 10), rep("B", 10)), levels = c("A", "B", "C", "D"))
#' numeric1 <- c(1:20)
#' df <- data.frame(numeric1, factor1, factor2)
#' df$factor1
#' drop_levels(df = df, minimum_frequency = 9)
#' drop_levels(df = df, minimum_frequency = 10)
drop_levels <- function(df, factor_index = NULL, minimum_frequency = 5) {
  if (is.null(factor_index)) {
    factornames <- names(df)[sapply(df, is.factor)]
  } else {
    factornames <- names(df)[factor_index]
  }
  for (i in factornames) {
    unique_names <- names(table(df[, i]))[table(df[, i]) <= minimum_frequency]
    df[, i] <- factor(df[, i], levels = unique(c(levels(df[, i]), "Other")))
    df[, i][df[, i] %in% unique_names] <- "Other"
    df[, i] <- droplevels(df[, i])
  }
  return(df)
}
