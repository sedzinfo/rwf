##########################################################################################
# DATAFRAME TO EXCEL GENERIC
##########################################################################################
#' Format an Excel worksheet with styles, comments, and frozen panes
#'
#' Applies consistent formatting to an existing worksheet in an openxlsx workbook.
#' Handles header styling, cell borders, number formatting, column auto-widths,
#' frozen panes, and optional comments on column headers.
#'
#' @param df A data frame or matrix whose structure determines column formatting.
#'   Integer columns receive whole-number formatting; non-integer numeric columns
#'   receive the format specified by \code{numFmt}.
#' @param workbook An openxlsx workbook object created with \code{openxlsx::createWorkbook()}.
#' @param sheet Character. Name of the worksheet to format. Must already exist in
#'   \code{workbook}. Default is \code{"output"}.
#' @param title Character or \code{NULL}. If provided, written as a hidden comment
#'   on cell A1. Default is \code{NULL}.
#' @param comment A named list or \code{NULL}. Each name should match a column name
#'   in \code{df}; the value is the comment text added to that column's header cell.
#'   Names not found in \code{df} are silently ignored. Default is \code{NULL}.
#' @param numFmt Character. Excel number format string applied to non-integer numeric
#'   columns. Default is \code{"#0.00"}.
#'
#' @return Called for its side effects. Modifies \code{workbook} in place; returns
#'   \code{NULL} invisibly.
#'
#' @details
#' The function assumes that data has already been written to the worksheet via
#' \code{openxlsx::writeData()} with both \code{colNames = TRUE} and
#' \code{rowNames = TRUE}, as it offsets column indices by 1 to account for the
#' row name column.
#'
#' Formatting applied:
#' \itemize{
#'   \item Thin gray borders on all data cells
#'   \item Thin black borders on the header row and row name column
#'   \item Column widths set to auto
#'   \item First row and first column frozen
#'   \item Base font set to Liberation Sans 10pt
#' }
#'
#' @importFrom openxlsx createComment writeComment freezePane modifyBaseFont createStyle addStyle removeColWidths setColWidths
#'
#' @export
#' @examples
#' comment <- list(
#'   mpg = "Miles/(US) gallon",
#'   cyl = "Number of cylinders",
#'   disp = "Displacement (cu.in.)",
#'   hp = "Gross horsepower",
#'   drat = "Rear axle ratio",
#'   wt = "Weight (1000 lbs)",
#'   qsec = "1/4 mile time",
#'   vs = "Engine (0=V-shaped,1=straight)",
#'   am = "Transmission (0=automatic,1=manual)",
#'   gear = "Number of forward gears",
#'   carb = "Number of carburetors",
#'   extra_comment1 = "test1",
#'   extra_comment2 = "test2"
#' )
#' mtcor <- data.frame(cor(mtcars))
#' filename <- "excel_generic.xlsx"
#' if (file.exists(filename)) file.remove(filename)
#' wb <- openxlsx::createWorkbook()
#' openxlsx::addWorksheet(wb, "sheet")
#' openxlsx::addWorksheet(wb, "correlation")
#' openxlsx::writeData(wb, sheet = "sheet", x = mtcars, colNames = TRUE, rowNames = TRUE)
#' openxlsx::writeData(wb, sheet = "correlation", x = mtcor, colNames = TRUE, rowNames = TRUE)
#' excel_generic_format(
#'   df = mtcars, workbook = wb, sheet = "sheet", title = "test",
#'   comment = comment, numFmt = "#0.00"
#' )
#' excel_generic_format(
#'   df = mtcor, workbook = wb, sheet = "correlation", title = "correlation",
#'   comment = comment, numFmt = "#0.00"
#' )
#' openxlsx::saveWorkbook(wb, invisible(paste(filename)), TRUE)
excel_generic_format <- function(df, workbook, sheet = "output", title = NULL, comment = NULL, numFmt = "#0.00") {
  comment <- comment[intersect(names(comment), names(df))]
  if (!is.null(title)) {
    comment_text <- createComment(comment = title, author = Sys.getenv("USER"), style = NULL, visible = FALSE)
    writeComment(workbook, sheet = sheet, col = 1, row = 1, comment = comment_text)
  }
  if (!is.null(comment)) {
    for (i in names(comment)) {
      comment_text <- createComment(comment = comment[[i]], author = Sys.getenv("USER"), style = NULL, visible = FALSE, width = 100)
      writeComment(workbook, sheet = sheet, col = which(i == names(df)) + 1, row = 1, comment = comment_text)
    }
  }
  integer_names <- names(which(sapply(df, function(y) all(if (is.numeric(y)) y == round(y))) == TRUE))
  non_integer_names <- names(which(sapply(df, function(y) !all(if (is.numeric(y)) y == round(y))) == TRUE))
  freezePane(workbook, sheet, firstActiveRow = 1, firstActiveCol = 1, firstRow = TRUE, firstCol = TRUE)
  modifyBaseFont(workbook, fontSize = 10, fontColour = "#000000", fontName = "Liberation Sans")
  content_style <- createStyle(border = "TopBottomLeftRight", borderColour = "gray", borderStyle = "thin", valign = "bottom", wrapText = FALSE, numFmt = numFmt)
  content_style_integer <- createStyle(border = "TopBottomLeftRight", borderColour = "gray", borderStyle = "thin", valign = "bottom", wrapText = FALSE, numFmt = "#0")
  header_style <- createStyle(border = "TopBottomLeftRight", borderColour = "black", borderStyle = "thin", valign = "bottom", wrapText = FALSE, bgFill = NULL, numFmt = numFmt)
  for (i in non_integer_names) {
    addStyle(workbook, sheet = sheet, style = content_style, rows = 2:(nrow(df) + 1), cols = which(names(df) == i) + 1, gridExpand = TRUE, stack = TRUE)
  }
  for (i in integer_names) {
    addStyle(workbook, sheet = sheet, style = content_style_integer, rows = 2:(nrow(df) + 1), cols = which(names(df) == i) + 1, gridExpand = TRUE, stack = TRUE)
  }
  addStyle(workbook, sheet = sheet, style = header_style, rows = 1:(nrow(df) + 1), cols = 1, gridExpand = TRUE, stack = TRUE)
  addStyle(workbook, sheet = sheet, style = header_style, rows = 1, cols = 1:(length(df) + 1), gridExpand = TRUE, stack = TRUE)
  removeColWidths(workbook, sheet, cols = 1:(length(df) + 1))
  setColWidths(workbook, sheet = sheet, cols = 1:(length(df) + 1), widths = "auto")
}
##########################################################################################
# DATAFRAME TO EXCEL MATRIX
##########################################################################################
#' Write a matrix or data frame to an Excel worksheet with optional conditional formatting
#'
#' Creates a new worksheet in an openxlsx workbook, writes the data, and applies
#' formatting via \code{\link{excel_generic_format}}. Optionally adds a red-yellow-green
#' colour scale for value ranges and highlights the diagonal cells in red, which is
#' useful for correlation matrices.
#'
#' @inheritParams excel_generic_format
#' @param conditional_formatting Logical. If \code{TRUE}, applies a red-yellow-green
#'   colour scale to all data cells, where low values are red, mid values yellow,
#'   and high values green. Default is \code{FALSE}.
#' @param diagonal Logical. If \code{TRUE}, fills diagonal cells with a red background.
#'   Only applied when the data frame is square (\code{nrow == ncol}).
#'   Default is \code{FALSE}.
#' @param diagonal_length Integer. Number of diagonal cells to highlight when
#'   \code{diagonal = TRUE}. Defaults to \code{nrow(df)}.
#'
#' @return Called for its side effects. Adds a formatted worksheet to \code{workbook};
#'   returns \code{NULL} invisibly.
#'
#' @details
#' Unlike \code{\link{excel_generic_format}}, this function creates the worksheet
#' and writes the data internally — do not call \code{addWorksheet()} or
#' \code{writeData()} beforehand.
#'
#' The diagonal highlight is skipped silently for non-square data frames.
#'
#' @seealso \code{\link{excel_generic_format}}
#'
#' @importFrom openxlsx addWorksheet writeData conditionalFormatting createStyle addStyle
#'
#' @export
#' @examples
#' comment <- list(
#'   mpg = "Miles/(US) gallon",
#'   cyl = "Number of cylinders",
#'   disp = "Displacement (cu.in.)",
#'   hp = "Gross horsepower",
#'   drat = "Rear axle ratio",
#'   wt = "Weight (1000 lbs)",
#'   qsec = "1/4 mile time",
#'   vs = "Engine (0=V-shaped,1=straight)",
#'   am = "Transmission (0=automatic,1=manual)",
#'   gear = "Number of forward gears",
#'   carb = "Number of carburetors",
#'   extra_comment1 = "test1",
#'   extra_comment2 = "test2"
#' )
#' mtcor <- data.frame(cor(mtcars))
#' filename <- "excel_matrix.xlsx"
#' if (file.exists(filename)) file.remove(filename)
#' wb <- openxlsx::createWorkbook()
#' excel_matrix(mtcars, wb,
#'   sheet = "matrix", comment = comment,
#'   conditional_formatting = TRUE, diagonal = FALSE
#' )
#' excel_matrix(mtcars, wb,
#'   sheet = "diagonal_non_square", comment = comment,
#'   conditional_formatting = FALSE, diagonal = TRUE
#' )
#' excel_matrix(mtcars[1:10, 1:10], wb,
#'   sheet = "diagonal_square", comment = comment[1:10],
#'   conditional_formatting = FALSE, diagonal = TRUE
#' )
#' excel_matrix(mtcars, wb,
#'   sheet = "matrix_diagonal_non_square", comment = comment,
#'   conditional_formatting = TRUE, diagonal = TRUE
#' )
#' excel_matrix(mtcars[1:10, 1:10], wb,
#'   sheet = "matrix_diagonal_square", comment = comment[1:10],
#'   conditional_formatting = TRUE, diagonal = TRUE
#' )
#' excel_matrix(mtcor, wb,
#'   sheet = "r", comment = comment,
#'   conditional_formatting = FALSE, diagonal = FALSE
#' )
#' excel_matrix(mtcor, wb,
#'   sheet = "conditional_formatting_r", comment = comment,
#'   conditional_formatting = TRUE, diagonal = TRUE
#' )
#' openxlsx::saveWorkbook(wb, invisible(paste(filename)), TRUE)
excel_matrix <- function(df, workbook, sheet = "output", title = NULL, comment = NULL, numFmt = "#0.00", conditional_formatting = FALSE, diagonal = FALSE, diagonal_length = nrow(df)) {
  df <- data.frame(df, stringsAsFactors = FALSE, check.names = FALSE)
  openxlsx::addWorksheet(workbook, sheet)
  openxlsx::writeData(workbook, sheet, df, rowNames = TRUE)
  excel_generic_format(df = df, workbook = workbook, sheet = sheet, title = title, comment = comment, numFmt = numFmt)
  if (conditional_formatting) {
    openxlsx::conditionalFormatting(workbook, sheet = sheet, cols = 1:length(df) + 1, rows = 1:nrow(df) + 1, style = c("red", "yellow", "green"), type = "colourScale")
  }
  if (diagonal) {
    diagonal_style <- openxlsx::createStyle(fgFill = "red")
    if (nrow(df) == ncol(df)) {
      for (i in 1:diagonal_length + 1) {
        openxlsx::addStyle(workbook, sheet = sheet, style = diagonal_style, rows = i, cols = i, gridExpand = TRUE, stack = FALSE)
      }
    }
  }
}
##########################################################################################
# DATAFRAME TO EXCEL CRITICAL VALUE
##########################################################################################
#' Write a data frame to Excel with per-column conditional formatting thresholds
#'
#' Creates a new worksheet, writes the data, and applies \code{\link{excel_generic_format}}.
#' Additionally highlights cells in specified columns that meet one or two threshold
#' conditions, making it easy to flag critical or out-of-range values.
#'
#' @inheritParams excel_generic_format
#' @param critical A named list or \code{NULL}. Each name must match a column in
#'   \code{df}. The value is either:
#'   \itemize{
#'     \item A single character string with an Excel expression (e.g. \code{"<0.05"},
#'       \code{">20"}, \code{"=0"}). Matching cells are highlighted in red.
#'     \item A character vector of length 2 with two expressions
#'       (e.g. \code{c(">20", "<11")}). The first condition highlights in red,
#'       the second in purple.
#'   }
#'   \code{NA} cells in the target column are skipped. Default is \code{NULL}.
#'
#' @return Called for its side effects. Adds a formatted worksheet to \code{workbook};
#'   returns \code{NULL} invisibly.
#'
#' @details
#' Unlike \code{\link{excel_generic_format}}, this function creates the worksheet
#' and writes the data internally — do not call \code{addWorksheet()} or
#' \code{writeData()} beforehand.
#'
#' Threshold expressions follow Excel conditional formatting syntax and are applied
#' row by row, skipping \code{NA} values.
#'
#' @seealso \code{\link{excel_generic_format}}, \code{\link{excel_matrix}}
#'
#' @importFrom openxlsx addWorksheet writeData createStyle conditionalFormatting
#'
#' @export
#' @examples
#' comment <- list(
#'   mpg = "Miles/(US) gallon",
#'   cyl = "Number of cylinders",
#'   disp = "Displacement (cu.in.)",
#'   hp = "Gross horsepower",
#'   drat = "Rear axle ratio",
#'   wt = "Weight (1000 lbs)",
#'   qsec = "1/4 mile time",
#'   vs = "Engine (0=V-shaped,1=straight)",
#'   am = "Transmission (0=automatic,1=manual)",
#'   gear = "Number of forward gears",
#'   carb = "Number of carburetors",
#'   extra_comment1 = "test1",
#'   extra_comment2 = "test2"
#' )
#' filename <- "excel_critical_value.xlsx"
#' if (file.exists(filename)) file.remove(filename)
#' wb <- openxlsx::createWorkbook()
#' df <- generate_missing(generate_correlation_matrix())
#' critical <- list(X1 = "<0.05", X5 = "<0")
#' excel_critical_value(
#'   df = df, workbook = wb, sheet = "critical", comment = list(X1 = "test"),
#'   numFmt = "#0.00", critical = critical
#' )
#' openxlsx::saveWorkbook(wb, invisible(paste(filename)), TRUE)
#' filename <- "excel_critical_value_comment.xlsx"
#' if (file.exists(filename)) file.remove(filename)
#' wb <- openxlsx::createWorkbook()
#' df <- generate_missing(mtcars)
#' critical <- list(mpg = ">20", am = "=0")
#' excel_critical_value(
#'   df = df, workbook = wb, sheet = "critical", comment = comment,
#'   numFmt = "#0.00", critical = critical
#' )
#' openxlsx::saveWorkbook(wb, invisible(paste(filename)), TRUE)
#' filename <- "excel_critical_value_comment_min_max.xlsx"
#' if (file.exists(filename)) file.remove(filename)
#' wb <- openxlsx::createWorkbook()
#' df <- generate_missing(mtcars)
#' critical <- list(mpg = c(">20", "<11"), am = "=0")
#' excel_critical_value(
#'   df = df, workbook = wb, sheet = "critical", comment = comment,
#'   numFmt = "#0.00", critical = critical
#' )
#' openxlsx::saveWorkbook(wb, invisible(paste(filename)), TRUE)
excel_critical_value <- function(df, workbook, sheet = "output", title = NULL, comment = NULL, numFmt = "#0.00", critical = NULL) {
  openxlsx::addWorksheet(workbook, sheet)
  openxlsx::writeData(workbook, sheet, df, rowNames = TRUE)
  excel_generic_format(df = df, workbook = workbook, sheet = sheet, title = title, comment = comment, numFmt = numFmt)
  if (!is.null(critical)) {
    for (i in names(critical)) {
      df <- remove_nc(df, value = NA, remove_rows = FALSE, aggressive = FALSE, remove_cols = FALSE, remove_zero_variance = FALSE)
      if (length(critical[[i]]) > 1) {
        critical_value_min <- createStyle(bgFill = "red", numFmt = numFmt)
        critical_value_max <- createStyle(bgFill = "purple", numFmt = numFmt)
        rows <- which(!is.na(df[, i])) + 1
        for (r in rows) {
          conditionalFormatting(workbook, sheet, cols = which(i == names(df)) + 1, rows = r, type = "expression", rule = critical[[i]][1], style = critical_value_min)
          conditionalFormatting(workbook, sheet, cols = which(i == names(df)) + 1, rows = r, type = "expression", rule = critical[[i]][2], style = critical_value_max)
        }
      } else {
        critical_value <- createStyle(bgFill = "red", numFmt = numFmt)
        rows <- which(!is.na(df[, i])) + 1
        for (r in rows) {
          conditionalFormatting(workbook, sheet, cols = which(i == names(df)) + 1, rows = r, type = "expression", rule = critical[[i]], style = critical_value)
        }
      }
    }
  }
}
# excel_critical_value<-function(df,workbook,sheet="output",title=NULL,comment=NULL,numFmt="#0.00",critical=NULL) {
#   # helpers
#   colnum_to_letter<-function(colnum) {
#     letters<-c(LETTERS)
#     res<-""
#     while (colnum > 0) {
#       rem<-(colnum-1) %% 26
#       res<-paste0(letters[rem+1],res)
#       colnum<-(colnum-1) %/% 26
#     }
#     res
#   }
#   contiguous_ranges<-function(indices) {
#     if (length(indices) == 0) return(list())
#     idx<-sort(indices)
#     breaks<-c(1,which(diff(idx) != 1)+1,length(idx)+1)
#     ranges<-list()
#     for (b in seq_len(length(breaks)-1)) {
#       start_i<-idx[breaks[b]]
#       end_i<-idx[breaks[b+1]-1]
#       ranges[[length(ranges)+1]]<-c(start_i,end_i)
#     }
#     ranges
#   }
#
#   openxlsx::addWorksheet(workbook,sheet)
#   openxlsx::writeData(workbook,sheet,df,rowNames=TRUE)
#   excel_generic_format(df=df,workbook=workbook,sheet=sheet,
#                        title=title,comment=comment,numFmt=numFmt)
#
#   if (is.null(critical)) return(invisible(NULL))
#
#   # Pre-clean once
#   df_clean<-remove_nc(df,value=NA,
#                       remove_rows=FALSE,aggressive=FALSE,
#                       remove_cols=FALSE,remove_zero_variance=FALSE)
#
#   for (col_name in names(critical)) {
#     if (!col_name %in% names(df_clean)) next
#     # find non-NA data rows in the data frame; +1 for header row written by writeData()
#     data_row_indices<-which(!is.na(df_clean[[col_name]]))
#     if (length(data_row_indices) == 0) next
#
#     # Excel rows start at 2 when rowNames=TRUE (first row=header,second row=first data row)
#     excel_rows<-data_row_indices+1L
#
#     # Excel column index in sheet: offset by 1 because writeData wrote row names as first column
#     col_index<-which(names(df_clean) == col_name)+1L
#     col_letter<-colnum_to_letter(col_index)
#
#     # Build style(s)
#     if (length(critical[[col_name]]) > 1) {
#       style_min<-openxlsx::createStyle(bgFill="red",numFmt=numFmt)
#       style_max<-openxlsx::createStyle(bgFill="purple",numFmt=numFmt)
#
#       # group contiguous rows to reduce # of conditionalFormatting calls
#       ranges<-contiguous_ranges(excel_rows)
#       for (r in ranges) {
#         start_row<-r[1]
#         end_row<-r[2]
#         # use the start_row in the formula; applying the rule to rows=start_row:end_row will evaluate
#         # the expression per cell in that area (Excel evaluates the formula relative to each cell in range)
#         rule1<-paste0("AND(",col_letter,start_row,critical[[col_name]][1],")")
#         rule2<-paste0("AND(",col_letter,start_row,critical[[col_name]][2],")")
#
#         openxlsx::conditionalFormatting(
#           workbook,sheet,
#           cols=col_index,rows=start_row:end_row,
#           type="expression",rule=rule1,style=style_min
#         )
#         openxlsx::conditionalFormatting(
#           workbook,sheet,
#           cols=col_index,rows=start_row:end_row,
#           type="expression",rule=rule2,style=style_max
#         )
#       }
#     } else {
#       style<-openxlsx::createStyle(bgFill="red",numFmt=numFmt)
#       ranges<-contiguous_ranges(excel_rows)
#       for (r in ranges) {
#         start_row<-r[1]
#         end_row<-r[2]
#         rule<-paste0("AND(",col_letter,start_row,critical[[col_name]],")")
#         openxlsx::conditionalFormatting(
#           workbook,sheet,
#           cols=col_index,rows=start_row:end_row,
#           type="expression",rule=rule,style=style
#         )
#       }
#     }
#   }
#   invisible(NULL)
# }
##########################################################################################
# DATAFRAME TO EXCEL CONFUSION MATRIX
##########################################################################################
#' @title Write matrix or dataframe to excel sheet
#' @description Useful for correlation matrices since it uses conditional formatting for matrices
#' @param df dataframe or matrix
#' @param workbook workbook
#' @param title comment
#' @import openxlsx
#' @keywords functions
#' @export
#' @examples
#' filename <- "excel_confusion_matrix.xlsx"
#' if (file.exists(filename)) file.remove(filename)
#' observed <- factor(round(rnorm(10000, m = 10, sd = 1)))
#' predicted <- factor(round(rnorm(10000, m = 10, sd = 1)))
#' confusion(observed, predicted)
#' cm <- confusion_matrix_percent(observed, predicted)
#' wb <- openxlsx::createWorkbook()
#' excel_confusion_matrix(cm, wb)
#' openxlsx::saveWorkbook(wb, invisible(paste(filename)), TRUE)
excel_confusion_matrix <- function(df, workbook, title = "Rows: Expected Collumns: Observed") {
  numFmt <- "#0"
  sheet <- "Confusion Matrix"
  comment <- NULL
  content_style1 <- createStyle(border = "TopBottomLeftRight", borderColour = "gray", borderStyle = "thin", valign = "bottom", wrapText = FALSE, numFmt = numFmt, fgFill = "yellow")
  content_style2 <- createStyle(border = "TopBottomLeftRight", borderColour = "gray", borderStyle = "thin", valign = "bottom", wrapText = FALSE, numFmt = "#0.00", fgFill = "yellow")
  df <- change_data_type(df, type = "numeric")
  openxlsx::addWorksheet(workbook, sheet = sheet)
  openxlsx::writeData(workbook, sheet = sheet, df, rowNames = TRUE)
  excel_generic_format(df = df, workbook = workbook, sheet = sheet, title = title, comment = comment, numFmt = numFmt)
  conditionalFormatting(workbook, sheet = sheet, cols = 1:(length(df) - 1), rows = 1:(nrow(df) - 1), style = c("white", "green"), type = "colourScale", numFmt = numFmt)
  addStyle(workbook, sheet = sheet, style = content_style1, rows = nrow(df), cols = 2:(ncol(df) + 1), gridExpand = TRUE, stack = TRUE)
  addStyle(workbook, sheet = sheet, style = content_style1, rows = 2:(nrow(df) + 1), cols = ncol(df), gridExpand = TRUE, stack = TRUE)
  addStyle(workbook, sheet = sheet, style = content_style2, rows = nrow(df) + 1, cols = 2:(ncol(df) + 1), gridExpand = TRUE, stack = TRUE)
  addStyle(workbook, sheet = sheet, style = content_style2, rows = 2:(nrow(df) + 1), cols = ncol(df) + 1, gridExpand = TRUE, stack = TRUE)
  removeColWidths(workbook, sheet, cols = 1:(length(df) + 1))
  setColWidths(workbook, sheet = sheet, cols = 1:(length(df) + 1), widths = "auto")
}
##########################################################################################
# DATAFRAME TO EXCEL
##########################################################################################
#' @title Write matrix or dataframe to excel sheet
#' @description Useful for generic data where conditional formatting of a specific column is required
#' @param df dataframe or matrix
#' @param file output filename of excel file
#' @param type "critical_value" "matrix"
#' @param ... arguments passed to excel_critical_value or to excel_matrix
#' @import openxlsx
#' @keywords functions
#' @export
#' @examples
#' comment <- list(
#'   mpg = "Miles/(US) gallon",
#'   cyl = "Number of cylinders",
#'   disp = "Displacement (cu.in.)",
#'   hp = "Gross horsepower",
#'   drat = "Rear axle ratio",
#'   wt = "Weight (1000 lbs)",
#'   qsec = "1/4 mile time",
#'   vs = "Engine (0=V-shaped,1=straight)",
#'   am = "Transmission (0=automatic,1=manual)",
#'   gear = "Number of forward gears",
#'   carb = "Number of carburetors"
#' )
#' report_dataframe(mtcars,
#'   sheet = "report", file = "mtcars", comment = comment, numFmt = "#0.00",
#'   critical = list(am = "<0.05")
#' )
#' report_dataframe(mtcars,
#'   sheet = "report", file = NULL, comment = comment, numFmt = "#0.00",
#'   critical = list(am = "<0.05")
#' )
report_dataframe <- function(df, file = NULL, type = "critical_value", ...) {
  filename <- paste0(file, ".xlsx")
  if (!is.null(file)) {
    if (file.exists(filename)) file.remove(filename)
    workbook <- openxlsx::createWorkbook()
    if (type == "critical_value") {
      excel_critical_value(df = df, workbook = workbook, ...)
    }
    if (type == "matrix") {
      excel_matrix(df = df, workbook = workbook, ...)
    }
    openxlsx::saveWorkbook(wb = workbook, file = filename, overwrite = TRUE, returnValue = FALSE)
  } else {
    return(df)
  }
}
##########################################################################################
# DATAFRAME INDEX
##########################################################################################
#' @title dataframe index
#' @param nrow number of rows
#' @param ncol number of collumns
#' @keywords functions
#' @export
#' @examples
#' data_frame_index(5, 5)
data_frame_index <- function(nrow, ncol) {
  m <- matrix(ncol = 2, nrow = nrow)
  ri <- ci <- c()
  for (c in 1:ncol) {
    for (r in 1:nrow) {
      ri <- c(ri, r)
      ci <- c(ci, c)
    }
  }
  result <- as.matrix(data.frame(ri, ci))
  return(result)
}
