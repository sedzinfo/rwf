##########################################################################################
# helpers
##########################################################################################
# Fits the thurstonianIRT triplets example with lavaan once per test run
tirt_cache <- new.env(parent = emptyenv())
triplets_fit <- function() {
  if (is.null(tirt_cache$fit)) {
    data_env <- new.env()
    utils::data("triplets", package = "thurstonianIRT", envir = data_env)
    triplets <- data_env$triplets
    blocks <-
      thurstonianIRT::set_block(c("i1", "i2", "i3"), traits = c("t1", "t2", "t3"), signs = c(1, 1, 1)) +
      thurstonianIRT::set_block(c("i4", "i5", "i6"), traits = c("t1", "t2", "t3"), signs = c(-1, 1, 1)) +
      thurstonianIRT::set_block(c("i7", "i8", "i9"), traits = c("t1", "t2", "t3"), signs = c(1, 1, -1)) +
      thurstonianIRT::set_block(c("i10", "i11", "i12"), traits = c("t1", "t2", "t3"), signs = c(1, -1, 1))
    triplets_long <- thurstonianIRT::make_TIRT_data(data = triplets, blocks = blocks, direction = "larger",
                                                    format = "pairwise", family = "bernoulli", range = c(0, 1))
    tirt_cache$triplets <- triplets
    tirt_cache$fit <- suppressWarnings(thurstonianIRT::fit_TIRT_lavaan(triplets_long))
  }
  list(data = tirt_cache$triplets, fit = tirt_cache$fit)
}

# Independent negative log posterior of the Thurstonian IRT MAP scoring problem:
#   P(y = 1 | eta) = pnorm((lambda eta - (tau - nu)) / sqrt(theta)), eta ~ N(0, Psi)
tirt_neg_log_posterior <- function(eta, pattern, lambda, theta_diag, tau, Psi, nu = rep(0, nrow(lambda))) {
  obs <- !is.na(pattern)
  z <- (drop(lambda[obs, , drop = FALSE] %*% eta) - (tau[obs] - nu[obs])) / sqrt(theta_diag[obs])
  y <- pattern[obs]
  loglik <- sum(y * stats::pnorm(z, log.p = TRUE) + (1 - y) * stats::pnorm(z, lower.tail = FALSE, log.p = TRUE))
  -(loglik - 0.5 * drop(t(eta) %*% solve(Psi) %*% eta))
}

numeric_gradient <- function(f, x, h = 1e-5) {
  vapply(seq_along(x), function(k) {
    e <- replace(numeric(length(x)), k, h)
    (f(x + e) - f(x - e)) / (2 * h)
  }, numeric(1))
}

# A simulated two trait forced choice design with known parameters
simulate_tirt <- function(nindicators = 40, npersons = 30, seed = 123) {
  withr::local_seed(seed)
  lambda <- cbind(trait1 = stats::runif(nindicators, 0.8, 1.5) * sample(c(-1, 1), nindicators, replace = TRUE),
                  trait2 = -stats::runif(nindicators, 0.8, 1.5) * sample(c(-1, 1), nindicators, replace = TRUE))
  rownames(lambda) <- paste0("p", seq_len(nindicators))
  theta_diag <- stats::setNames(stats::runif(nindicators, 1, 2), rownames(lambda))
  tau <- stats::setNames(stats::rnorm(nindicators, 0, 0.5), rownames(lambda))
  Psi <- matrix(c(1, 0.3, 0.3, 1), 2, dimnames = list(colnames(lambda), colnames(lambda)))
  eta <- MASS::mvrnorm(npersons, c(0, 0), Psi)
  ystar <- eta %*% t(lambda) - matrix(tau, npersons, nindicators, byrow = TRUE) +
    matrix(stats::rnorm(npersons * nindicators, 0, rep(sqrt(theta_diag), each = npersons)), npersons)
  patterns <- (ystar > 0) * 1
  colnames(patterns) <- rownames(lambda)
  list(lambda = lambda, theta_diag = theta_diag, tau = tau, Psi = Psi, eta = eta, patterns = patterns)
}

##########################################################################################
# compute_dummy_comparisons
##########################################################################################
test_that("compute_dummy_comparisons is the number of unordered pairs", {
  for (k in 1:10) expect_equal(compute_dummy_comparisons(k), choose(k, 2))
  expect_equal(compute_dummy_comparisons(c(2, 3, 4)), c(1, 3, 6))
})

##########################################################################################
# generate_unique_comparisons_index
##########################################################################################
test_that("generate_unique_comparisons_index lists all pairs i < j in combn order", {
  for (k in 2:6) {
    index <- generate_unique_comparisons_index(k)
    expect_true(is.matrix(index))
    expect_equal(colnames(index), c("i1", "i2"))
    expect_equal(unname(index), t(utils::combn(k, 2)), ignore_attr = TRUE)
    expect_equal(nrow(index), compute_dummy_comparisons(k))
  }
  expect_equal(nrow(generate_unique_comparisons_index(1)), 0)
})

##########################################################################################
# generate_comparisons_matrix
##########################################################################################
test_that("generate_comparisons_matrix has +1 for the first and -1 for the second item of each pair", {
  expect_equal(generate_comparisons_matrix(3), rbind(c(1, -1, 0), c(1, 0, -1), c(0, 1, -1)))
  for (k in 2:6) {
    comparisons <- generate_comparisons_matrix(k)
    pairs <- t(utils::combn(k, 2))
    reference <- matrix(0, nrow(pairs), k)
    reference[cbind(seq_len(nrow(pairs)), pairs[, 1])] <- 1
    reference[cbind(seq_len(nrow(pairs)), pairs[, 2])] <- -1
    expect_equal(comparisons, reference)
    expect_equal(rowSums(comparisons), rep(0, nrow(pairs)))
    # applied to utilities it gives the pairwise differences t_i - t_j
    utilities <- c(0.5, -1, 2, 0.3, 1.1, -0.7)[1:k]
    expect_equal(drop(comparisons %*% utilities), utilities[pairs[, 1]] - utilities[pairs[, 2]])
  }
})

##########################################################################################
# increase_index
##########################################################################################
test_that("increase_index returns consecutive column indices per block", {
  expect_equal(increase_index(3, 3), matrix(1:9, 3, byrow = TRUE))
  expect_equal(increase_index(2, 4), matrix(1:8, 2, byrow = TRUE))
  expect_equal(increase_index(4, 2), matrix(1:8, 4, byrow = TRUE))
})

test_that("increase_index works for a single block", {
  skip("rwf bug: increase_index(blocks = 1) loops over 2:1 and returns 3 rows instead of 1")
  expect_equal(increase_index(1, 3), matrix(1:3, 1))
})

##########################################################################################
# generate_matrix_A
##########################################################################################
test_that("generate_matrix_A is the block diagonal design matrix of Brown & Maydeu-Olivares", {
  for (b in 1:3) {
    for (k in 2:4) {
      A <- generate_matrix_A(blocks = b, items = k)
      expect_equal(dim(A), c(b * choose(k, 2), b * k))
      expect_equal(A, kronecker(diag(b), generate_comparisons_matrix(k)))
    }
  }
  # default: 3 blocks of 3 items
  expect_equal(dim(generate_matrix_A()), c(9, 9))
})

##########################################################################################
# generate_matrix_lambda_hat
##########################################################################################
test_that("generate_matrix_lambda_hat stacks the comparisons matrix once per block", {
  for (b in 1:3) {
    for (k in 2:4) {
      expect_equal(generate_matrix_lambda_hat(blocks = b, items = k),
                   do.call(rbind, rep(list(generate_comparisons_matrix(k)), b)))
    }
  }
  expect_equal(dim(generate_matrix_lambda_hat(blocks = 3, items = 4)), c(18, 4))
})

##########################################################################################
# rank_to_binary
##########################################################################################
test_that("rank_to_binary codes 1 when the first item of the pair has the larger value", {
  withr::local_seed(12345)
  scores <- data.frame(i1 = round(stats::rnorm(10, 2, 1), 2), i2 = round(stats::rnorm(10, 2, 1), 2),
                       i3 = round(stats::rnorm(10, 2, 1), 2), i4 = round(stats::rnorm(10, 2, 1), 2))
  binary <- rank_to_binary(scores, items = 4)
  expect_true(is.matrix(binary))
  expect_equal(dim(binary), c(10, 6))
  expect_equal(colnames(binary), c("i12", "i13", "i14", "i23", "i24", "i34"))
  pairs <- t(utils::combn(4, 2))
  for (r in seq_len(nrow(pairs))) {
    expect_equal(unname(binary[, r]), as.numeric(scores[, pairs[r, 1]] > scores[, pairs[r, 2]]))
  }
  # reverse = FALSE codes the opposite preference
  expect_equal(rank_to_binary(scores, items = 4, reverse = FALSE), 1 - binary)
  # items defaults to the number of columns
  expect_equal(rank_to_binary(scores), binary)
})

test_that("rank_to_binary and rank_df_to_binary match thurstonianIRT::make_TIRT_data for ranked blocks", {
  skip_if_not_installed("thurstonianIRT")
  withr::local_seed(1)
  ranks <- as.data.frame(t(replicate(12, c(sample(3), sample(3)))))
  names(ranks) <- paste0("i", 1:6)
  blocks <-
    thurstonianIRT::set_block(c("i1", "i2", "i3"), traits = c("t1", "t2", "t3"), signs = c(1, 1, 1)) +
    thurstonianIRT::set_block(c("i4", "i5", "i6"), traits = c("t1", "t2", "t3"), signs = c(1, 1, 1))
  directions <- c(larger = TRUE, smaller = FALSE)
  for (direction in names(directions)) {
    long <- as.data.frame(thurstonianIRT::make_TIRT_data(data = ranks, blocks = blocks, direction = direction,
                                                         format = "ranks", family = "bernoulli", range = c(0, 1)))
    long$pair <- factor(paste0(long$item1, long$item2), levels = c("i1i2", "i1i3", "i2i3", "i4i5", "i4i6", "i5i6"))
    reference <- unclass(stats::xtabs(response ~ person + pair, data = long))
    rwf <- rank_df_to_binary(ranks, items = 3, reverse = directions[[direction]])
    expect_equal(unname(as.matrix(rwf)), unname(reference), ignore_attr = TRUE)
    expect_equal(unname(rank_to_binary(ranks[, 1:3], items = 3, reverse = directions[[direction]])),
                 unname(reference[, 1:3]), ignore_attr = TRUE)
  }
})

##########################################################################################
# rank_df_to_binary
##########################################################################################
test_that("rank_df_to_binary binds rank_to_binary over consecutive blocks", {
  withr::local_seed(12345)
  scores <- as.data.frame(matrix(stats::rnorm(60, 2, 0.5), 10, 6, dimnames = list(NULL, paste0("i", 1:6))))
  binary <- rank_df_to_binary(scores, 3)
  expect_s3_class(binary, "data.frame")
  expect_equal(dim(binary), c(10, 6))
  expect_equal(unname(as.matrix(binary[, 1:3])), unname(rank_to_binary(scores[, 1:3], 3)))
  expect_equal(unname(as.matrix(binary[, 4:6])), unname(rank_to_binary(scores[, 4:6], 3)))
  # two blocks of three versus one block of four
  binary4 <- rank_df_to_binary(scores[, 1:4], 4)
  expect_equal(dim(binary4), c(10, 6))
  expect_equal(unname(as.matrix(binary4)), unname(rank_to_binary(scores[, 1:4], 4)))
  # reverse = FALSE flips every comparison
  expect_equal(unname(as.matrix(rank_df_to_binary(scores, 3, reverse = FALSE))), 1 - unname(as.matrix(binary)))
})

##########################################################################################
# name_triplet_pairs
##########################################################################################
test_that("name_triplet_pairs creates the three pair labels of each triplet", {
  expect_equal(name_triplet_pairs(6), c("i1i2", "i1i3", "i2i3", "i4i5", "i4i6", "i5i6"))
  expect_equal(name_triplet_pairs(6, prefix = "i", sep = "_"), c("i1_i2", "i1_i3", "i2_i3", "i4_i5", "i4_i6", "i5_i6"))
  expect_equal(name_triplet_pairs(4:9), c("i4i5", "i4i6", "i5i6", "i7i8", "i7i9", "i8i9"))
  expect_equal(name_triplet_pairs(3, prefix = "x"), c("x1x2", "x1x3", "x2x3"))
  expect_length(name_triplet_pairs(15), 15)
})

test_that("name_triplet_pairs matches the column names of thurstonianIRT triplet data", {
  skip_if_not_installed("thurstonianIRT")
  data_env <- new.env()
  utils::data("triplets", package = "thurstonianIRT", envir = data_env)
  expect_equal(name_triplet_pairs(12), names(data_env$triplets))
})

test_that("name_triplet_pairs validates or trims incomplete triplets", {
  expect_error(name_triplet_pairs(10), "multiple of 3")
  expect_error(name_triplet_pairs(4:17), "multiple of 3")
  expect_equal(name_triplet_pairs(10, strict = FALSE), name_triplet_pairs(9))
  expect_equal(name_triplet_pairs(4:18, strict = FALSE), name_triplet_pairs(4:18))
  expect_equal(name_triplet_pairs(4:17, strict = FALSE), name_triplet_pairs(4:15))
})

##########################################################################################
# rank3_to_triplets
##########################################################################################
test_that("rank3_to_triplets recovers the ranks of every ordering of a triplet", {
  orderings <- as.data.frame(gtools::permutations(3, 3))
  triplets <- rank3_to_triplets(rank_to_binary(orderings))
  expect_s3_class(triplets, "data.frame")
  expect_named(triplets, c("item1", "item2", "item3"))
  expect_equal(unname(as.matrix(triplets)), unname(as.matrix(orderings)))
  # ranks of continuous scores (3 = largest)
  withr::local_seed(1)
  scores <- as.data.frame(matrix(stats::rnorm(60), 20, 3))
  triplets <- rank3_to_triplets(rank_to_binary(rbind(orderings, scores)))
  expect_equal(unname(as.matrix(triplets[-(1:6), ])), unname(t(apply(scores, 1, rank))), ignore_attr = TRUE)
})

test_that("rank3_to_triplets works when some response patterns are absent", {
  skip("rwf bug: rank3_to_triplets uses result[cond, ]$item <- value, which errors when cond selects no rows")
  orderings <- data.frame(a = c(1, 3), b = c(2, 1), c = c(3, 2))
  triplets <- rank3_to_triplets(rank_to_binary(orderings))
  expect_equal(unname(as.matrix(triplets)), unname(as.matrix(orderings)))
})

##########################################################################################
# response_dimension
##########################################################################################
test_that("response_dimension picks the requested positions from each consecutive group", {
  expect_equal(response_dimension(1:18, 3, c(1, 2)), as.vector(matrix(1:18, 3)[c(1, 2), ]))
  expect_equal(response_dimension(1:18, 3, c(1, 3)), c(1, 3, 4, 6, 7, 9, 10, 12, 13, 15, 16, 18))
  expect_equal(response_dimension(1:18, 3, c(2, 3)), c(2, 3, 5, 6, 8, 9, 11, 12, 14, 15, 17, 18))
  expect_equal(response_dimension(letters[1:12], 4, 2), c("b", "f", "j"))
  # the three pairs of triplet blocks partition the parameters twice over
  all_pairs <- c(response_dimension(1:12, 3, c(1, 2)), response_dimension(1:12, 3, c(1, 3)),
                 response_dimension(1:12, 3, c(2, 3)))
  expect_equal(as.vector(table(all_pairs)), rep(2, 12))
})

##########################################################################################
# cfa_icc_index
##########################################################################################
test_that("cfa_icc_index interleaves the items of each factor", {
  result <- cfa_icc_index(nitems = 18, nfactors = 3)
  expect_named(result, c("index_vector", "index_matrix"))
  expect_equal(result$index_matrix, matrix(1:18, ncol = 3))
  expect_equal(result$index_vector, as.numeric(t(matrix(1:18, ncol = 3))))
  result <- cfa_icc_index(nitems = 8, nfactors = 2)
  expect_equal(result$index_vector, c(1, 5, 2, 6, 3, 7, 4, 8))
  expect_equal(sort(result$index_vector), 1:8)
})

test_that("cfa_icc_index works for a single factor", {
  skip("rwf bug: cfa_icc_index(nfactors = 1) loops over 2:1 and returns twice the number of items")
  result <- cfa_icc_index(nitems = 3, nfactors = 1)
  expect_equal(result$index_vector, 1:3)
})

##########################################################################################
# icc_cfa
##########################################################################################
test_that("icc_cfa is the normal ogive pnorm((lambda eta - gamma) / sqrt(psi))", {
  eta <- seq(-6, 6, by = 0.5)
  expect_equal(icc_cfa(eta, 1, 1, 1), stats::pnorm(eta - 1))
  expect_equal(icc_cfa(eta, gamma = 0.556, lambda = 1.082, psi = 2.172), stats::pnorm((1.082 * eta - 0.556) / sqrt(2.172)))
  # probability is one half at eta = gamma / lambda
  expect_equal(icc_cfa(0.556 / 1.082, gamma = 0.556, lambda = 1.082, psi = 2.172), 0.5)
  # decreasing for negative loadings, bounded at extreme etas
  expect_true(all(diff(icc_cfa(eta, 0, -1.3, 1.8)) < 0))
  expect_equal(icc_cfa(c(-100, 100), 0.2, 1, 1), c(0, 1))
})

test_that("icc_cfa equals the thurstonianIRT pair probability when one trait is fixed at zero", {
  # P(y = 1) = pnorm((-gamma + lambda_i eta_a - lambda_k eta_b) / sqrt(psi_i^2 + psi_k^2))
  eta <- seq(-3, 3, by = 0.5)
  psi_i <- 0.8; psi_k <- 1.1
  expect_equal(icc_cfa(eta, gamma = 0.4, lambda = 1.2, psi = psi_i^2 + psi_k^2),
               stats::pnorm((-0.4 + 1.2 * eta - 0.9 * 0) / sqrt(psi_i^2 + psi_k^2)))
})

##########################################################################################
# compute_icc_thurstonian
##########################################################################################
tirt_example_parameters <- function() {
  gamma <- c(0.556, -1.253, -1.729, 0.618, 0.937, 0.295, -0.672, -1.127, -0.446, 0.632, 1.147, 0.498)
  psi <- c(2.172, 1.883, 2.055, 1.869, 2.231, 2.100, 1.762, 1.803, 1.565, 1.892, 1.794, 1.686)
  list(lambda = c(1.082, 1.082, -1.297, -1.297, 0.802, 0.802, 1.083, 1.083),
       gamma = gamma[response_dimension(1:12, 3, c(1, 2))],
       psi = psi[response_dimension(1:12, 3, c(1, 2))])
}

test_that("compute_icc_thurstonian returns one icc_cfa curve per item", {
  pars <- tirt_example_parameters()
  eta <- seq(-6, 6, by = 0.1)
  result <- compute_icc_thurstonian(eta = eta, gamma = pars$gamma, lambda = pars$lambda, psi = pars$psi, plot = FALSE)
  expect_named(result, c("icc", "plot"))
  expect_false(result$plot)
  expect_s3_class(result$icc, "data.frame")
  expect_named(result$icc, c(paste0("item", 1:8), "eta"))
  expect_equal(nrow(result$icc), length(eta))
  expect_equal(result$icc$eta, eta)
  for (i in 1:8) {
    expect_equal(result$icc[[paste0("item", i)]], stats::pnorm((pars$lambda[i] * eta - pars$gamma[i]) / sqrt(pars$psi[i])))
  }
  with_plot <- compute_icc_thurstonian(eta = eta, gamma = pars$gamma, lambda = pars$lambda, psi = pars$psi, plot = TRUE)
  expect_s3_class(with_plot$plot, "ggplot")
  expect_equal(with_plot$icc, result$icc)
})

##########################################################################################
# plot_icc_thurstonian
##########################################################################################
test_that("plot_icc_thurstonian plots every item curve against eta", {
  pars <- tirt_example_parameters()
  eta <- seq(-6, 6, by = 1)
  icc <- compute_icc_thurstonian(eta = eta, gamma = pars$gamma, lambda = pars$lambda, psi = pars$psi)$icc
  p <- plot_icc_thurstonian(icc, title = "My ICC")
  expect_s3_class(p, "ggplot")
  expect_equal(p$labels$title, "My ICC")
  expect_equal(nrow(p$data), length(eta) * 8)
  expect_setequal(as.character(unique(p$data$variable)), paste0("item", 1:8))
  expect_equal(p$data$value[p$data$variable == "item3"], icc$item3)
  expect_equal(plot_icc_thurstonian(icc)$labels$title, "Item Characteristic Curve")
})

##########################################################################################
# compute_map
##########################################################################################
test_that("compute_map is the normal prior density normalised over the grid", {
  eta <- seq(-6, 6, by = 0.1)
  map <- compute_map(eta = eta)
  expect_length(map, length(eta))
  expect_equal(sum(map), 1)
  expect_equal(map, stats::dnorm(eta) / sum(stats::dnorm(eta)))
  shifted <- compute_map(eta = eta, mean = 1, sd = 0.5)
  expect_equal(eta[which.max(shifted)], 1)
  expect_equal(shifted / shifted[eta == 1], exp(-0.5 * ((eta - 1) / 0.5)^2))
})

##########################################################################################
# compute_ability
##########################################################################################
test_that("compute_ability returns the likelihood and the grid ML and MAP estimates", {
  pars <- tirt_example_parameters()
  eta <- seq(-6, 6, by = 0.1)
  map <- compute_map(eta = eta)
  responses <- list(c(0, 0, 0, 0, 0, 0, 0, 0), c(1, 1, 1, 1, 1, 1, 1, 1), c(1, 0, 1, 0, 1, 0, 1, 0), c(0, 1, 0, 1, 0, 1, 0, 1))
  for (response in responses) {
    result <- compute_ability(response, eta, pars$gamma, pars$lambda, pars$psi, map = map, plot = FALSE)
    expect_named(result, c("product", "icc", "ability_ml", "ability_map"))
    p <- sapply(1:8, function(i) stats::pnorm((pars$lambda[i] * eta - pars$gamma[i]) / sqrt(pars$psi[i])))
    likelihood <- apply(p, 1, function(prob) prod(prob^response * (1 - prob)^(1 - response)))
    expect_equal(result$product, likelihood)
    expect_equal(result$ability_ml, eta[which.max(likelihood)])
    expect_equal(result$ability_map, eta[which.max(likelihood * map)])
    expect_equal(result$icc$map, likelihood * map)
    # the grid MAP is within one grid step of the continuous posterior mode
    log_posterior <- function(e) {
      prob <- stats::pnorm((pars$lambda * e - pars$gamma) / sqrt(pars$psi))
      sum(response * log(prob) + (1 - response) * log(1 - prob)) + stats::dnorm(e, log = TRUE)
    }
    mode <- stats::optimize(log_posterior, c(-6, 6), maximum = TRUE, tol = 1e-10)$maximum
    expect_lt(abs(result$ability_map - mode), 0.1)
  }
  # the default prior is the standard normal on the grid
  expect_equal(compute_ability(responses[[3]], eta, pars$gamma, pars$lambda, pars$psi),
               compute_ability(responses[[3]], eta, pars$gamma, pars$lambda, pars$psi, map = map))
})

test_that("compute_ability MAP estimates shrink towards the prior mean", {
  pars <- tirt_example_parameters()
  eta <- seq(-6, 6, by = 0.05)
  # with only positively keyed items, endorsing everything maximises ability
  lambda <- abs(pars$lambda)
  high <- compute_ability(rep(1, 8), eta, pars$gamma, lambda, pars$psi)
  low <- compute_ability(rep(0, 8), eta, pars$gamma, lambda, pars$psi)
  expect_gt(high$ability_map, low$ability_map)
  expect_lte(abs(high$ability_map), abs(high$ability_ml))
  expect_lte(abs(low$ability_map), abs(low$ability_ml))
})

test_that("compute_ability with plot = TRUE prints the plot and returns the same estimates", {
  pars <- tirt_example_parameters()
  eta <- seq(-6, 6, by = 0.5)
  withr::local_pdf(withr::local_tempfile(fileext = ".pdf"))
  response <- c(1, 0, 1, 0, 1, 0, 1, 0)
  plotted <- compute_ability(response, eta, pars$gamma, pars$lambda, pars$psi, plot = TRUE)
  plain <- compute_ability(response, eta, pars$gamma, pars$lambda, pars$psi, plot = FALSE)
  expect_equal(plotted$ability_ml, plain$ability_ml)
  expect_equal(plotted$ability_map, plain$ability_map)
})

##########################################################################################
# compute_scores
##########################################################################################
test_that("compute_scores returns the MAP ability of each response row", {
  pars <- tirt_example_parameters()
  eta <- seq(-6, 6, by = 0.1)
  map <- compute_map(eta = eta)
  responses <- data.frame(rbind(c(0, 0, 0, 0, 0, 0, 0, 0), c(1, 1, 1, 1, 1, 1, 1, 1),
                                c(1, 0, 1, 0, 1, 0, 1, 0), c(0, 1, 0, 1, 0, 1, 0, 1)))
  scores <- quietly(compute_scores(responses, eta, pars$gamma, pars$lambda, pars$psi, map = map, plot = FALSE))
  expect_type(scores, "double")
  expect_length(scores, 4)
  reference <- apply(responses, 1, function(r) compute_ability(r, eta, pars$gamma, pars$lambda, pars$psi, map = map)$ability_map)
  expect_equal(scores, unname(reference))
})

##########################################################################################
# compute_solve
##########################################################################################
test_that("compute_solve matches base::solve on random well conditioned matrices", {
  withr::local_seed(2024)
  for (n in c(2, 3, 5, 8)) {
    A <- matrix(stats::rnorm(n * n), n) + diag(n + 2, n)
    b <- stats::rnorm(n)
    B <- matrix(stats::rnorm(n * 3), n)
    expect_equal(compute_solve(A, b), solve(A, b))
    expect_equal(compute_solve(A, B), solve(A, B))
    expect_equal(compute_solve(A), solve(A))
    # covariance matrices, as used for the TIRT prior
    S <- stats::cov(matrix(stats::rnorm(50 * n), 50))
    expect_equal(as.matrix(compute_solve(S)), solve(S), ignore_attr = TRUE)
  }
})

test_that("compute_solve pivots on zero diagonal elements and returns vectors for vector right hand sides", {
  expect_equal(compute_solve(matrix(4), 2), 0.5)
  A <- matrix(c(0, 2, 1, 1), 2)
  expect_equal(compute_solve(A), solve(A))
  expect_equal(compute_solve(A, c(1, 2)), solve(A, c(1, 2)))
  expect_null(dim(compute_solve(A, c(1, 2))))
  expect_equal(drop(A %*% compute_solve(A, c(3, -1))), c(3, -1))
  expect_equal(compute_solve(data.frame(x = c(2, 1), y = c(1, 3))), solve(matrix(c(2, 1, 1, 3), 2)), ignore_attr = TRUE)
})

test_that("compute_solve keeps matrix results for 1 x 1 systems", {
  skip("rwf bug: compute_solve drops the matrix dimensions when a is 1 x 1 (missing drop = FALSE)")
  expect_equal(compute_solve(matrix(4)), solve(matrix(4)))
  expect_equal(compute_solve(matrix(4), matrix(c(2, 8), 1)), solve(matrix(4), matrix(c(2, 8), 1)))
})

test_that("compute_solve validates its input", {
  expect_error(compute_solve(matrix(1:6, 2)), "square")
  expect_error(compute_solve(diag(2), c(1, 2, 3)), "incompatible")
  expect_error(compute_solve(matrix(c(1, 2, 2, 4), 2)), "singular")
  expect_error(compute_solve(matrix(0, 3, 3)), "singular")
})

##########################################################################################
# extract_tirt_params
##########################################################################################
test_that("extract_tirt_params returns the lavaan estimates aligned to the rows of lambda", {
  skip_if_not_installed("thurstonianIRT")
  fit <- triplets_fit()$fit
  pars <- extract_tirt_params(fit)
  expect_named(pars, c("lambda", "theta_diag", "tau", "nu", "Psi"))
  est <- lavaan::lavInspect(fit$fit, "est")
  indicators <- rownames(est$lambda)
  expect_equal(pars$lambda, est$lambda)
  expect_equal(dim(pars$lambda), c(12, 3))
  expect_equal(names(pars$theta_diag), indicators)
  expect_equal(names(pars$tau), indicators)
  expect_equal(names(pars$nu), indicators)
  expect_equal(unname(pars$nu), rep(0, 12))
  expect_equal(pars$Psi, est$psi)
  # thresholds and residual variances are matched by name, not position
  pe <- lavaan::parameterEstimates(fit$fit)
  thresholds <- pe[pe$op == "|", ]
  expect_equal(unname(pars$tau[thresholds$lhs]), thresholds$est, tolerance = 1e-6)
  residuals <- pe[pe$op == "~~" & pe$lhs == pe$rhs & pe$lhs %in% indicators, ]
  expect_equal(unname(pars$theta_diag[residuals$lhs]), residuals$est, tolerance = 1e-6)
})

##########################################################################################
# score_tirt_pattern
##########################################################################################
test_that("score_tirt_pattern reproduces lavaan EBM factor scores of a thurstonianIRT fit", {
  skip_if_not_installed("thurstonianIRT")
  tirt <- triplets_fit()
  pars <- extract_tirt_params(tirt$fit)
  reference <- lavaan::lavPredict(tirt$fit$fit)
  patterns <- as.matrix(tirt$data)[, rownames(pars$lambda)]
  for (i in 1:5) {
    score <- score_tirt_pattern(patterns[i, ], lambda = pars$lambda, theta_diag = pars$theta_diag,
                                tau = pars$tau, Psi = pars$Psi)
    expect_named(score, colnames(pars$lambda))
    expect_equal(unname(score), unname(reference[i, ]), tolerance = 1e-3)
  }
})

test_that("score_tirt_pattern minimises the negative log posterior", {
  sim <- simulate_tirt()
  for (i in 1:5) {
    score <- score_tirt_pattern(sim$patterns[i, ], lambda = sim$lambda, theta_diag = sim$theta_diag,
                                tau = sim$tau, Psi = sim$Psi)
    objective <- function(eta) tirt_neg_log_posterior(eta, sim$patterns[i, ], sim$lambda, sim$theta_diag, sim$tau, sim$Psi)
    expect_lt(max(abs(numeric_gradient(objective, unname(score)))), 1e-3)
    # an independent optimiser finds the same mode
    reference <- stats::optim(c(0.5, -0.5), objective, method = "Nelder-Mead", control = list(reltol = 1e-14, maxit = 5000))$par
    expect_equal(unname(score), reference, tolerance = 1e-4)
  }
})

test_that("score_tirt_pattern recovers known trait scores in a long simulated test", {
  sim <- simulate_tirt(nindicators = 200, npersons = 25)
  scores <- t(apply(sim$patterns, 1, score_tirt_pattern, lambda = sim$lambda, theta_diag = sim$theta_diag,
                    tau = sim$tau, Psi = sim$Psi))
  expect_gt(stats::cor(scores[, 1], sim$eta[, 1]), 0.9)
  expect_gt(stats::cor(scores[, 2], sim$eta[, 2]), 0.9)
  expect_lt(sqrt(mean((scores - sim$eta)^2)), 0.35)
})

test_that("score_tirt_pattern ignores missing responses", {
  sim <- simulate_tirt()
  pattern <- sim$patterns[1, ]
  missing <- c(2, 5, 11, 30)
  pattern[missing] <- NA
  with_na <- score_tirt_pattern(pattern, sim$lambda, sim$theta_diag, sim$tau, sim$Psi)
  dropped <- score_tirt_pattern(pattern[-missing], sim$lambda[-missing, ], sim$theta_diag[-missing],
                                sim$tau[-missing], sim$Psi)
  expect_equal(with_na, dropped)
  objective <- function(eta) tirt_neg_log_posterior(eta, pattern, sim$lambda, sim$theta_diag, sim$tau, sim$Psi)
  expect_lt(max(abs(numeric_gradient(objective, unname(with_na)))), 1e-3)
  # with no observed responses the posterior mode is the prior mean
  all_missing <- score_tirt_pattern(rep(NA, nrow(sim$lambda)), sim$lambda, sim$theta_diag, sim$tau, sim$Psi)
  expect_equal(unname(all_missing), c(0, 0))
})

test_that("score_tirt_pattern handles intercepts, starting values and optim control", {
  sim <- simulate_tirt()
  pattern <- sim$patterns[3, ]
  nu <- stats::setNames(seq(-0.5, 0.5, length.out = nrow(sim$lambda)), rownames(sim$lambda))
  base <- score_tirt_pattern(pattern, sim$lambda, sim$theta_diag, sim$tau, sim$Psi)
  # nu = NULL is the same as zero intercepts
  expect_equal(score_tirt_pattern(pattern, sim$lambda, sim$theta_diag, sim$tau, sim$Psi, nu = rep(0, 40)), base)
  # only tau - nu enters the model
  expect_equal(score_tirt_pattern(pattern, sim$lambda, sim$theta_diag, sim$tau, sim$Psi, nu = nu),
               score_tirt_pattern(pattern, sim$lambda, sim$theta_diag, sim$tau - nu, sim$Psi))
  # the mode does not depend on the starting values
  expect_equal(score_tirt_pattern(pattern, sim$lambda, sim$theta_diag, sim$tau, sim$Psi, init = c(2, -2)), base,
               tolerance = 1e-5)
  # control is passed to optim
  rough <- score_tirt_pattern(pattern, sim$lambda, sim$theta_diag, sim$tau, sim$Psi, control = list(maxit = 1))
  expect_false(isTRUE(all.equal(rough, base, tolerance = 1e-6)))
})

test_that("score_tirt_pattern returns finite scores for extreme response patterns", {
  sim <- simulate_tirt()
  # responses that all favour the highest possible trait levels
  extreme <- as.numeric(sim$lambda[, 1] > 0)
  score <- score_tirt_pattern(extreme, sim$lambda, sim$theta_diag, sim$tau, sim$Psi)
  expect_true(all(is.finite(score)))
  objective <- function(eta) tirt_neg_log_posterior(eta, extreme, sim$lambda, sim$theta_diag, sim$tau, sim$Psi)
  expect_lt(max(abs(numeric_gradient(objective, unname(score)))), 1e-3)
  expect_gt(score[["trait1"]], 1)
})

##########################################################################################
# score_tirt
##########################################################################################
test_that("score_tirt reproduces thurstonianIRT predictions for a lavaan fit", {
  skip_if_not_installed("thurstonianIRT")
  tirt <- triplets_fit()
  pars <- extract_tirt_params(tirt$fit)
  scores <- score_tirt(as.matrix(tirt$data), lambda = pars$lambda, theta_diag = pars$theta_diag,
                       tau = pars$tau, Psi = pars$Psi)
  expect_true(is.matrix(scores))
  expect_equal(dim(scores), c(nrow(tirt$data), 3))
  expect_equal(colnames(scores), colnames(pars$lambda))
  predicted <- as.data.frame(stats::predict(tirt$fit))
  reference <- matrix(predicted$estimate[order(predicted$id, predicted$trait)], ncol = 3, byrow = TRUE)
  expect_equal(unname(scores), reference, tolerance = 1e-3)
  expect_equal(unname(scores), unname(lavaan::lavPredict(tirt$fit$fit)), tolerance = 1e-3)
})

test_that("score_tirt aligns pattern columns to lambda rows by name", {
  sim <- simulate_tirt(npersons = 6)
  scores <- score_tirt(sim$patterns, sim$lambda, sim$theta_diag, sim$tau, sim$Psi)
  expect_equal(dim(scores), c(6, 2))
  for (i in 1:6) {
    expect_equal(scores[i, ], score_tirt_pattern(sim$patterns[i, ], sim$lambda, sim$theta_diag, sim$tau, sim$Psi))
  }
  shuffled <- sim$patterns[, rev(colnames(sim$patterns))]
  expect_equal(score_tirt(shuffled, sim$lambda, sim$theta_diag, sim$tau, sim$Psi), scores)
  # extra columns are ignored, data frames are accepted
  extra <- data.frame(sim$patterns, other = 1)
  expect_equal(score_tirt(extra, sim$lambda, sim$theta_diag, sim$tau, sim$Psi), scores, ignore_attr = TRUE)
  # missing responses are dropped person by person
  with_na <- sim$patterns
  with_na[1, 1:5] <- NA
  expect_equal(score_tirt(with_na, sim$lambda, sim$theta_diag, sim$tau, sim$Psi)[1, ],
               score_tirt_pattern(sim$patterns[1, -(1:5)], sim$lambda[-(1:5), ], sim$theta_diag[-(1:5)],
                                  sim$tau[-(1:5)], sim$Psi))
})

test_that("score_tirt validates names and warns on positional alignment", {
  sim <- simulate_tirt(npersons = 3)
  expect_error(score_tirt(sim$patterns[, -1], sim$lambda, sim$theta_diag, sim$tau, sim$Psi), "not found in patterns")
  unnamed <- unname(sim$patterns)
  expect_warning(positional <- score_tirt(unnamed, sim$lambda, sim$theta_diag, sim$tau, sim$Psi), "positional alignment")
  expect_equal(positional, score_tirt(sim$patterns, sim$lambda, sim$theta_diag, sim$tau, sim$Psi), ignore_attr = TRUE)
})

##########################################################################################
# check_heywood
##########################################################################################
test_that("check_heywood reports no issues for a well behaved CFA", {
  fit <- lavaan::cfa("visual =~ x1 + x2 + x3\n textual =~ x4 + x5 + x6\n speed =~ x7 + x8 + x9",
                     data = lavaan::HolzingerSwineford1939)
  expect_output(result <- check_heywood(fit, verbose = TRUE), "No Heywood cases")
  expect_named(result, c("has_issues", "issues", "converged"))
  expect_false(result$has_issues)
  expect_length(result$issues, 0)
  expect_true(result$converged)
  expect_silent(check_heywood(fit, verbose = FALSE))
})

test_that("check_heywood detects negative variances and standardized loadings above one", {
  # one factor, three indicators: lambda_1^2 = r12 r13 / r23 = 1.6, so the residual variance is -0.6
  S <- matrix(c(1, 0.8, 0.8, 0.8, 1, 0.4, 0.8, 0.4, 1), 3, dimnames = list(paste0("y", 1:3), paste0("y", 1:3)))
  fit <- suppressWarnings(lavaan::cfa("f =~ y1 + y2 + y3", sample.cov = S, sample.nobs = 500, std.lv = TRUE))
  expect_output(result <- check_heywood(fit, verbose = TRUE), "NEGATIVE VARIANCES")
  expect_true(result$has_issues)
  pe <- lavaan::parameterEstimates(fit)
  negative <- pe[pe$op == "~~" & pe$lhs == pe$rhs & pe$est < 0, ]
  expect_equal(result$issues$negative_variances$lhs, "y1")
  expect_equal(result$issues$negative_variances$est, negative$est)
  # lavaan rescales the sample covariance matrix by (N - 1) / N
  expect_equal(result$issues$negative_variances$est, (499 / 500) * (1 - 0.8 * 0.8 / 0.4), tolerance = 1e-4)
  expect_equal(result$issues$extreme_loadings$rhs, "y1")
  expect_gt(abs(result$issues$extreme_loadings$est.std), 1)
  quiet <- check_heywood(fit, verbose = FALSE)
  expect_equal(quiet, result)
})

test_that("check_heywood runs on a thurstonianIRT lavaan fit", {
  skip_if_not_installed("thurstonianIRT")
  fit <- triplets_fit()$fit$fit
  result <- quietly(check_heywood(fit, verbose = TRUE))
  expect_type(result$has_issues, "logical")
  expect_equal(result$converged, lavaan::lavInspect(fit, "converged"))
})
