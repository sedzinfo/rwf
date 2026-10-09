# Extracted from test-GLM_RELIABILITY.R:228

# setup ------------------------------------------------------------------------
library(testthat)
test_env <- simulate_test_env(package = "rwf", path = "..")
attach(test_env, warn.conflicts = FALSE)

# prequel ----------------------------------------------------------------------
bfi_items <- function(n = 500) {
  items <- psych::bfi[, c(paste0("A", 1:5), paste0("C", 1:5))]
  items <- items[stats::complete.cases(items), ]
  items[seq_len(n), ]
}
bfi_reversed <- function(n = 500) {
  items <- bfi_items(n)
  for (item in c("A1", "C4", "C5")) items[[item]] <- 7 - items[[item]]
  items
}
alpha_by_hand <- function(df) {
  df <- df[stats::complete.cases(df), ]
  k <- ncol(df)
  k / (k - 1) * (1 - sum(apply(df, 2, stats::var)) / stats::var(rowSums(df)))
}
alpha_key <- list(A = paste0("A", 1:5), C = paste0("C", 1:5))

# test -------------------------------------------------------------------------
items <- bfi_reversed()
withr::local_seed(42)
result <- quietly(report_alpha(df = items, key = alpha_key["A"], check.keys = FALSE, n.iter = 20))
withr::local_seed(42)
reference <- suppressWarnings(psych::alpha(items[, alpha_key$A], check.keys = FALSE, n.iter = 20))
expect_equal(nrow(result$result_boot), 20)
expect_equal(unname(unlist(result$result_total[, grep("boot_ci", names(result$result_total))])),
               unname(reference$boot.ci))
expect_equal(result$result_boot$raw_alpha, unname(reference$boot[, "raw_alpha"]))
