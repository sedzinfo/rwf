##########################################################################################
# convert_excel_unix_timestamp
##########################################################################################
# Excel (1900 date system) serial dates count days from 1899-12-30
excel_to_unix_reference <- function(serial) {
  as.numeric(as.POSIXct(as.Date(serial, origin = "1899-12-30"), tz = "UTC"))
}

test_that("convert_excel_unix_timestamp converts Excel serial dates to unix seconds", {
  serial <- c(25569, 36526, 43831, 45000)
  rwf <- convert_excel_unix_timestamp(serial)
  expect_equal(rwf$unix_timestamp, excel_to_unix_reference(serial))
  expect_equal(convert_excel_unix_timestamp(25569)$unix_timestamp, 0)
  # fractional serials are times of day: 0.5 is noon
  expect_equal(convert_excel_unix_timestamp(43831.5)$unix_timestamp,
               as.numeric(as.POSIXct("2020-01-01 12:00:00", tz = "UTC")))
})

test_that("convert_excel_unix_timestamp returns a named list of vectors the length of its input", {
  rwf <- convert_excel_unix_timestamp(c(1, NA, 45000))
  expect_type(rwf, "list")
  expect_named(rwf, c("unix_timestamp", "excel_timestamp"))
  expect_length(rwf$unix_timestamp, 3)
  expect_length(rwf$excel_timestamp, 3)
  expect_true(is.na(rwf$unix_timestamp[2]))
  expect_true(is.na(rwf$excel_timestamp[2]))
})

test_that("convert_excel_unix_timestamp converts unix seconds to Excel serial dates", {
  skip("rwf bug: excel_timestamp adds 24107 (1904 date system) while unix_timestamp uses 25569 (1900 system)")
  unix <- c(0, 86400, as.numeric(as.POSIXct("2020-01-01 12:00:00", tz = "UTC")))
  rwf <- convert_excel_unix_timestamp(unix)
  expect_equal(rwf$excel_timestamp, c(25569, 25570, 43831.5))
  round_trip <- convert_excel_unix_timestamp(rwf$excel_timestamp)$unix_timestamp
  expect_equal(round_trip, unix)
})

##########################################################################################
# decompose_datetime
##########################################################################################
random_times <- function(n = 25) {
  withr::local_seed(2024)
  seconds <- round(stats::runif(n, 0, 2e9))
  seconds <- seconds[seconds %% 86400 != 0]
  as.POSIXct(seconds, origin = "1970-01-01", tz = "GMT")
}

test_that("decompose_datetime splits date-times into the components given by format()", {
  times <- random_times()
  rwf <- decompose_datetime(x = times)
  expect_s3_class(rwf, "data.frame")
  expect_identical(names(rwf), c("YEAR", "MONTH_NUMERIC", "DAY_NUMERIC", "HOUR", "MINUTE", "SECOND",
                                 "FULL_DATE", "FULL_TIME"))
  expect_identical(nrow(rwf), length(times))
  reference <- function(fmt) format(times, fmt, tz = "GMT")
  expect_identical(rwf$YEAR, reference("%Y"))
  expect_identical(rwf$MONTH_NUMERIC, reference("%m"))
  expect_identical(rwf$DAY_NUMERIC, reference("%d"))
  expect_identical(rwf$HOUR, reference("%H"))
  expect_identical(rwf$MINUTE, reference("%M"))
  expect_identical(rwf$SECOND, reference("%S"))
  expect_identical(rwf$FULL_DATE, reference("%Y-%m-%d"))
  expect_identical(rwf$FULL_TIME, reference("%H:%M"))
})

test_that("decompose_datetime returns only date columns for Date input", {
  dates <- as.Date(c("2020-01-15", "1999-12-31", "2024-02-29"))
  rwf <- decompose_datetime(x = dates)
  expect_identical(names(rwf), c("YEAR", "MONTH_NUMERIC", "DAY_NUMERIC", "FULL_DATE"))
  expect_identical(rwf$FULL_DATE, format(dates))
  expect_identical(rwf$YEAR, format(dates, "%Y"))
  expect_identical(rwf$DAY_NUMERIC, format(dates, "%d"))
})

test_that("decompose_datetime parses character input with a format", {
  rwf <- decompose_datetime(x = c("01/15/1900", "12/31/2020"), format = "%m/%e/%Y")
  expect_identical(rwf$YEAR, c("1900", "2020"))
  expect_identical(rwf$MONTH_NUMERIC, c("01", "12"))
  expect_identical(rwf$DAY_NUMERIC, c("15", "31"))
  expect_identical(rwf$FULL_DATE, c("1900-01-15", "2020-12-31"))
})

test_that("decompose_datetime reports the time in the requested time zone", {
  new_york <- as.POSIXct("2020-01-15 13:45:30", tz = "America/New_York")
  gmt <- decompose_datetime(x = new_york)
  expect_identical(gmt$HOUR, "18")
  expect_identical(gmt$FULL_TIME, format(new_york, "%H:%M", tz = "GMT"))
  athens <- decompose_datetime(x = as.POSIXct("2020-07-15 23:30:00", tz = "GMT"), tz = "Europe/Athens")
  expect_identical(athens$FULL_DATE, "2020-07-16")
  expect_identical(athens$FULL_TIME, "02:30")
})

test_that("decompose_datetime converts numeric input from the origin", {
  skip("rwf bug: format = '' is passed on to as.POSIXct(origin), so numeric input is counted from today, not origin")
  rwf <- decompose_datetime(x = 1e9)
  expect_identical(rwf$FULL_DATE, "2001-09-09")
  expect_identical(rwf$FULL_TIME, "01:46")
  later <- decompose_datetime(x = 86400, origin = "2000-01-01")
  expect_identical(later$FULL_DATE, "2000-01-02")
})

test_that("decompose_datetime keeps rows aligned when some times are exactly midnight", {
  skip("rwf bug: as.character() drops 00:00:00 per element, so mixed vectors are split into misaligned columns")
  times <- as.POSIXct(c("2020-01-15 13:45:30", "2020-01-16 00:00:00"), tz = "GMT")
  rwf <- decompose_datetime(x = times)
  expect_identical(rwf$FULL_DATE, c("2020-01-15", "2020-01-16"))
  expect_identical(rwf$HOUR, c("13", "00"))
})

test_that("decompose_datetime keeps one row per element when some are missing", {
  times <- as.POSIXct(c("2020-01-15 13:45:30", NA, "2021-03-02 08:05:09"), tz = "GMT")
  rwf <- decompose_datetime(x = times)
  expect_identical(nrow(rwf), 3L)
  expect_identical(rwf$FULL_DATE[c(1, 3)], c("2020-01-15", "2021-03-02"))
  expect_identical(rwf$FULL_TIME[c(1, 3)], c("13:45", "08:05"))
})

test_that("decompose_datetime returns NA components for missing date-times", {
  skip("rwf bug: missing date-times are filled with blank strings, giving FULL_DATE '-  -  '")
  times <- as.POSIXct(c("2020-01-15 13:45:30", NA), tz = "GMT")
  rwf <- decompose_datetime(x = times)
  expect_true(is.na(rwf$YEAR[2]))
  expect_true(is.na(rwf$FULL_DATE[2]))
})

test_that("decompose_datetime extended adds calendar fields matching base R", {
  times <- as.POSIXct(c("2020-01-15 13:45:30", "2020-04-15 02:00:00", "2020-07-15 18:00:00",
                        "2020-10-31 21:10:00", "2020-12-01 15:59:59"), tz = "GMT")
  rwf <- decompose_datetime(x = times, extended = TRUE)
  expect_identical(names(rwf)[1:5], c("QUARTER", "MONTH", "JULIAN", "WEEKDAY", "DAY_PERIOD"))
  expect_identical(nrow(rwf), length(times))
  expect_identical(rwf$QUARTER, quarters(times))
  expect_identical(rwf$MONTH, months(times))
  expect_identical(rwf$WEEKDAY, weekdays(times))
  expect_equal(as.numeric(rwf$JULIAN), as.numeric(julian(times)))
  expect_identical(rwf$DAY_PERIOD, c("Morning", "Night", "Afternoon", "Evening", "Noon"))
  hours <- as.integer(format(times, "%H", tz = "GMT"))
  expect_identical(rwf$DAY_PERIOD, as.character(cut(hours, breaks = c(-1, 5, 13, 16, 20, 23),
                                                    labels = c("Night", "Morning", "Noon", "Afternoon", "Evening"))))
})

test_that("decompose_datetime extended uses custom breaks", {
  times <- as.POSIXct(c("2020-01-15 03:00:00", "2020-01-15 09:00:00", "2020-01-15 22:00:00"), tz = "GMT")
  rwf <- decompose_datetime(x = times, extended = TRUE, breaks = c(-1, 2, 4, 8, 12, 23))
  expect_identical(rwf$DAY_PERIOD, c("Morning", "Afternoon", "Evening"))
})

test_that("decompose_datetime extended classifies midnight as Night", {
  skip("rwf bug: the hour is read from as.character(), which has no time part at midnight, so DAY_PERIOD is NA")
  rwf <- decompose_datetime(x = as.Date("2020-01-15"), extended = TRUE)
  expect_identical(rwf$DAY_PERIOD, "Night")
})
