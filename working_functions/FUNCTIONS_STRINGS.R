##########################################################################################
# MULTIPLE GSUB
##########################################################################################
#' @title Apply gsub for multiple patterns with a single replacement
#'
#' @description Iterates over a vector of patterns, applying
#' \code{\link[base]{gsub}} sequentially with the same replacement string for
#' each.
#'
#' @param mydata Character vector to search within.
#' @param pattern Character vector of patterns to search for.
#' @param replacement Character. The replacement string applied for all patterns.
#' @param ... Additional arguments passed to \code{\link[base]{gsub}},
#'
#' @return A character vector with all pattern matches replaced.
#' @keywords strings
#' @export
#' @examples
#' str_mgsub(mydata = "#$%^&*_+", pattern = c("%", "*"), "REPLACE", fixed = TRUE)
str_mgsub <- function(mydata, pattern, replacement, ...) {
  for (i in 1:length(pattern)) {
    mydata <- gsub(pattern[i], replacement, mydata, ...)
  }
  return(mydata)
}
##########################################################################################
# SPLIT STRING
##########################################################################################
#' @title Split a string vector into a data frame of parts
#'
#' @description Splits each element of a character vector by a separator and
#' returns theparts as columns of a data frame, one row per input element.
#'
#' @param vector Character vector to split.
#' @param split Character. The separator to split on. Default is \code{"/"}.
#' @param include_original Logical. If \code{TRUE}, appends the original input
#'   as a final column. Default is \code{FALSE}.
#'
#' @return A data frame with one row per element of \code{vector} and one column
#'   per split part. Assumes all elements produce the same number of parts.
#' @keywords strings
#' @export
#' @examples
#' string <- paste0(
#'   1:10, "/",
#'   generate_string(nchar = 2, vector_length = 10), "/",
#'   generate_string(nchar = 2, vector_length = 10), "/",
#'   generate_string(nchar = 2, vector_length = 10)
#' )
#' str_split(string, split = "/")
str_split <- function(vector, split = "/", include_original = FALSE) {
  str_split <- strsplit(vector, split = split, fixed = TRUE)
  result <- data.frame(matrix(unlist(str_split), byrow = TRUE, ncol = length(str_split[[1]])), stringsAsFactors = FALSE)
  if (include_original) {
    result <- data.frame(result, vector, stringsAsFactors = FALSE)
  }
  return(result)
}
##########################################################################################
# SPLIT STRING IN DATAFRAME
##########################################################################################
#' @title Split a string column or row names in a data frame into separate columns
#'
#' @description Splits a delimited string — either from row names or a specified
#' column — and prepends the resulting parts as new columns to the data frame.
#'
#' @param df A data frame.
#' @param split Character. The separator to split on. Default is \code{"/"}.
#' @param type Character. Where to read the string from. One of:
#'   \describe{
#'     \item{\code{"row"}}{Splits the row names of \code{df}.}
#'     \item{\code{"collumn"}}{Splits the column specified by \code{index}.}
#'   }
#'   Default is \code{"row"}.
#' @param index Integer. Column index to split when \code{type = "collumn"}.
#' @param ... Additional arguments passed to \code{\link{str_split}}.
#'
#' @return A data frame with the split parts prepended as new columns,
#'   followed by the original columns of \code{df}.
#'
#' @seealso \code{\link{str_split}}
#' @keywords strings
#' @export
#' @examples
#' df <- generate_correlation_matrix()
#' string <- paste0(
#'   1:nrow(df), "/",
#'   generate_string(nchar = 2, vector_length = nrow(df)), "/",
#'   generate_string(nchar = 2, vector_length = nrow(df)), "/",
#'   generate_string(nchar = 2, vector_length = nrow(df))
#' )
#' row.names(df) <- string
#' str_split_df(df, split = "/", type = "row")
#' df[, 1] <- string
#' str_split_df(df, split = "/", type = "collumn", index = 1)
str_split_df <- function(df, split = "/", type = "row", index, ...) {
  if (type == "row") {
    split <- str_split(vector = as.character(row.names(df)), split = split, ...)
    result <- data.frame(split, df, stringsAsFactors = FALSE)
  }
  if (type == "collumn") {
    split <- str_split(vector = as.character(df[, index]), split = split, ...)
    result <- data.frame(split, df, stringsAsFactors = FALSE)
  }
  return(result)
}
##########################################################################################
# RETURN RIGHT LEFT CHARACTERS
##########################################################################################
#' @title Extract n characters from the left or right of a string
#'
#' @param x Character vector.
#' @param n Integer. Number of characters to extract. Default is \code{2}.
#' @param type Character. One of \code{"left"} or \code{"right"}.
#'
#' @return A character vector of the same length as \code{x}.
#' @keywords strings
#' @export
#' @examples
#' str_sub("12345", n = 2, type = "right")
#' str_sub("12345", n = 2, type = "left")
str_sub <- function(x, n = 2, type) {
  if (type == "right") {
    result <- substr(x, nchar(x) - n + 1, nchar(x))
  }
  if (type == "left") {
    result <- substr(x, 1, n)
  }
  return(result)
}
##########################################################################################
# PROPER
##########################################################################################
#' @title Convert a string to proper case
#'
#' @description Capitalises the first character and lowercases the rest of each
#' element.
#'
#' @param x Character vector.
#'
#' @return A character vector of the same length as \code{x}.
#' @keywords strings
#' @export
#' @examples
#' x <- generate_string(nchar = 10, vector = LETTERS, vector_length = 10)
#' str_proper(x)
str_proper <- function(x) paste0(toupper(substr(x, 1, 1)), tolower(substring(x, 2)))
##########################################################################################
# TRIM DATAFRAME
##########################################################################################
#' @title Trim whitespace from all character cells in a data frame
#'
#' @description Applies \code{\link[base]{strwrap}} to every character cell in
#' a data frame, removing leading and trailing whitespace.
#'
#' @param df A data frame containing one or more character columns.
#'
#' @return A data frame of the same dimensions with whitespace trimmed from
#'   all character cells. Non-character cells are unchanged.
#' @keywords strings
#' @export
#' @examples
#' string <- data.frame(
#'   str1 = rep(paste0(sample(c(LETTERS, rep(" ", 10))), collapse = ""), 10),
#'   str2 = rep(paste0(sample(c(LETTERS, rep(" ", 10))), collapse = ""), 10),
#'   num1 = rnorm(10),
#'   stringsAsFactors = FALSE
#' )
#' str_trim_df(string)
str_trim_df <- function(df) {
  df[] <- apply(df, 1:2, function(x) {
    if (mode(x) == "character") {
      x <- strwrap(x)
    }
  })
  return(df)
}
##########################################################################################
# ADJUST STRING AESTHETICS
##########################################################################################
#' @title Clean and format string aesthetics
#'
#' @description Replaces a list of separator characters 
#' (e.g. \code{"."}, \code{"_"}, HTML tags) with spaces, trims leading and
#' trailing whitespace, collapses internal whitespace, and optionally applies
#' proper case.
#'
#' @param vector Character vector to clean.
#' @param characterlist Character vector of strings to treat as separators,
#'   each replaced by a single space. Defaults to common punctuation and
#'   HTML tags including \code{"."}, \code{"_"}, \code{"-"}, \code{"<p>"},
#'   \code{"<br>"}, \code{"&nbsp"}, and others.
#' @param proper Logical. If \code{TRUE}, capitalises the first letter and
#'   lowercases the rest of each string. Default is \code{TRUE}.
#'
#' @return A character vector of the same length as \code{vector} with
#'   separators replaced, whitespace normalised, and optional proper casing.
#'
#' @keywords strings
#' @export
#' @examples
#' vector <- c("TES.T", "TES<p>T", "TES&nbspT")
#' str_aes(vector = vector)
#' str_aes(vector = vector, proper = FALSE)
#' str_aes(vector = vector, proper = TRUE)
str_aes <- function(vector, characterlist = c(".", "_", "-", ",", "$", "<p>", "</p>", "<br>", "<br/>", "<B>", "</B>", "<BR/>", "|", "/", "&nbsp"), proper = TRUE) {
  for (i in characterlist) {
    vector <- gsub(i, " ", vector, fixed = TRUE)
  }
  result <- trimws(vector, which = "both")
  if (proper) {
    result <- str_proper(vector)
  }
  result <- str_squish(result)
  return(result)
}
##########################################################################################
# MODEL CALL TO STRING
##########################################################################################
#' @title Convert a model call to a compact string
#'
#' @description Extracts the call from a model object and returns it as a single
#' whitespace-free string. Tries \code{model$call} first, falling back
#' to \code{model$Call} if the first is \code{NULL}.
#'
#' @param model A model object with a \code{call} or \code{Call} element
#'   (e.g. from \code{lm}, \code{glm}, \code{coxph}).
#'
#' @return A character scalar with the model call, whitespace removed.
#' @keywords strings
#' @export
#' @examples
#' df <- generate_correlation_matrix()
#' model <- lm(df$X1 ~ df$X2)
#' call_to_string(model)
call_to_string <- function(model) {
  result <- toString(deparse(model$call))
  if (result == "NULL") {
    result <- toString(deparse(model$Call))
  }
  result <- gsub(" ", "", result, fixed = TRUE)
  return(result)
}
##########################################################################################
# OUTPUT SEPARATOR
##########################################################################################
#' @title Print a formatted console output block with separators
#'
#' @description Prints a heading, optional instructions, and optional output to
#' the console, surrounded by \code{#} separator lines for visual clarity.
#'
#' @param string Character. The title displayed between the main separators.
#' @param output Object or \code{NULL}. The main content to print below the
#'   heading. If \code{NULL}, nothing is printed in its place. Default is
#'   \code{NULL}.
#' @param instruction Character or \code{NULL}. Explanatory text printed between
#'   the heading and the output, followed by a shorter separator. Default is
#'   \code{NULL}.
#' @param length Numeric. Width of the main separator in characters. Default is
#'   half the current console width (\code{getOption("width") / 2}).
#'
#' @return Called for its side effects. Returns \code{NULL} invisibly.
#' @keywords strings
#' @export
#' @examples
#' output_separator(string = "TEST", output = "TEST", instruction = "TEST", length = 100)
#' output_separator(string = "TEST", instruction = "TEST", length = 100)
#' output_separator(string = "TEST", output = "TEST", length = 100)
#' output_separator(string = "TEST")
output_separator <- function(string, output = NULL, instruction = NULL, length = getOption("width") / 2) {
  separator_title <- paste0(rep("#", length), sep = "", collapse = "")
  separator_subtitle <- paste0(rep("#", length / 2), sep = "", collapse = "")
  print(separator_title)
  print(string)
  print(separator_title)
  if (!is.null(instruction)) {
    print(instruction)
    print(separator_subtitle)
  }
  if (!is.null(output)) {
    print(output)
  }
}
##########################################################################################
# BASE R REPLACEMENTS FOR stringr FUNCTIONS
##########################################################################################
##########################################################################################
#
##########################################################################################
#' @title Mark a pattern as a fixed string
#' @description Flags a pattern to be interpreted as a literal string rather
#'   than a regular expression. Pass the result to \code{str_replace},
#'   \code{str_replace_all}, \code{str_count}, or \code{str_split_fixed}
#'   wherever you want exact character matching instead of regex matching.
#' @param pattern A character string to match literally.
#' @return The same character string with class \code{"fixed_pattern"}.
#' @keywords strings
#' @export
#' @examples
#' # Without fixed(), "." matches any character (regex)
#' str_replace_all("a.b.c", ".", "-")
#'
#' # With fixed(), "." matches only a literal dot
#' str_replace_all("a.b.c", fixed("."), "-")
fixed <- function(pattern) {
  structure(pattern, class = "fixed_pattern")
}
##########################################################################################
#
##########################################################################################
#' @title Replace all pattern matches in a string
#' @description Replaces every occurrence of \code{pattern} in \code{string}
#'   with \code{replacement}. Supports both regular expressions and literal
#'   string matching via \code{fixed()}.
#' @param string A character vector.
#' @param pattern A regular expression string, or a literal string wrapped in
#'   \code{fixed()}, or a named character vector where names are regex patterns
#'   and values are replacements (applied sequentially).
#' @param replacement A character string to replace each match with. Use
#'   \code{""} to delete matches.
#' @return A character vector the same length as \code{string}.
#' @keywords strings
#' @export
#' @examples
#' # Regex replacement
#' str_replace_all("hello world", "o", "0")
#'
#' # Fixed (literal) replacement
#' str_replace_all("a.b.c", fixed("."), "-")
#'
#' # Remove all spaces
#' str_replace_all("remove all spaces", fixed(" "), "")
#'
#' # Named vector: multiple replacements applied in order
#' str_replace_all("aabbcc", c("a" = "X", "b" = "Y"))
str_replace_all <- function(string, pattern, replacement) {
  if (inherits(pattern, "fixed_pattern")) {
    gsub(as.character(pattern), replacement, string, fixed = TRUE)
  } else if (is.character(pattern) && length(pattern) > 1 && !is.null(names(pattern))) {
    for (i in seq_along(pattern)) {
      string <- gsub(names(pattern)[i], pattern[i], string, perl = TRUE)
    }
    string
  } else {
    gsub(pattern, replacement, string, perl = TRUE)
  }
}
##########################################################################################
#
##########################################################################################
#' @title Replace the first pattern match in a string
#' @description Replaces only the first occurrence of \code{pattern} in each
#'   element of \code{string}. For replacing all occurrences use
#'   \code{str_replace_all}.
#' @param string A character vector.
#' @param pattern A regular expression string or a literal string wrapped in
#'   \code{fixed()}.
#' @param replacement A character string to replace the first match with.
#' @return A character vector the same length as \code{string}.
#' @keywords strings
#' @export
#' @examples
#' # Only the first "o" is replaced
#' str_replace("hello world", "o", "0")
#'
#' # Remove leading zero (first match only)
#' str_replace("007 bond", "^0+", "")
#'
#' # Fixed match: replace first literal dot
#' str_replace("a.b.c", fixed("."), "-")
str_replace <- function(string, pattern, replacement) {
  if (inherits(pattern, "fixed_pattern")) {
    sub(as.character(pattern), replacement, string, fixed = TRUE)
  } else {
    sub(pattern, replacement, string, perl = TRUE)
  }
}
##########################################################################################
#
##########################################################################################
#' @title Wrap long strings to a specified line width
#' @description Breaks a character string into multiple lines so that no line
#'   exceeds \code{width} characters. Words are kept intact; lines are joined
#'   with \code{"\n"}.
#' @param string A character vector.
#' @param width Maximum number of characters per line. Default \code{80}.
#' @return A character vector the same length as \code{string}, with embedded
#'   newlines inserted at word boundaries.
#' @keywords strings
#' @export
#' @examples
#' # Wrap at 30 characters
#' cat(str_wrap("The quick brown fox jumped over the lazy dog", width = 30))
#'
#' # Wrap a vector of strings
#' labels <- c("Short label", "A much longer label that needs wrapping")
#' str_wrap(labels, width = 20)
str_wrap <- function(string, width = 80) {
  vapply(string, function(x) paste(strwrap(x, width = width), collapse = "\n"),
    character(1),
    USE.NAMES = FALSE
  )
}
##########################################################################################
#
##########################################################################################
#' @title Split strings into a fixed-width matrix of pieces
#' @description Splits each element of \code{string} by \code{pattern} and
#'   returns a character matrix with exactly \code{n} columns. If a string
#'   produces fewer than \code{n} pieces the remaining columns are filled with
#'   \code{""}.
#' @param string A character vector.
#' @param pattern A regular expression string or a literal string wrapped in
#'   \code{fixed()}.
#' @param n Integer. Number of columns in the output matrix.
#' @return A character matrix with \code{length(string)} rows and \code{n}
#'   columns.
#' @keywords strings
#' @export
#' @examples
#' # Split "trait.method" labels into two columns
#' str_split_fixed(c("speed.run", "height.jump", "weight.lift"), fixed("."), 2)
#'
#' # Split on a regex pattern
#' str_split_fixed(c("a1b", "c2d", "e3f"), "[0-9]", 2)
#'
#' # Fewer pieces than n: remainder filled with ""
#' str_split_fixed(c("a.b.c", "x.y"), fixed("."), 3)
str_split_fixed <- function(string, pattern, n) {
  if (inherits(pattern, "fixed_pattern")) {
    parts <- strsplit(string, as.character(pattern), fixed = TRUE)
  } else {
    parts <- strsplit(string, pattern, perl = TRUE)
  }
  t(vapply(parts, function(x) {
    length(x) <- n
    x[is.na(x)] <- ""
    x
  }, character(n)))
}
##########################################################################################
#
##########################################################################################
#' @title Count the number of pattern matches in a string
#' @description Returns the number of times \code{pattern} appears in each
#'   element of \code{string}. Supports both regular expressions and literal
#'   string matching via \code{fixed()}.
#' @param string A character vector.
#' @param pattern A regular expression string or a literal string wrapped in
#'   \code{fixed()}.
#' @return An integer vector the same length as \code{string}.
#' @keywords strings
#' @export
#' @examples
#' # Count vowels
#' str_count(c("banana", "apple", "cherry"), "[aeiou]")
#'
#' # Count literal semicolons (useful for delimited data)
#' str_count(c("a;b;c", "x;y", "z"), fixed(";"))
#'
#' # Count digits
#' str_count(c("abc123", "99bottles", "none"), "[0-9]")
str_count <- function(string, pattern) {
  if (inherits(pattern, "fixed_pattern")) {
    m <- gregexpr(as.character(pattern), string, fixed = TRUE)
  } else {
    m <- gregexpr(pattern, string, perl = TRUE)
  }
  vapply(m, function(x) if (x[1] == -1L) 0L else length(x), integer(1))
}
##########################################################################################
#
##########################################################################################
#' @title Pad a string to a minimum width
#' @description Pads \code{string} with \code{pad} characters on the left,
#'   right, or both sides until it reaches at least \code{width} characters.
#'   Strings already at or exceeding \code{width} are returned unchanged.
#' @param string A character vector.
#' @param width Integer. Minimum total width of the output string.
#' @param side One of \code{"right"} (default), \code{"left"}, or \code{"both"}.
#' @param pad A single character to use for padding. Default \code{" "}.
#' @return A character vector the same length as \code{string}.
#' @keywords strings
#' @export
#' @examples
#' # Zero-pad single digit numbers on the left
#' str_pad(c("1", "10", "100"), width = 3, side = "left", pad = "0")
#'
#' # Right-pad to align labels
#' str_pad(c("Name", "Age", "Score"), width = 10)
#'
#' # Pad on both sides (centers the string)
#' str_pad("hello", width = 11, side = "both")
str_pad <- function(string, width, side = "right", pad = " ") {
  string <- as.character(string)
  vapply(string, function(s) {
    n <- width - nchar(s)
    if (n <= 0) {
      return(s)
    }
    padding <- paste(rep(pad, n), collapse = "")
    switch(side,
      right = paste0(s, padding),
      left = paste0(padding, s),
      both = {
        lpad <- paste(rep(pad, floor(n / 2)), collapse = "")
        rpad <- paste(rep(pad, ceiling(n / 2)), collapse = "")
        paste0(lpad, s, rpad)
      }
    )
  }, character(1), USE.NAMES = FALSE)
}
##########################################################################################
#
##########################################################################################
#' @title Remove leading, trailing, and internal extra whitespace
#' @description Strips leading and trailing whitespace and collapses any
#'   internal sequences of whitespace (spaces, tabs, newlines) down to a
#'   single space.
#' @param string A character vector.
#' @return A character vector the same length as \code{string}.
#' @keywords strings
#' @export
#' @examples
#' # Remove extra internal spaces
#' str_squish("  hello   world  ")
#'
#' # Clean up messy column names or labels
#' str_squish(c("  first  name ", "last  name", "  age"))
#'
#' # Handles tabs and newlines too
#' str_squish("line1\n\nline2\t\tword")
str_squish <- function(string) {
  trimws(gsub("\\s+", " ", string))
}
