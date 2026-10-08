##########################################################################################
# CONVERT EXCEL TIMESTAMP TO UNIX TIMESTAMP
##########################################################################################
#' @title Convert UNIX EXCEL timestamp
#' @param timestamp unix or excel timestamp
#' @keywords timestamp
#' @export
#' @examples
#' convert_excel_unix_timestamp(1)
convert_excel_unix_timestamp <- function(timestamp) {
  unix_timestamp <- (timestamp - 25569) * 86400
  excel_timestamp <- (timestamp / 86400) + 24107
  result <- list(unix_timestamp = unix_timestamp, excel_timestamp = excel_timestamp)
  return(result)
}
##########################################################################################
# DECOMPOSE DATE TIME
##########################################################################################
#' @title Decompose datetime objects to dataframe collumns
#' @param x datetime object
#' @param format date time format
#' @param origin Starting date. The default is the unix time origin "1970-01-01"
#' @param tz Timezone
#' @param extended if TRUE it will display additional day time categories \cr
#' WEEKDAY MONTH JULIAN QUARTER DAY_PERIOD
#' @param breaks Numeric vector Breaks define hour of day for classifying into  \cr
#' "Night", "Morning", "Noon", "Afternoon", "Evening". \cr
#' @param ... arguments passed to as.POSIXct
#' This argument is used if extended=TRUE
#' @importFrom stringr str_pad str_count
#' @keywords timestamp
#' @export
#' @examples
#' timestamp1 <- as.numeric(as.POSIXct(Sys.Date()))
#' timestamp2 <- as.numeric(as.POSIXct(Sys.time()))
#' d1 <- Sys.Date()
#' d2 <- Sys.time()
#' decompose_datetime(x = d1)
#' decompose_datetime(x = d2)
#' decompose_datetime(x = d1, extended = TRUE)
#' decompose_datetime(x = d2, extended = TRUE)
#' decompose_datetime(x = "01/15/1900", format = "%m/%e/%Y")
#' decompose_datetime(x = "01/15/1900", format = "%m/%e/%Y", extended = TRUE)
#' decompose_datetime(x = as.Date(as.POSIXct(10000, origin = "1970-01-01")))
#' decompose_datetime(
#'   x = as.Date(as.POSIXct(timestamp1, origin = "1970-01-01")),
#'   format = "%m/%e/%Y"
#' )
#' decompose_datetime(
#'   x = as.Date(as.POSIXct(timestamp2, origin = "1970-01-01")),
#'   format = "%m/%e/%Y"
#' )
decompose_datetime <- function(x, format = "", origin = "1970-01-01", tz = "GMT", extended = FALSE, breaks = c(-1, 5, 13, 16, 20, 23), ...) {
  dt_pad <- function(x) stringr::str_pad(x, 2, pad = "0")
  collumn_names <- c("YEAR", "MONTH_NUMERIC", "DAY_NUMERIC", "HOUR", "MINUTE", "SECOND", "MILLISECOND")
  dt <- as.POSIXct(x, format = format, origin = origin, tz = tz, na.rm = TRUE, ...)
  date_data <- str_mgsub(dt, c(" ", ":", "/", "-", ".", "."), ";", fixed = TRUE)
  separators_n <- max(stringr::str_count(date_data, ";"), na.rm = TRUE)
  for (i in 1:length(date_data)) {
    if (is.na(date_data[i])) {
      date_data[i] <- gsub(",", " ", toString(rep(";", separators_n + 1)))
    }
  }
  converted_date <- str_split(date_data, split = ";", include_original = FALSE)
  names(converted_date)[1:length(converted_date)] <- collumn_names[1:length(converted_date)]
  converted_date$FULL_DATE <- paste0(converted_date$YEAR, "-", dt_pad(converted_date$MONTH), "-", dt_pad(converted_date$DAY))
  if (length(converted_date) > 4) {
    converted_date$FULL_TIME <- paste0(dt_pad(converted_date$HOUR), ":", dt_pad(converted_date$MINUTE))
  }
  converted_date <- data.frame(converted_date, stringsAsFactors = FALSE)
  if (extended) {
    heure <- as.integer(substr(as.character(dt), 12, 13))
    WEEKDAY <- weekdays(dt)
    MONTH <- months(dt)
    JULIAN <- julian(dt)
    QUARTER <- quarters(dt)
    DAY_PERIOD <- as.character(cut(heure, breaks = breaks, labels = c("Night", "Morning", "Noon", "Afternoon", "Evening")))
    converted_date <- data.frame(QUARTER = QUARTER, MONTH = MONTH, JULIAN = JULIAN, WEEKDAY = WEEKDAY, DAY_PERIOD = DAY_PERIOD, converted_date, stringsAsFactors = FALSE, check.names = FALSE)
  }
  return(converted_date)
}
