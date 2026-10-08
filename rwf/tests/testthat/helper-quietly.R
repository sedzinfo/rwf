# Runs a report function without printing its progress bars, tables, messages or warnings
quietly <- function(expr) {
  utils::capture.output(value <- suppressWarnings(suppressMessages(expr)))
  value
}
