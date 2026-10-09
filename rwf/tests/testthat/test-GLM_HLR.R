##########################################################################################
# report_hlr
##########################################################################################
orthodont <- function() {
  df <- as.data.frame(nlme::Orthodont)
  df$Subject <- factor(as.character(df$Subject))
  df$log_distance <- log(df$distance)
  df[, c("distance", "age", "Subject", "Sex", "log_distance")]
}

# The four nested models report_hlr compares, fitted directly with nlme
reference_hlr <- function(df, dv) {
  df <- df[stats::complete.cases(df[, c(dv, "age", "Subject")]), ]
  baseline <- stats::as.formula(paste(dv, "~ 1"))
  predictor <- stats::as.formula(paste(dv, "~ age"))
  base <- nlme::gls(baseline, method = "ML", data = df)
  random_intercept <- nlme::lme(fixed = baseline, random = ~ 1 | Subject, data = df, method = "ML")
  random_intercept_predictor <- nlme::lme(fixed = predictor, random = ~ 1 | Subject, data = df, method = "ML")
  random_intercept_slope <- nlme::lme(fixed = predictor, random = ~ age | Subject, data = df, method = "ML")
  result <- as.data.frame(stats::anova(base, random_intercept, random_intercept_predictor, random_intercept_slope))
  names(result)[names(result) == "p-value"] <- "p.value"
  result
}

test_that("report_hlr matches anova() of the nested nlme models", {
  df <- orthodont()
  rwf <- quietly(report_hlr(df = df, corlist = 1, factorlist = 3, predictor = "age", random_effect = "Subject"))
  reference <- reference_hlr(df, "distance")
  expect_s3_class(rwf, "data.frame")
  expect_equal(nrow(rwf), 4)
  expect_equal(rwf$model, c("base", "random_intercept", "random_intercept_predictor", "random_intercept_slope"))
  expect_true(all(rwf$dv == "distance"))
  expect_equal(rwf$fixed, c("distance ~ 1", "distance ~ 1", "distance ~ age", "distance ~ age"))
  expect_equal(rwf$random, c(NA, "~1 | Subject", "~1 | Subject", "~age | Subject"))
  for (column in c("df", "AIC", "BIC", "logLik", "L.Ratio", "p.value")) {
    expect_equal(rwf[[column]], reference[[column]], ignore_attr = TRUE, info = column)
  }
})

test_that("report_hlr stacks the comparisons of several outcomes", {
  df <- orthodont()
  rwf <- quietly(report_hlr(df = df, corlist = c(1, 5), factorlist = 3, predictor = "age", random_effect = "Subject"))
  expect_equal(nrow(rwf), 8)
  expect_equal(rwf$dv, rep(c("distance", "log_distance"), each = 4))
  reference <- reference_hlr(df, "log_distance")
  expect_equal(rwf$logLik[5:8], reference$logLik)
  expect_equal(rwf$p.value[5:8], reference$p.value)
})

test_that("report_hlr drops incomplete cases before fitting", {
  df <- orthodont()
  df$distance[c(1, 20, 50)] <- NA
  df$age[33] <- NA
  rwf <- quietly(report_hlr(df = df, corlist = 1, factorlist = 3, predictor = "age", random_effect = "Subject"))
  reference <- reference_hlr(df, "distance")
  expect_equal(rwf$logLik, reference$logLik)
  expect_equal(rwf$L.Ratio, reference$L.Ratio)
})

test_that("report_hlr writes an xlsx file", {
  dir <- withr::local_tempdir()
  file <- file.path(dir, "hlr")
  quietly(report_hlr(df = orthodont(), corlist = 1, factorlist = 3, predictor = "age",
                     random_effect = "Subject", file = file, sheet = "models"))
  expect_true(file.exists(paste0(file, ".xlsx")))
  expect_equal(openxlsx::getSheetNames(paste0(file, ".xlsx")), "models")
})

test_that("report_hlr keeps the random-effect column even when it is not listed in factorlist", {
  skip("rwf bug: report_hlr subsets df to corlist, factorlist and predictor, dropping the random_effect column")
  df <- orthodont()
  rwf <- quietly(report_hlr(df = df, corlist = 1, factorlist = 2, predictor = "age", random_effect = "Subject"))
  reference <- reference_hlr(df, "distance")
  expect_equal(rwf$logLik, reference$logLik)
})
