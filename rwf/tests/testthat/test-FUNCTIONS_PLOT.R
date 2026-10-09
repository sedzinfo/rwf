plot_fixture <- function(title = "plot") {
  ggplot2::ggplot(mtcars, ggplot2::aes(x = wt, y = mpg)) +
    ggplot2::geom_point() +
    ggplot2::ggtitle(title)
}

# Opens a throw-away pdf device with the display list enabled so recordPlot() works
local_plot_device <- function(env = parent.frame()) {
  withr::local_pdf(withr::local_tempfile(fileext = ".pdf", .local_envir = env), .local_envir = env)
  grDevices::dev.control(displaylist = "enable")
}

# Counts the page objects of a PDF written by cairo_pdf, which stores them in compressed object streams
pdf_page_count <- function(path) {
  bytes <- readBin(path, "raw", file.info(path)$size)
  ends <- grepRaw("endstream", bytes, all = TRUE, fixed = TRUE)
  starts <- setdiff(grepRaw("stream\n", bytes, all = TRUE, fixed = TRUE), ends + 3)
  pages <- length(grepRaw("/Type /Page[^s]", bytes, all = TRUE))
  for (start in starts) {
    first <- start + 7
    last <- ends[ends > first][1] - 1
    content <- tryCatch(memDecompress(bytes[first:last], type = "gzip"), error = function(e) bytes[first:last])
    pages <- pages + length(grepRaw("/Type /Page[^s]", content, all = TRUE))
  }
  pages
}

##########################################################################################
# plot_multiplot
##########################################################################################
test_that("plot_multiplot returns a single plot unchanged", {
  p <- plot_fixture()
  rwf <- plot_multiplot(p)
  expect_s3_class(rwf, "ggplot")
  expect_identical(rwf, p)
  expect_no_error(ggplot2::ggplot_build(rwf))
  expect_identical(plot_multiplot(plotlist = list(p)), p)
})

test_that("plot_multiplot puts all plots on one page with the automatic layout", {
  local_plot_device()
  rwf <- plot_multiplot(plot_fixture("a"), plot_fixture("b"), plot_fixture("c"), cols = 2)
  expect_type(rwf, "list")
  expect_length(rwf, 1)
  expect_s3_class(rwf[[1]], "recordedplot")
})

test_that("plot_multiplot creates one page per filled layout", {
  local_plot_device()
  plots <- lapply(letters[1:5], plot_fixture)
  two_per_page <- plot_multiplot(plotlist = plots, layout = matrix(1:2, ncol = 2))
  expect_length(two_per_page, 3)
  expect_true(all(vapply(two_per_page, inherits, logical(1), "recordedplot")))
  four_per_page <- plot_multiplot(plotlist = plots, layout = matrix(1:4, ncol = 2, byrow = TRUE))
  expect_length(four_per_page, 2)
})

test_that("plot_multiplot combines plots passed through ... and plotlist", {
  local_plot_device()
  rwf <- plot_multiplot(plot_fixture("a"), plotlist = list(plot_fixture("b"), plot_fixture("c")),
                        layout = matrix(1, ncol = 1))
  expect_length(rwf, 3)
})

##########################################################################################
# plot_duplicate_y_axis
##########################################################################################
test_that("plot_duplicate_y_axis draws the plot with an extra right axis and label", {
  local_plot_device()
  p <- plot_fixture() + ggplot2::ylab("Miles per gallon")
  original <- ggplot2::ggplotGrob(p)
  expect_no_error(rwf <- plot_duplicate_y_axis(p1 = p, p2 = p))
  expect_null(rwf)
  drawn <- grid::grid.grab()
  combined <- drawn$children[[1]]
  expect_s3_class(combined, "gtable")
  expect_equal(ncol(combined), ncol(original) + 2)
  expect_equal(nrow(combined), nrow(original))
  expect_equal(sum(combined$layout$name == "axis-r"), sum(original$layout$name == "axis-r") + 1)
  expect_equal(sum(combined$layout$name == "ylab-r"), sum(original$layout$name == "ylab-r") + 1)
  # the added axis is a copy of the left axis, not an empty grob
  added_axis <- combined$grobs[[utils::tail(which(combined$layout$name == "axis-r"), 1)]]
  expect_false(inherits(added_axis, "zeroGrob"))
})

test_that("plot_duplicate_y_axis works with a grouped, coloured plot", {
  local_plot_device()
  p <- ggplot2::ggplot(ChickWeight, ggplot2::aes(x = Time, y = weight, colour = Diet, group = Chick)) +
    ggplot2::geom_line()
  expect_no_error(plot_duplicate_y_axis(p1 = p, p2 = p))
})

##########################################################################################
# report_pdf
##########################################################################################
test_that("report_pdf writes a multi-page pdf with one page per plot", {
  dir <- withr::local_tempdir()
  file <- file.path(dir, "report")
  rwf <- report_pdf(plot_fixture("a"), plot_fixture("b"), plotlist = list(plot_fixture("c")),
                    file = file, print_plot = FALSE)
  expect_null(rwf)
  expect_true(file.exists(paste0(file, ".pdf")))
  expect_gt(file.info(paste0(file, ".pdf"))$size, 0)
  expect_equal(pdf_page_count(paste0(file, ".pdf")), 3)
  expect_equal(list.files(dir), "report.pdf")
})

test_that("report_pdf appends the title to the file name", {
  dir <- withr::local_tempdir()
  file <- file.path(dir, "report")
  report_pdf(plot_fixture(), file = file, title = "cars", print_plot = FALSE)
  expect_equal(list.files(dir), "report_cars.pdf")
  expect_equal(pdf_page_count(file.path(dir, "report_cars.pdf")), 1)
})

test_that("report_pdf writes nothing when file is NULL and prints to the active device", {
  dir <- withr::local_tempdir()
  withr::local_dir(dir)
  local_plot_device()
  expect_no_error(report_pdf(plot_fixture("a"), plot_fixture("b"), print_plot = TRUE))
  expect_length(list.files(dir, pattern = "\\.pdf$"), 0)
  expect_no_error(report_pdf(plot_fixture("a"), print_plot = FALSE))
})

test_that("report_pdf accepts recorded plots from plot_multiplot", {
  local_plot_device()
  recorded <- plot_multiplot(plotlist = lapply(letters[1:4], plot_fixture), layout = matrix(1:2, ncol = 2))
  dir <- withr::local_tempdir()
  file <- file.path(dir, "multiplot")
  expect_no_error(suppressWarnings(report_pdf(plotlist = recorded, file = file, print_plot = FALSE)))
  expect_true(file.exists(paste0(file, ".pdf")))
  expect_equal(pdf_page_count(paste0(file, ".pdf")), 2)
})
