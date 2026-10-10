##########################################################################################
# ROUND DATAFRAME
##########################################################################################
#' @title Round numeric columns in a data frame
#' @description Applies a rounding or transformation function to every numeric
#'   column in a data frame, leaving non-numeric columns (factor, character,
#'   etc.) unchanged.
#' @param df A data frame containing a mix of numeric and non-numeric columns.
#' @param digits Integer number of decimal places. Only used with
#'   \code{type = "round"} and \code{type = "tenth"}. Default is \code{0}.
#' @param type Character string specifying the transformation to apply to
#'   numeric columns:
#'   \describe{
#'     \item{\code{"round"}}{Round to \code{digits} decimal places using
#'       \code{round()} (default).}
#'     \item{\code{"ceiling"}}{Round up to the nearest integer using
#'       \code{ceiling()}.}
#'     \item{\code{"floor"}}{Round down to the nearest integer using
#'       \code{floor()}.}
#'     \item{\code{"tenth"}}{Divide each value by 10 then round to
#'       \code{digits} decimal places — useful for rescaling values that were
#'       multiplied by 10 (e.g. converting tenths back to units).}
#'   }
#' @return A data frame with the same structure as \code{df} where all numeric
#'   columns have been rounded or transformed according to \code{type}.
#' @keywords functions
#' @export
#' @examples
#' round_dataframe(df = change_data_type(df = mtcars, type = "factor"), digits = 0)
#' round_dataframe(df = change_data_type(df = mtcars, type = "character"), digits = 0)
#' round_dataframe(df = mtcars, digits = 0)
#' round_dataframe(df = mtcars, digits = 0, type = "ceiling")
#' round_dataframe(df = mtcars, digits = 0, type = "floor")
#' round_dataframe(df = mtcars * 100, digits = 2, type = "tenth")
round_dataframe <- function(df, digits = 0, type = "round") {
  if (type == "round") {
    df[, sapply(df, is.numeric)] <- round(df[, sapply(df, is.numeric)], digits = digits)
  }
  if (type == "ceiling") {
    df[, sapply(df, is.numeric)] <- ceiling(df[, sapply(df, is.numeric)])
  }
  if (type == "floor") {
    df[, sapply(df, is.numeric)] <- floor(df[, sapply(df, is.numeric)])
  }
  if (type == "tenth") {
    df[, sapply(df, is.numeric)] <- round(df[, sapply(df, is.numeric)] / 10, digits = digits)
  }
  return(df)
}
##########################################################################################
# CHANGE DATA TYPE OF COLLUMNS IN DATA FRAME
##########################################################################################
#' @title Convert column data types in a data frame
#' @description Converts all or selected columns in a data frame to a
#'   specified data type. Whitespace (tabs, carriage returns, newlines) is
#'   trimmed automatically when converting to \code{"character"} or
#'   \code{"numeric"}.
#' @param df A data frame whose columns will be converted.
#' @param type Character string specifying the conversion to apply:
#'   \describe{
#'     \item{\code{"character"}}{Converts all columns to character, trimming
#'       leading and trailing whitespace.}
#'     \item{\code{"numeric"}}{Converts all columns to numeric (via character
#'       with whitespace trimming). Non-numeric strings become \code{NA}.}
#'     \item{\code{"factor"}}{Converts all columns to factor.}
#'     \item{\code{"factor_character"}}{Converts only factor columns to
#'       character; all other columns are left unchanged.}
#'     \item{\code{"character_factor"}}{Converts only character columns to
#'       factor; all other columns are left unchanged.}
#'   }
#' @return A data frame with the same dimensions as \code{df} with column
#'   types converted as specified.
#' @keywords functions
#' @export
#' @examples
#' cdf(df = change_data_type(df = mtcars, "character"))
#' cdf(df = change_data_type(df = mtcars, "numeric"))
#' cdf(df = change_data_type(df = mtcars, "factor"))
#' df <- change_data_type(df = mtcars, "factor")
#' cdf(df = change_data_type(df = df, "factor_character"))
#' cdf(df = change_data_type(df = df, "character_factor"))
change_data_type <- function(df, type) {
  if (type == "character") {
    df[] <- lapply(df, function(x) as.character(trimws(x, which = "both", whitespace = "[\t\r\n]")))
  }
  if (type == "numeric") {
    df[] <- lapply(df, function(x) as.numeric(trimws(as.character(x), which = "both", whitespace = "[\t\r\n]")))
  }
  if (type == "factor") {
    df[] <- lapply(df, as.factor)
  }
  if (type == "factor_character") {
    df[] <- lapply(df, function(x) if (is.factor(x)) as.character(x) else x)
  }
  if (type == "character_factor") {
    df[] <- lapply(df, function(x) if (is.character(x)) factor(x) else x)
  }
  return(df)
}
##########################################################################################
# RBIND ALL
##########################################################################################
#' @title Row-bind two data frames with different column sets
#' @description Combines two data frames or matrices by rows even when they do
#'   not share the same columns. Columns present in one input but absent in the
#'   other are added and filled with \code{NA} before binding. Row names from
#'   both inputs are preserved unless they would produce duplicates, in which
#'   case default integer row names are used.
#' @param df1 A data frame or matrix.
#' @param df2 A data frame or matrix.
#' @return A data frame containing all rows from \code{df1} followed by all
#'   rows from \code{df2}, with the union of both column sets. Cells where a
#'   column did not exist in the original input are \code{NA}.
#' @keywords functions
#' @export
#' @examples
#' df1 <- generate_correlation_matrix(n = 10)
#' df2 <- generate_correlation_matrix(n = 10)
#' names(df2)[4] <- "X11"
#' rbind_all(df1 = df1, df2 = df2)
#' row.names(df1) <- 21:30
#' rbind_all(df1 = df1, df2 = df2)
rbind_all <- function(df1, df2) {
  # matrices are accepted, so work on data frames (a matrix cannot gain a new column by name)
  df1 <- as.data.frame(df1)
  df2 <- as.data.frame(df2)
  df1_diff <- setdiff(colnames(df1), colnames(df2))
  df2_diff <- setdiff(colnames(df2), colnames(df1))
  df1[, c(as.character(df2_diff))] <- NA
  df2[, c(as.character(df1_diff))] <- NA
  row_names <- c(row.names(df1), row.names(df2))
  result <- rbind(df1, df2)
  # keep the original row names unless they clash, then fall back to 1, 2, 3, ...
  if (anyDuplicated(row_names)) {
    row.names(result) <- NULL
  } else {
    row.names(result) <- row_names
  }
  return(result)
}
##########################################################################################
# REMOVE VALUES THAT CANNOT BE CALCULATED
##########################################################################################
#' @title Replace and remove non-computable values
#' @description Cleans a data frame by replacing non-computable values
#'   (\code{NA}, \code{NaN}, \code{Inf}, \code{-Inf}, and empty strings) with
#'   a chosen replacement, then optionally drops rows or columns that still
#'   contain missing values or have zero variance.
#' @param df A data frame to clean.
#' @param value The replacement value for all non-computable entries. Default
#'   is \code{NA}.
#' @param remove_rows Logical. When \code{TRUE}, rows containing \code{NA}
#'   after replacement are removed according to the \code{aggressive} setting.
#'   Default is \code{FALSE}.
#' @param aggressive Logical. Only used when \code{remove_rows = TRUE}.
#'   \itemize{
#'     \item \code{TRUE} — remove a row if \emph{any} value is \code{NA}.
#'     \item \code{FALSE} — remove a row only if \emph{all} values are
#'       \code{NA}.
#'   }
#'   Default is \code{FALSE}.
#' @param remove_cols Logical. When \code{TRUE}, columns where \emph{all}
#'   values are \code{NA} are dropped. Default is \code{FALSE}.
#' @param remove_zero_variance Logical. Only used when \code{remove_cols =
#'   TRUE}. When \code{TRUE}, columns with only one unique non-missing value
#'   (zero variance) are also dropped. Default is \code{FALSE}.
#' @return A data frame with non-computable values replaced and, depending on
#'   the flags, rows and / or columns removed.
#' @keywords functions
#' @export
#' @examples
#' df <- mtcars
#' df[1, ] <- as.numeric(NaN)
#' df[2, ] <- as.numeric(Inf)
#' df[3, ] <- as.numeric(-Inf)
#' df[4, ] <- as.numeric(NA)
#' df[5, ] <- ""
#' remove_nc(df = df, value = NA)
#' cdf(remove_nc(df = df, value = NA))
#' df <- generate_missing(mtcars, missing = 5)
#' remove_nc(df, remove_rows = TRUE, aggressive = FALSE)
#' remove_nc(df, remove_rows = TRUE, aggressive = TRUE)
#' df <- generate_missing(generate_correlation_matrix(nrows = 5), missing = 2)
#' df$X2 <- NA
#' df$X3 <- 1
#' remove_nc(df, remove_cols = TRUE, remove_zero_variance = FALSE)
#' remove_nc(df, remove_cols = TRUE, remove_zero_variance = TRUE)
remove_nc <- function(df, value = NA, remove_rows = FALSE, aggressive = FALSE, remove_cols = FALSE, remove_zero_variance = FALSE) {
  df[is.na(df)] <- value
  # df[sapply(df,is.nan)]<-value
  # df[sapply(df,is.infinite)]<-value
  df[df == Inf] <- value
  df[df == -Inf] <- value
  df[df == NaN] <- value
  df[df == ""] <- value
  if (remove_rows) {
    if (aggressive) {
      df <- df[rowSums(is.na(df)) == 0, , drop = FALSE]
    } else {
      df <- df[apply(df, 1, function(x) any(!is.na(x))), , drop = FALSE]
    }
  }
  if (remove_cols) {
    df <- df[, colSums(!is.na(df)) > 0, drop = FALSE]
    if (remove_zero_variance) {
      # df<-df[,!0==apply(df,2,function(x) stats::sd(x,na.rm=TRUE))]
      df <- df[, apply(df, 2, function(x) length(table(x))) > 1, drop = FALSE]
    }
  }
  return(df)
}
##########################################################################################
# REPLACE NA WITH PREVIOUS CELLS
##########################################################################################
#' @title Last observation carried forward (LOCF) imputation
#' @description Replaces each \code{NA} in a vector with the most recent
#'   preceding non-\code{NA} value (last observation carried forward, LOCF).
#'   If the first element is \code{NA}, it is replaced with the first
#'   non-\code{NA} value found anywhere in the vector. To apply LOCF to every
#'   column of a data frame use \code{df[] <- lapply(df, replace_na_with_previous)}.
#' @param vector A vector of any type that may contain \code{NA} values.
#' @return A vector of the same length and type as \code{vector} with
#'   \code{NA} values replaced by the preceding non-\code{NA} element.
#'   Returns the original vector unchanged if it contains no \code{NA} values.
#' @keywords functions
#' @export
#' @examples
#' set.seed(12345)
#' df1 <- generate_missing(rnorm(10), missing = 5)
#' df2 <- generate_missing(rnorm(10), missing = 5)
#' df3 <- generate_missing(rnorm(10), missing = 5)
#' df4 <- generate_missing(rnorm(10), missing = 5)
#' df5 <- generate_missing(rnorm(10), missing = 5)
#' df <- data.frame(df1, df2, df3, df4, df5)
#' row.names(df) <- paste0("A", row.names(df))
#' replace_na_with_previous(df1)
#' df[] <- lapply(df, replace_na_with_previous)
replace_na_with_previous <- function(vector) {
  if (length(vector) == 0) {
    return(vector)
  }
  if (is.na(vector[1])) {
    vector[1] <- na.omit(vector)[1]
  }
  for (i in seq_along(vector)[-1]) {
    if (is.na(vector[i])) {
      vector[i] <- vector[i - 1]
    }
  }
  return(vector)
}
##########################################################################################
# BIND DATAFRAMES OR VECTORS OF UNEQUAL ROW LENGTHS
##########################################################################################
#' @title Pad a data frame to a target number of rows with NAs
#' @description Extends a data frame to \code{rowsneeded} rows by appending
#'   (or prepending) \code{NA}-filled rows. Internal helper used by
#'   \code{\link{c_bind}}.
#' @param df A data frame to pad.
#' @param rowsneeded Integer target row count. Must be greater than or equal
#'   to \code{nrow(df)}.
#' @param first Logical. When \code{TRUE} (default) \code{NA} rows are
#'   appended at the bottom; when \code{FALSE} they are prepended at the top.
#' @return A data frame with \code{rowsneeded} rows and the same columns as
#'   \code{df}.
#' @author Ananda Mahto
#' @keywords functions
padNA <- function(df, rowsneeded, first = TRUE) {
  column_names <- colnames(df)
  rowsneeded <- rowsneeded - nrow(df)
  temp2 <- setNames(data.frame(matrix(rep(NA, length(column_names) * rowsneeded), ncol = length(column_names))), column_names)
  if (isTRUE(first)) {
    rbind(df, temp2)
  } else {
    rbind(temp2, df)
  }
}
#' @title Get the names of objects passed through dots
#' @description Returns the unevaluated expressions passed in \code{...} as
#'   character strings. Internal helper used by \code{\link{c_bind}} to name
#'   the columns of its output.
#' @param ... Objects whose expressions should be returned as names.
#' @return A character vector with one element per argument in \code{...}.
#' @author Ananda Mahto
#' @keywords functions
dotnames <- function(...) {
  vnames <- as.list(substitute(list(...)))[-1L]
  result <- unlist(lapply(vnames, deparse), FALSE, FALSE)
  return(result)
}
#' @title Column-bind data frames or vectors of unequal lengths
#' @description Combines any number of data frames or vectors side by side,
#'   padding shorter inputs with \code{NA} rows so all columns reach the same
#'   length. Each input's columns are prefixed with the object's name to avoid
#'   duplicate column names. Vectors are coerced to single-column data frames
#'   before binding.
#' @param ... Data frames or vectors to column-bind. Names are taken from the
#'   unevaluated expressions passed (e.g. variable names).
#' @param first Logical. When \code{TRUE} (default) \code{NA} padding rows are
#'   appended at the bottom of shorter inputs; when \code{FALSE} they are
#'   prepended at the top.
#' @return A data frame with one column per column across all inputs, padded
#'   with \code{NA} rows to the length of the longest input. Column names
#'   follow the pattern \code{<object_name>} for single-column inputs and
#'   \code{<object_name>_<original_colname>} for multi-column inputs.
#' @importFrom stats setNames
#' @author Ananda Mahto
#' @keywords functions
#' @export
#' @examples
#' c_bind(rnorm(10), rnorm(11), rnorm(12), rnorm(13))
c_bind <- function(..., first = TRUE) {
  Names <- dotnames(...)
  datalist <- stats::setNames(list(...), Names)
  nrows <- max(sapply(datalist, function(x) {
    ifelse(is.null(dim(x)), length(x), nrow(x))
  }))
  datalist <- lapply(seq_along(datalist), function(x) {
    z <- datalist[[x]]
    if (is.null(dim(z))) {
      z <- setNames(data.frame(z), Names[x])
    } else {
      if (is.null(colnames(z))) {
        colnames(z) <- paste(Names[x], sequence(ncol(z)), sep = "_")
      } else {
        colnames(z) <- paste(Names[x], colnames(z), sep = "_")
      }
    }
    padNA(z, rowsneeded = nrows, first = first)
  })
  do.call(cbind, datalist)
}
##########################################################################################
# COMBINATIONS
##########################################################################################
#' @title All pairwise column name combinations
#' @description Generates a data frame of all pairwise combinations of column
#'   names from a data frame. Useful for programmatically specifying variable
#'   pairs to pass to functions like \code{\link{compute_crosstable}} or
#'   \code{\link{plot_crosstable}}.
#' @param df A data frame whose column names will be combined.
#' @param all_orders Logical. When \code{TRUE} (default) both orderings of
#'   each pair are included (e.g. \code{(X1, X2)} and \code{(X2, X1)}),
#'   producing \eqn{n(n-1)} rows for \eqn{n} columns. When \code{FALSE} only
#'   unique unordered pairs are returned, producing \eqn{n(n-1)/2} rows.
#' @return A data frame with two character columns \code{X1} and \code{X2},
#'   each row representing one variable pair.
#' @importFrom utils combn
#' @keywords functions
#' @export
#' @examples
#' comparison_combinations(generate_correlation_matrix(n = 10)[, 1:4])
comparison_combinations <- function(df, all_orders = TRUE) {
  combinations <- data.frame(t(utils::combn(names(df), 2)), stringsAsFactors = FALSE)
  names(combinations) <- c("X1", "X2")
  if (all_orders) {
    combinations <- rbind(combinations, data.frame(X1 = combinations$X2, X2 = combinations$X1))
    combinations <- combinations[order(combinations$X1, combinations$X2), ]
  }
  return(combinations)
}
##########################################################################################
# MINIMUM MAXIMUM INDEX OF A VECTOR
##########################################################################################
#' @title Indices of the minimum and maximum values in a vector
#' @description Returns the positions of the minimum and maximum values in a
#'   vector. When there are ties all tied positions are returned.
#' @param vector A numeric vector.
#' @return A named list with two elements:
#'   \describe{
#'     \item{max_index}{Integer vector of positions where the maximum value
#'       occurs.}
#'     \item{min_index}{Integer vector of positions where the minimum value
#'       occurs.}
#'   }
#' @keywords functions
#' @export
#' @examples
#' vector1 <- c(1, 2, 3, 4, 5, 4, 3, 2, 1)
#' vector2 <- c(1, 2, 3, 4, 5, 5, 3, 2, 1)
#' vector3 <- c(1, 2, 3, 5, 5, 4, 3, 2, 1)
#' vector4 <- c(1, 2, 3, 4, 6, 4, 3, 2, 1)
#' vector5 <- c(1, 6, 3, 4, 6, 4, 3, 2, 1)
#' vector <- vector1
#' which(vector == max(vector), arr.ind = TRUE)
#' which(vector == min(vector), arr.ind = TRUE)
#' min_max_index(vector1)
#' min_max_index(vector2)
#' min_max_index(vector3)
#' min_max_index(vector4)
#' min_max_index(vector5)
min_max_index <- function(vector) {
  max_index <- which(vector == max(vector), arr.ind = TRUE)
  min_index <- which(vector == min(vector), arr.ind = TRUE)
  result <- list(max_index = max_index, min_index = min_index)
  return(result)
}
##########################################################################################
# GET SCRIPT DIRECTORY
##########################################################################################
#' @title Get script directory
#' @description Returns the directory of the currently active script as a string
#'              with a trailing slash. Works across multiple environments: RStudio,
#'              command line execution, and generic R sessions.
#' @details The function tries three approaches in order: \cr
#'          1. If RStudio is available, uses \code{rstudioapi} to get the active document path \cr
#'          2. If running from the command line via \code{Rscript --file=}, parses the file argument \cr
#'          3. Falls back to \code{getwd()} as a last resort
#' @return A character string with the directory path, always ending with "/"
#' @note The fallback to \code{getwd()} may not reflect the script's actual location
#'       if the working directory has been changed during the session.
#' @keywords functions
#' @export
#' @examples
#' # Returns the directory of the active script in RStudio
#' directory <- get_script_directory()
#' directory
get_script_directory <- function() {
  if (requireNamespace("rstudioapi", quietly = TRUE) && rstudioapi::isAvailable()) {
    return(paste0(dirname(rstudioapi::getActiveDocumentContext()$path), "/"))
  }
  # fallback for command line
  args <- commandArgs(trailingOnly = FALSE)
  file_arg <- grep("--file=", args, value = TRUE)
  if (length(file_arg) > 0) {
    return(paste0(dirname(normalizePath(sub("--file=", "", file_arg))), "/"))
  }
  # last resort
  return(paste0(getwd(), "/"))
}
