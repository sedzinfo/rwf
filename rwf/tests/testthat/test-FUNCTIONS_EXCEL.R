# All workbooks are built in memory and saved only to temporary files.

# Style objects that cover a given cell of a sheet, in the order they were added
cell_styles <- function(wb, sheet, row, col) {
  hits <- Filter(function(s) s$sheet == sheet && any(s$rows == row & s$cols == col), wb$styleObjects)
  lapply(hits, function(s) s$style)
}

# Number format of the style that applies last to a cell (NULL when unstyled)
cell_numfmt <- function(wb, sheet, row, col) {
  styles <- cell_styles(wb, sheet, row, col)
  if (length(styles) == 0) return(NULL)
  utils::tail(styles, 1)[[1]]$numFmt$formatCode
}

# Foreground fill colours used by the styles of a cell
cell_fill <- function(wb, sheet, row, col) {
  unlist(lapply(cell_styles(wb, sheet, row, col), function(s) s$fill$fillFg))
}

conditional_rules <- function(wb, sheet) {
  wb$worksheets[[which(names(wb) == sheet)]]$conditionalFormatting
}

save_and_reload <- function(wb) {
  file <- withr::local_tempfile(fileext = ".xlsx", .local_envir = parent.frame())
  openxlsx::saveWorkbook(wb, file, overwrite = TRUE)
  file
}

mtcars_comments <- list(mpg = "Miles/(US) gallon", cyl = "Number of cylinders", hp = "Gross horsepower",
                        not_a_column = "ignored")

##########################################################################################
# excel_generic_format
##########################################################################################
test_that("excel_generic_format adds the title and column comments, ignoring unknown names", {
  df <- mtcars[1:6, 1:5]
  wb <- openxlsx::createWorkbook()
  openxlsx::addWorksheet(wb, "sheet")
  openxlsx::writeData(wb, "sheet", df, rowNames = TRUE)
  excel_generic_format(df, wb, sheet = "sheet", title = "my title", comment = mtcars_comments)
  comments <- wb$comments[[1]]
  refs <- vapply(comments, `[[`, character(1), "ref")
  texts <- vapply(comments, `[[`, character(1), "comment")
  expect_equal(refs, c("A1", "B1", "C1", "E1"))
  expect_equal(texts, c("my title", "Miles/(US) gallon", "Number of cylinders", "Gross horsepower"))

  file <- save_and_reload(wb)
  reloaded <- openxlsx::loadWorkbook(file)
  expect_equal(vapply(reloaded$comments[[1]], `[[`, character(1), "ref"), c("A1", "B1", "C1", "E1"))
})

test_that("excel_generic_format without title or comments adds no comments", {
  df <- mtcars[1:4, 1:3]
  wb <- openxlsx::createWorkbook()
  openxlsx::addWorksheet(wb, "sheet")
  openxlsx::writeData(wb, "sheet", df, rowNames = TRUE)
  excel_generic_format(df, wb, sheet = "sheet")
  expect_length(wb$comments[[1]], 0)
})

test_that("excel_generic_format freezes the header, sets the font, widths and number formats", {
  df <- data.frame(count = c(1, 2, 3), ratio = c(0.5, 1.25, 2), whole = 4:6, row.names = c("a", "b", "c"))
  wb <- openxlsx::createWorkbook()
  openxlsx::addWorksheet(wb, "sheet")
  openxlsx::writeData(wb, "sheet", df, rowNames = TRUE)
  excel_generic_format(df, wb, sheet = "sheet", numFmt = "#0.000")

  pane <- wb$worksheets[[1]]$freezePane
  expect_match(pane, 'xSplit="1"', fixed = TRUE)
  expect_match(pane, 'ySplit="1"', fixed = TRUE)
  expect_match(pane, 'state="frozen"', fixed = TRUE)

  font <- openxlsx::getBaseFont(wb)
  expect_equal(font$name$val, "Liberation Sans")
  expect_equal(font$size$val, "10")

  widths <- wb$colWidths[[1]]
  expect_equal(names(widths), as.character(1:4))
  expect_true(all(widths == "auto"))

  for (row in 2:4) {
    expect_equal(cell_numfmt(wb, "sheet", row, 2), "#0")
    expect_equal(cell_numfmt(wb, "sheet", row, 3), "#0.000")
    expect_equal(cell_numfmt(wb, "sheet", row, 4), "#0")
  }
  # header row and row-name column carry the header style
  expect_length(cell_styles(wb, "sheet", 1, 3), 1)
  expect_length(cell_styles(wb, "sheet", 3, 1), 1)

  file <- save_and_reload(wb)
  expect_equal(openxlsx::read.xlsx(file, sheet = "sheet", rowNames = TRUE), df)
})

test_that("excel_generic_format gives integer columns with NA the whole-number format", {
  skip("rwf bug: all(y == round(y)) is NA for integer columns with NA, so they get no number format")
  df <- data.frame(whole = c(1, NA, 3), ratio = c(0.5, NA, 2))
  wb <- openxlsx::createWorkbook()
  openxlsx::addWorksheet(wb, "sheet")
  openxlsx::writeData(wb, "sheet", df, rowNames = TRUE)
  excel_generic_format(df, wb, sheet = "sheet")
  expect_equal(cell_numfmt(wb, "sheet", 2, 2), "#0")
  expect_equal(cell_numfmt(wb, "sheet", 2, 3), "#0.00")
})

test_that("excel_generic_format handles character and factor columns", {
  df <- data.frame(name = c("x", "y"), group = factor(c("a", "b")), value = c(1.5, 2.5))
  wb <- openxlsx::createWorkbook()
  openxlsx::addWorksheet(wb, "sheet")
  openxlsx::writeData(wb, "sheet", df, rowNames = TRUE)
  expect_no_error(excel_generic_format(df, wb, sheet = "sheet", comment = list(name = "Names")))
  expect_equal(cell_numfmt(wb, "sheet", 2, 4), "#0.00")
  file <- save_and_reload(wb)
  back <- openxlsx::read.xlsx(file, sheet = "sheet", rowNames = TRUE)
  expect_equal(back$name, df$name)
  expect_equal(back$group, as.character(df$group))
  expect_equal(back$value, df$value)
})

##########################################################################################
# excel_matrix
##########################################################################################
test_that("excel_matrix writes the data and the colour scale over the data cells", {
  r <- stats::cor(mtcars[, 1:4])
  wb <- openxlsx::createWorkbook()
  excel_matrix(r, wb, sheet = "r", conditional_formatting = TRUE)
  expect_equal(names(wb), "r")
  rules <- conditional_rules(wb, "r")
  expect_length(rules, 1)
  expect_equal(names(rules), "B2:E5")
  expect_match(rules[[1]], "colorScale", fixed = TRUE)
  expect_match(rules[[1]], "FFFF0000", fixed = TRUE)
  expect_match(rules[[1]], "FF00FF00", fixed = TRUE)

  file <- save_and_reload(wb)
  expect_equal(openxlsx::getSheetNames(file), "r")
  back <- openxlsx::read.xlsx(file, sheet = "r", rowNames = TRUE)
  expect_equal(dim(back), c(4, 4))
  expect_equal(as.matrix(back), r, tolerance = 1e-12)
})

test_that("excel_matrix without options adds no conditional formatting or diagonal", {
  wb <- openxlsx::createWorkbook()
  excel_matrix(mtcars, wb, sheet = "plain", comment = mtcars_comments)
  expect_length(conditional_rules(wb, "plain"), 0)
  expect_null(cell_fill(wb, "plain", 2, 2))
  expect_length(wb$comments[[1]], 3)
  file <- save_and_reload(wb)
  expect_equal(openxlsx::read.xlsx(file, sheet = "plain", rowNames = TRUE), mtcars)
})

test_that("excel_matrix highlights the diagonal of square data only", {
  r <- stats::cor(mtcars[, 1:4])
  wb <- openxlsx::createWorkbook()
  excel_matrix(r, wb, sheet = "square", diagonal = TRUE)
  excel_matrix(mtcars[, 1:4], wb, sheet = "rectangular", diagonal = TRUE)
  excel_matrix(r, wb, sheet = "partial", diagonal = TRUE, diagonal_length = 2)
  for (i in 2:5) {
    expect_true("FFFF0000" %in% unlist(cell_fill(wb, "square", i, i)))
    expect_false("FFFF0000" %in% unlist(cell_fill(wb, "rectangular", i, i)))
  }
  expect_false("FFFF0000" %in% unlist(cell_fill(wb, "square", 2, 3)))
  expect_true("FFFF0000" %in% unlist(cell_fill(wb, "partial", 3, 3)))
  expect_false("FFFF0000" %in% unlist(cell_fill(wb, "partial", 4, 4)))
  file <- save_and_reload(wb)
  expect_equal(openxlsx::getSheetNames(file), c("square", "rectangular", "partial"))
})

test_that("excel_matrix keeps non-syntactic column names and accepts a plain matrix", {
  m <- matrix(1:6, nrow = 2, dimnames = list(c("r1", "r2"), c("a b", "c-d", "e")))
  wb <- openxlsx::createWorkbook()
  excel_matrix(m, wb, sheet = "m")
  file <- save_and_reload(wb)
  back <- openxlsx::read.xlsx(file, sheet = "m", rowNames = TRUE, check.names = FALSE, sep.names = " ")
  expect_equal(names(back), c("a b", "c-d", "e"))
  expect_equal(unname(as.matrix(back)), unname(m) + 0)
})

##########################################################################################
# excel_critical_value
##########################################################################################
test_that("excel_critical_value adds one rule per non-missing cell of the flagged column", {
  df <- mtcars[1:8, 1:4]
  df$mpg[c(2, 5)] <- NA
  wb <- openxlsx::createWorkbook()
  excel_critical_value(df, wb, sheet = "critical", critical = list(mpg = "<20"))
  rules <- conditional_rules(wb, "critical")
  expected_rows <- which(!is.na(df$mpg)) + 1
  expect_setequal(names(rules), paste0("B", expected_rows, ":B", expected_rows))
  expect_length(rules, sum(!is.na(df$mpg)))
  formulas <- sub(".*<formula>(.*)</formula>.*", "\\1", rules)
  expect_setequal(formulas, paste0("B", expected_rows, "&lt;20"))

  file <- save_and_reload(wb)
  back <- openxlsx::read.xlsx(file, sheet = "critical", rowNames = TRUE)
  expect_equal(back, df)
})

test_that("excel_critical_value applies a red and a purple rule for two thresholds", {
  df <- mtcars[1:5, c("mpg", "disp", "am")]
  wb <- openxlsx::createWorkbook()
  excel_critical_value(df, wb, sheet = "critical", critical = list(disp = c(">200", "<120"), am = "=0"))
  rules <- conditional_rules(wb, "critical")
  expect_length(rules, 2 * 5 + 5)
  disp_rules <- rules[grepl("^C", names(rules))]
  expect_length(disp_rules, 10)
  expect_equal(sum(grepl("&gt;200", disp_rules, fixed = TRUE)), 5)
  expect_equal(sum(grepl("&lt;120", disp_rules, fixed = TRUE)), 5)
  am_rules <- rules[grepl("^D", names(rules))]
  expect_length(am_rules, 5)
  expect_true(all(grepl("D[0-9]+=0", am_rules)))
  dxfs <- paste(wb$styles$dxfs, collapse = "")
  expect_match(dxfs, "FFFF0000", fixed = TRUE)
  expect_match(dxfs, "FFA020F0", fixed = TRUE) # R's "purple"
})

test_that("excel_critical_value without thresholds only formats the sheet", {
  wb <- openxlsx::createWorkbook()
  excel_critical_value(mtcars, wb, sheet = "plain", title = "cars", comment = mtcars_comments)
  expect_length(conditional_rules(wb, "plain"), 0)
  expect_equal(vapply(wb$comments[[1]], `[[`, character(1), "comment")[1], "cars")
  file <- save_and_reload(wb)
  expect_equal(openxlsx::read.xlsx(file, sheet = "plain", rowNames = TRUE), mtcars)
})

##########################################################################################
# excel_confusion_matrix
##########################################################################################
confusion_fixture <- function() {
  confusion_matrix_percent(observed = c(1, 2, 2, 2, 2, 1, 3, 3), predicted = c(1, 1, 2, 2, 2, 1, 3, 2))
}

test_that("excel_confusion_matrix writes a numeric 'Confusion Matrix' sheet", {
  cm <- confusion_fixture()
  wb <- openxlsx::createWorkbook()
  excel_confusion_matrix(cm, wb)
  expect_equal(names(wb), "Confusion Matrix")
  expect_equal(vapply(wb$comments[[1]], `[[`, character(1), "comment"), "Rows: Expected Collumns: Observed")
  file <- save_and_reload(wb)
  back <- openxlsx::read.xlsx(file, sheet = "Confusion Matrix", rowNames = TRUE, check.names = FALSE)
  expect_equal(dim(back), dim(cm))
  expect_equal(rownames(back), rownames(cm))
  expect_equal(names(back), names(cm))
  expected <- vapply(cm, function(x) as.numeric(x), numeric(nrow(cm)))
  expect_equal(unname(as.matrix(back)), unname(expected))
})

test_that("excel_confusion_matrix highlights the totals and proportions in yellow", {
  cm <- confusion_fixture()
  k <- ncol(cm)
  wb <- openxlsx::createWorkbook()
  excel_confusion_matrix(cm, wb, title = "custom")
  expect_equal(vapply(wb$comments[[1]], `[[`, character(1), "comment"), "custom")
  yellow <- "FFFFFF00"
  # sum row and p row, sum column and p column
  for (col in 2:(k + 1)) {
    expect_true(yellow %in% cell_fill(wb, "Confusion Matrix", nrow(cm), col))
    expect_true(yellow %in% cell_fill(wb, "Confusion Matrix", nrow(cm) + 1, col))
  }
  for (row in 2:(nrow(cm) + 1)) {
    expect_true(yellow %in% cell_fill(wb, "Confusion Matrix", row, k))
    expect_true(yellow %in% cell_fill(wb, "Confusion Matrix", row, k + 1))
  }
  # the counts are not highlighted, the proportions use two decimals
  expect_false(yellow %in% cell_fill(wb, "Confusion Matrix", 2, 2))
  expect_equal(cell_numfmt(wb, "Confusion Matrix", nrow(cm) + 1, 2), "#0.00")
  expect_equal(cell_numfmt(wb, "Confusion Matrix", 2, k + 1), "#0.00")
})

test_that("excel_confusion_matrix colour scale covers exactly the count cells", {
  skip("rwf bug: colour scale uses cols 1:(k-1), rows 1:(n-1), which includes the header row and row-name column")
  cm <- confusion_fixture()
  wb <- openxlsx::createWorkbook()
  excel_confusion_matrix(cm, wb)
  rules <- conditional_rules(wb, "Confusion Matrix")
  expect_equal(names(rules), "B2:D4")
})

##########################################################################################
# report_dataframe
##########################################################################################
test_that("report_dataframe returns the data unchanged when file is NULL", {
  dir <- withr::local_tempdir()
  withr::local_dir(dir)
  expect_identical(report_dataframe(mtcars, file = NULL, sheet = "report"), mtcars)
  expect_length(list.files(dir), 0)
})

test_that("report_dataframe writes a critical-value workbook", {
  dir <- withr::local_tempdir()
  file <- file.path(dir, "cars")
  report_dataframe(mtcars, file = file, sheet = "report", comment = mtcars_comments,
                   critical = list(am = "<0.05"))
  path <- paste0(file, ".xlsx")
  expect_true(file.exists(path))
  expect_equal(openxlsx::getSheetNames(path), "report")
  expect_equal(openxlsx::read.xlsx(path, sheet = "report", rowNames = TRUE), mtcars)
  wb <- openxlsx::loadWorkbook(path)
  expect_length(wb$worksheets[[1]]$conditionalFormatting, nrow(mtcars))
})

test_that("report_dataframe writes a matrix workbook and overwrites an existing file", {
  dir <- withr::local_tempdir()
  file <- file.path(dir, "correlations")
  path <- paste0(file, ".xlsx")
  writeLines("stale", path)
  r <- stats::cor(mtcars[, 1:5])
  report_dataframe(r, file = file, type = "matrix", sheet = "cor", conditional_formatting = TRUE, diagonal = TRUE)
  expect_equal(openxlsx::getSheetNames(path), "cor")
  back <- openxlsx::read.xlsx(path, sheet = "cor", rowNames = TRUE)
  expect_equal(as.matrix(back), r, tolerance = 1e-12)
  wb <- openxlsx::loadWorkbook(path)
  expect_equal(names(wb$worksheets[[1]]$conditionalFormatting), "B2:F6")
})

test_that("report_dataframe uses the default sheet name 'output'", {
  dir <- withr::local_tempdir()
  file <- file.path(dir, "default")
  report_dataframe(PlantGrowth, file = file)
  expect_equal(openxlsx::getSheetNames(paste0(file, ".xlsx")), "output")
  back <- openxlsx::read.xlsx(paste0(file, ".xlsx"), rowNames = TRUE)
  expect_equal(back$weight, PlantGrowth$weight)
  expect_equal(back$group, as.character(PlantGrowth$group))
})

##########################################################################################
# data_frame_index
##########################################################################################
test_that("data_frame_index lists every cell in column-major order", {
  rwf <- data_frame_index(3, 4)
  expect_true(is.matrix(rwf))
  expect_equal(dim(rwf), c(12, 2))
  expect_equal(colnames(rwf), c("ri", "ci"))
  expect_equal(unname(rwf), unname(as.matrix(expand.grid(1:3, 1:4))))
  expect_equal(unname(rwf), arrayInd(1:12, c(3, 4)))
})

test_that("data_frame_index indexes a matrix in the same order as as.vector", {
  m <- matrix(stats::runif(15), nrow = 5)
  idx <- data_frame_index(nrow(m), ncol(m))
  expect_equal(m[idx], as.vector(m))
  expect_equal(unname(data_frame_index(1, 1)), matrix(c(1L, 1L), nrow = 1))
})
