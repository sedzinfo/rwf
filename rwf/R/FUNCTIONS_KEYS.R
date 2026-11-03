##########################################################################################
# KEYS
##########################################################################################
#' @title Convert a key vector to a list of question indices by dimension
#' @description Takes a scoring key that maps each question to a dimension and
#' returns a list where each element contains the indices of questions
#' belonging to that dimension.
#' @param key Integer vector. Each element indicates which dimension the
#'   corresponding question belongs to. Values must be consecutive integers
#'   starting from 1 up to the number of dimensions.
#' @return A named list of length \code{max(key)}, where element \code{i} contains
#'   the integer indices of all questions assigned to dimension \code{i}.
#' @export
#' @examples
#' key <- c(1, 2, 3, 4, 5, 1, 2, 3, 4, 5)
#' questions_by_keys(key)
questions_by_keys <- function(key) {
  keys <- list()
  for (i in 1:max(key)) {
    keys[[i]] <- which(match(key, i) %in% key)
  }
  return(keys)
}
##########################################################################################
# KEYS
##########################################################################################
#' @title Build a question-to-dimension mapping table
#' @description Returns a data frame that maps each question to its dimension,
#' including questionrder, short dimension name, and full dimension
#' description. Useful for documenting scoring keys and validating test
#' structure.
#' @inheritParams questions_by_keys
#' @param dimensions Character vector. Short dimension names, one per dimension.
#'   Length must equal \code{max(key)}.
#' @param elaborate_dimensions Character vector. Full dimension descriptions, one
#'   per dimension. Length must equal \code{max(key)}.
#' @param questions Character vector. Question labels in the same order as \code{key}.
#'   Length must equal \code{length(key)}.
#' @return A data frame with one row per question and four columns:
#'   \describe{
#'     \item{ORDER}{The question's position index within its dimension.}
#'     \item{DIMENSION}{The short dimension name the question belongs to.}
#'     \item{ELABORATE DIMENSION}{The full dimension description.}
#'     \item{QUESTION}{The question label.}
#'   }
#' @seealso \code{\link{questions_by_keys}}
#' @export
#' @examples
#' key <- c(1, 2, 3, 4, 5, 1, 2, 3, 4, 5)
#' dimensions <- paste0("Dimension", 1:10)
#' elaborate_dimensions <- paste0("Elaborated_Dimension", 1:10)
#' questions <- paste0("Question", 1:65)
#' questions_dimensions_dataframe(key, dimensions, elaborate_dimensions, questions)
questions_dimensions_dataframe <- function(key, dimensions, elaborate_dimensions, questions) {
  key_list <- questions_by_keys(key)
  questions_dataframe <- questions_bind_dataframe <- list()
  for (i in 1:length(key_list)) {
    order <- as.data.frame(key_list[[i]])
    dimension <- as.data.frame(rep(dimensions[[i]], length(key_list[[i]])))
    elaborate_dimension <- as.data.frame(rep(elaborate_dimensions[[i]], length(key_list[[i]])))
    questions_in_dimension <- as.data.frame(questions[key_list[[i]]])
    names(questions_in_dimension) <- "QUESTION"
    names(dimension) <- "DIMENSION"
    names(elaborate_dimension) <- "ELABORATE DIMENSION"
    names(order) <- "ORDER"
    questions_bind_dataframe <- cbind(order, dimension, elaborate_dimension, questions_in_dimension)
    questions_dataframe <- rbind(questions_dataframe, questions_bind_dataframe)
  }
  return(questions_dataframe)
}
