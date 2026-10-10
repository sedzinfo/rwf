##########################################################################################
# CHECK DATAFRAME
##########################################################################################
#' @title Check dataframe
#' @description Produces a column-level diagnostic summary of a dataframe, reporting missing
#' values, data types, range statistics, and optionally unique values and factor
#' levels. Returns a named list with a per-column table and a whole-dataframe
#' summary. Can optionally export results to an \code{.xlsx} file.
#'
#' @param df A \code{data.frame} to inspect. Accepts any column types: numeric,
#'   integer, character, factor, logical, \code{Date}, \code{POSIXct}.
#' @param name_length Integer. Maximum number of characters displayed for column
#'   names and MIN/MAX values in the printed output. Longer strings are
#'   truncated. Defaults to \code{getOption("width") / 3}.
#' @param digits Integer. Number of decimal places used when rounding MEAN,
#'   MEDIAN, and SD for numeric columns. Defaults to \code{2}.
#' @param nuniques Integer. If \code{> 0}, appends UNIQUES and LEVELS columns
#'   to the output. Columns with more distinct entries than \code{nuniques} are
#'   summarised as \code{"N Uniques"} / \code{"N Levels"}. Set to \code{0} to
#'   skip (faster). Defaults to \code{0}.
#' @param parralel Logical. If \code{TRUE}, uses \code{future.apply} with a
#'   \code{multisession} plan across all available cores. Recommended for wide
#'   dataframes (> 100 columns) or very large \code{n}. Defaults to
#'   \code{FALSE}.
#' @param file Character or \code{NULL}. If a string is provided, exports
#'   results to \code{<file>.xlsx} with two sheets: \code{variables} and
#'   \code{summary}. Any existing file with the same name is overwritten.
#'   Defaults to \code{NULL}.
#'
#' @return A named \code{list} with two elements:
#' \describe{
#'   \item{\code{$summary}}{A single-row \code{data.frame} with whole-dataframe
#'     counts: COLLUMNS, ROWS, TOTAL, EMPTY, null, NAN, na, INF, FIN, FACTOR.}
#'   \item{\code{$check}}{A per-column \code{data.frame} with the following
#'     fields:
#'     \describe{
#'       \item{NAMES}{Column name (truncated to \code{name_length}).}
#'       \item{EMPTY}{Count of \code{""} empty strings.}
#'       \item{null}{Count of \code{NULL} values (always 0 for dataframe columns).}
#'       \item{na}{Count of \code{NA} values.}
#'       \item{NOT_NA}{Count of non-\code{NA} values.}
#'       \item{NAN}{Count of \code{NaN} values.}
#'       \item{INF}{Count of \code{Inf} and \code{-Inf} values.}
#'       \item{FIN}{Count of finite values.}
#'       \item{RANGE}{Number of distinct values.}
#'       \item{MEAN}{Arithmetic mean, rounded to \code{digits}. \code{NA} for non-numeric columns.}
#'       \item{MEDIAN}{Median, rounded to \code{digits}. \code{NA} for non-numeric columns.}
#'       \item{SD}{Standard deviation, rounded to \code{digits}. \code{NA} for non-numeric columns.}
#'       \item{MIN}{Minimum value or first label in sorted order.}
#'       \item{MAX}{Maximum value or last label in sorted order.}
#'       \item{MODE}{Storage mode as returned by \code{mode()}.}
#'       \item{TYPE}{Type as returned by \code{typeof()}.}
#'       \item{CLASS}{Class as returned by \code{class()}.}
#'       \item{FACTOR}{Logical; \code{TRUE} if the column is a factor.}
#'     }
#'   }
#' }
#'
#' @note MEAN, MEDIAN, and SD are \code{NA} for non-numeric columns. MIN and
#'   MAX for non-double columns are derived from \code{sort()} on character
#'   representations — natural sort ordering is not guaranteed for mixed
#'   alphanumeric strings.
#'
#' @import future.apply
#' @importFrom future availableCores plan multisession sequential
#' @importFrom openxlsx createWorkbook saveWorkbook
#' @importFrom stats median sd
#'
#' @keywords dataframe diagnostics summary missing-values
#' @export
#'
#' @examples
#' cdf(df = mtcars, parralel = TRUE)
#' cdf(df = change_data_type(mtcars, "factor"), nuniques = 3)
#' cdf(df = data.frame(t(mtcars)), file = "mtcars", nuniques = 10)
#' cdf(df = mtcars)
#' cdf(df = generate_missing(mtcars))
#' cdf(df = infert, nuniques = 10)
#' cdf(df = infert)
#' df <- data.frame(infert,
#'   date = seq(as.Date("2010-1-1"),
#'     as.Date("2020-1-1"),
#'     length.out = nrow(infert)
#'   )
#' )
#' cdf(df = df)
cdf <- function(df, name_length = (getOption("width") / 3), digits = 2, nuniques = 0, parralel = FALSE, file = NULL) {
  if (parralel) {
    future::plan(future::multisession, gc = TRUE, .cleanup = TRUE, workers = future::availableCores("mc.cores"))
  } else {
    future::plan(future::sequential)
  }
  check_df <- future.apply::future_sapply(df, function(y) {
    return(list(
      EMPTY = length(which(as.character(y) == "")),
      null = length(which(is.null(y))),
      na = length(which(is.na(y))),
      NOT_NA = length(which(!is.na(y))),
      NAN = length(which(is.nan(unlist(y)))),
      INF = length(which(is.infinite(unlist(y)))),
      FIN = length(which(is.finite(unlist(y)))),
      RANGE = length(unique(y)),
      MEAN = if (is.numeric(y)) round(mean(y, na.rm = TRUE), 2) else NA,
      MEDIAN = if (is.numeric(y)) round(stats::median(y, na.rm = TRUE), 2) else NA,
      SD = if (is.numeric(y)) round(stats::sd(y, na.rm = TRUE), 2) else NA,
      MIN = if (is.double(y)) min(y, na.rm = TRUE) else gtools::mixedsort(as.character(na.omit(unique(y))))[1],
      MAX = if (is.double(y)) max(y, na.rm = TRUE) else gtools::mixedsort(as.character(na.omit(unique(y))))[length(na.omit(unique(y)))],
      MODE = mode(y),
      TYPE = typeof(y),
      CLASS = class(y),
      FACTOR = is.factor(y)
    ))
  })
  check_df <- data.frame(NAMES = names(df), t(check_df), stringsAsFactors = FALSE, check.names = FALSE)
  summary_dataframe <- data.frame(
    COLLUMNS = length(df),
    ROWS = nrow(df),
    TOTAL = length(df) * nrow(df),
    EMPTY = sum(as.numeric(check_df$EMPTY), na.rm = TRUE),
    null = sum(as.numeric(check_df$null), na.rm = TRUE),
    NAN = sum(as.numeric(check_df$NAN), na.rm = TRUE),
    na = sum(as.numeric(check_df$na), na.rm = TRUE),
    INF = sum(as.numeric(check_df$INF), na.rm = TRUE),
    FIN = sum(as.numeric(check_df$FIN), na.rm = TRUE),
    FACTOR = sum(future.apply::future_sapply(df, function(y) length(which(is.factor(y))))),
    row.names = NULL,
    check.names = FALSE,
    stringsAsFactors = FALSE
  )
  if (nuniques > 0) {
    uniques <- future.apply::future_apply(df, 2, unique)
    level <- future.apply::future_sapply(df, function(y) levels(y))
    uniques_df <- levels_df <- data.frame()
    for (i in 1:length(uniques)) {
      if (length(uniques[[i]]) > nuniques) {
        uniques[[i]] <- paste(length(uniques[[i]]), "Uniques")
      }
      if (length(level[[i]]) > nuniques) {
        level[[i]] <- paste(length(level[[i]]), "Levels")
      }
      uniques_df <- plyr::rbind.fill(uniques_df, data.frame(UNIQUES = toString(t(sort(uniques[[i]]))), check.names = FALSE))
      levels_df <- plyr::rbind.fill(levels_df, data.frame(LEVELS = toString(level[[i]]), check.names = FALSE))
    }
    if (all(levels_df$LEVELS == "")) {
      check_df <- data.frame(check_df, uniques_df, check.names = FALSE)
    } else {
      check_df <- data.frame(check_df, uniques_df, levels_df, check.names = FALSE)
    }
  }
  if (!is.null(file)) {
    filename <- paste0(file, ".xlsx")
    if (file.exists(filename)) file.remove(filename)
    wb <- openxlsx::createWorkbook()
    excel_critical_value(df = check_df, workbook = wb, sheet = "variables", numFmt = "#0.00")
    excel_critical_value(summary_dataframe, workbook = wb, sheet = "summary", numFmt = "#0.00")
    openxlsx::saveWorkbook(wb = wb, file = filename, overwrite = TRUE)
  }
  check_df$NAMES <- substr(check_df$NAMES, 1, name_length)
  check_df$MIN <- substr(check_df$MIN, 1, name_length)
  check_df$MAX <- substr(check_df$MAX, 1, name_length)

  row.names(check_df) <- NULL
  result <- list(summary = summary_dataframe, check = check_df)
  return(result)
}
##########################################################################################
# CHECK DATAFRAME (OPTIMISED)
##########################################################################################
#' Check dataframe (optimised)
#'
#' A faster equivalent of \code{\link{cdf}}. Produces an identical column-level
#' diagnostic summary but avoids repeated passes over each column, eliminates
#' row-by-row \code{rbind} calls, and removes the \code{gtools} and \code{plyr}
#' dependencies. Recommended for large dataframes (> 100k rows or > 50 columns).
#'
#' @inheritParams cdf
#'
#' @return Identical structure to \code{\link{cdf}}: a named \code{list} with
#'   elements \code{$summary} and \code{$check}. See \code{\link{cdf}} for full
#'   field descriptions.
#'
#' @note MIN and MAX for non-double columns use base \code{min()} / \code{max()}
#'   on character representations. Unlike \code{\link{cdf}}, mixed alphanumeric
#'   ordering (e.g. \code{"V1"} < \code{"V10"} < \code{"V2"}) is \emph{not}
#'   guaranteed — lexicographic order is used instead.
#'
#' @import future.apply
#' @importFrom future availableCores plan multisession sequential
#' @importFrom openxlsx createWorkbook saveWorkbook
#' @importFrom stats median sd
#'
#' @keywords dataframe diagnostics summary missing-values
#' @export
#'
#' @examples
#' cdff(df = mtcars, parralel = TRUE)
#' cdff(df = change_data_type(mtcars, "factor"), nuniques = 3)
#' cdff(df = data.frame(t(mtcars)), file = "mtcars", nuniques = 10)
#' cdff(df = mtcars)
#' cdff(df = generate_missing(mtcars))
#' cdff(df = infert, nuniques = 10)
#' cdff(df = infert)
#' df <- data.frame(infert,
#'   date = seq(as.Date("2010-1-1"),
#'     as.Date("2020-1-1"),
#'     length.out = nrow(infert)
#'   )
#' )
#' cdff(df = df)
cdff <- function(df, name_length = (getOption("width") / 3), digits = 2, nuniques = 0, parralel = FALSE, file = NULL) {
  # plain lapply unless parallel is requested; restore the caller's future plan afterwards
  if (parralel) {
    old_plan <- future::plan(future::multisession, gc = TRUE, .cleanup = TRUE, workers = future::availableCores("mc.cores"))
    on.exit(future::plan(old_plan), add = TRUE)
    apply_fun <- future.apply::future_lapply
  } else {
    apply_fun <- lapply
  }

  check_df <- apply_fun(df, function(y) {
    # --- cache expensive operations ---
    y_na <- is.na(y)
    y_notna <- !y_na
    y_unlisted <- unlist(y) # once only
    u <- unique(y) # once only

    is_num <- is.numeric(y)
    is_dbl <- is.double(y)
    is_fin <- is.finite(y_unlisted)

    # MIN / MAX: avoid mixedsort — just use base sort or min/max
    u_clean <- na.omit(u)
    if (is_dbl) {
      col_min <- min(y, na.rm = TRUE)
      col_max <- max(y, na.rm = TRUE)
    } else {
      u_char <- as.character(u_clean)
      col_min <- if (length(u_char)) min(u_char) else NA
      col_max <- if (length(u_char)) max(u_char) else NA
    }

    list(
      # only text can be empty; converting numbers to text just to count "" was the slow part
      EMPTY   = if (is.character(y) || is.factor(y)) sum(y == "", na.rm = TRUE) else 0L,
      null    = sum(is.null(y)), # always 0 for df columns; kept for parity
      na      = sum(y_na),
      NOT_NA  = sum(y_notna),
      NAN     = sum(is.nan(y_unlisted)),
      INF     = sum(is_fin == FALSE & !y_na),
      FIN     = sum(is_fin),
      RANGE   = length(u),
      MEAN    = if (is_num) round(mean(y, na.rm = TRUE), digits) else NA,
      MEDIAN  = if (is_num) round(stats::median(y, na.rm = TRUE), digits) else NA,
      SD      = if (is_num) round(stats::sd(y, na.rm = TRUE), digits) else NA,
      MIN     = col_min,
      MAX     = col_max,
      MODE    = mode(y),
      TYPE    = typeof(y),
      CLASS   = class(y)[1],
      FACTOR  = is.factor(y)
    )
  })

  # Build check_df in one shot — NO loop, NO rbind.fill
  check_df <- data.frame(
    NAMES = names(df),
    do.call(rbind, lapply(check_df, function(x) as.data.frame(x, stringsAsFactors = FALSE))),
    stringsAsFactors = FALSE,
    check.names = FALSE
  )

  # Summary — reuse check_df instead of re-scanning df
  summary_dataframe <- data.frame(
    COLLUMNS = length(df),
    ROWS = nrow(df),
    TOTAL = length(df) * nrow(df),
    EMPTY = sum(as.numeric(check_df$EMPTY), na.rm = TRUE),
    null = sum(as.numeric(check_df$null), na.rm = TRUE),
    NAN = sum(as.numeric(check_df$NAN), na.rm = TRUE),
    na = sum(as.numeric(check_df$na), na.rm = TRUE),
    INF = sum(as.numeric(check_df$INF), na.rm = TRUE),
    FIN = sum(as.numeric(check_df$FIN), na.rm = TRUE),
    FACTOR = sum(as.logical(check_df$FACTOR), na.rm = TRUE), # ← reused
    row.names = NULL,
    check.names = FALSE,
    stringsAsFactors = FALSE
  )

  # Uniques / Levels — single pass, pre-allocated with lapply
  if (nuniques > 0) {
    uniques_list <- apply_fun(df, function(y) {
      u <- unique(y)
      lv <- levels(y)

      u_str <- if (length(u) > nuniques) paste(length(u), "Uniques") else toString(sort(as.character(u)))
      lv_str <- if (length(lv) > nuniques) paste(length(lv), "Levels") else toString(lv)

      list(UNIQUES = u_str, LEVELS = lv_str)
    })

    uniques_df <- data.frame(
      UNIQUES = vapply(uniques_list, `[[`, character(1), "UNIQUES"),
      stringsAsFactors = FALSE
    )
    levels_df <- data.frame(
      LEVELS = vapply(uniques_list, `[[`, character(1), "LEVELS"),
      stringsAsFactors = FALSE
    )

    if (all(levels_df$LEVELS == "")) {
      check_df <- cbind(check_df, uniques_df)
    } else {
      check_df <- cbind(check_df, uniques_df, levels_df)
    }
  }

  if (!is.null(file)) {
    filename <- paste0(file, ".xlsx")
    if (file.exists(filename)) file.remove(filename)
    wb <- openxlsx::createWorkbook()
    excel_critical_value(df = check_df, workbook = wb, sheet = "variables", numFmt = "#0.00")
    excel_critical_value(summary_dataframe, workbook = wb, sheet = "summary", numFmt = "#0.00")
    openxlsx::saveWorkbook(wb = wb, file = filename, overwrite = TRUE)
  }

  check_df$NAMES <- substr(check_df$NAMES, 1, name_length)
  check_df$MIN <- substr(check_df$MIN, 1, name_length)
  check_df$MAX <- substr(check_df$MAX, 1, name_length)

  row.names(check_df) <- NULL
  list(summary = summary_dataframe, check = check_df)
}
