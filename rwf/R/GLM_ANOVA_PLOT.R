##########################################################################################
# PLOT ONE WAY ANOVA
##########################################################################################
#' @title Plot group means with error bars for all IV-DV combinations
#' @description For every combination of independent variable (IV) and dependent
#'   variable (DV) supplied, produces a horizontal dot plot of group means with
#'   optional error bars (standard error, confidence interval, or standard
#'   deviation). Sample size per group is annotated on each panel.
#'
#'   When the number of IV-DV combinations exceeds four times the available CPU
#'   cores the plots are produced in parallel via \code{future.apply}, otherwise
#'   sequentially.
#'
#' @param df A data frame containing both the independent and dependent
#'   variables.
#' @param dv Integer vector of column indices for the continuous dependent
#'   variables.
#' @param iv Integer vector of column indices for the categorical independent
#'   variables. Columns are coerced to factors automatically.
#' @param base_size Base font size in pt passed to \code{theme_bw}. Default
#'   \code{20}.
#' @param type Type of error bar to display. One of \code{"se"} (standard
#'   error), \code{"ci"} (95\% confidence interval), \code{"sd"} (standard
#'   deviation), or \code{""} (no error bars). Default \code{"se"}.
#' @param order_factor Logical. If \code{TRUE} factor levels on the x-axis are
#'   sorted by the group mean of the DV (descending). Default \code{TRUE}.
#' @param title Character. Plot title applied to every panel. Default \code{""}.
#' @param note Character. Caption / footnote appended to every panel. Default
#'   \code{""}.
#' @param width Integer. Character width at which long axis labels are wrapped.
#'   Default \code{60}.
#'
#' @return A named list with three elements:
#'   \itemize{
#'     \item \code{plot_data} — named list of summary data frames (one per
#'       IV-DV pair) as returned by \code{Rmisc::summarySE}.
#'     \item \code{plot_data_df} — single data frame combining all summary
#'       data frames row-wise.
#'     \item \code{plots} — named list of ggplot objects (one per IV-DV pair).
#'   }
#'   All list elements are named \code{"iv_dv"}.
#'
#' @import ggplot2
#' @importFrom future plan multisession sequential
#' @importFrom future.apply future_lapply
#' @importFrom Rmisc summarySE
#' @importFrom scales wrap_format
#' @importFrom ggpubr as_ggplot
#' @importFrom gridExtra arrangeGrob
#' @importFrom plyr rbind.fill
#' @importFrom parallel detectCores
#' @keywords ANOVA
#' @export
#' @examples
#' nrows <- 1000
#' df <- data.frame(
#'   generate_factor(vector = LETTERS[1:5], nrows = nrows, ncols = 10, type = "random"),
#'   generate_data(nrows = nrows, ncols = 5, type = "normal")
#' )
#' result <- plot_oneway(df = df, dv = 11:15, iv = 1:10)
#'
#' # Single IV, single DV
#' plot_oneway(df = mtcars, dv = 2, iv = 9)
#'
#' # Multiple IVs and DVs
#' plot_oneway(df = mtcars, dv = 2:3, iv = 9:10)
#'
#' # Error bar types
#' plot_oneway(df = mtcars, dv = 2:3, iv = 9:10, type = "se")
#' plot_oneway(df = mtcars, dv = 2:3, iv = 9:10, type = "ci")
#' plot_oneway(df = mtcars, dv = 2:3, iv = 9:10, type = "sd")
#' plot_oneway(df = mtcars, dv = 2:3, iv = 9:10, type = "")
#'
#' # Factor ordering
#' plot_oneway(df = mtcars, dv = 2:3, iv = 9:10, type = "", order_factor = FALSE)
#' plot_oneway(df = mtcars, dv = 2:3, iv = 9:10, type = "", order_factor = TRUE)
plot_oneway <- function(df, dv, iv, base_size = 20, type = "se", order_factor = TRUE, title = "", note = "", width = 60) {
  se <- ci <- NULL
  output_data <- function(i) {
    index <- as.character(combinations[i, ])
    tempdata <- df[complete.cases(df[, index]), index]
    if (length(unique(tempdata[, combinations$iv[i]])) > 1) {
      Rmisc::summarySE(tempdata, measurevar = combinations$dv[i], groupvars = combinations$iv[i], na.rm = TRUE)
    }
  }
  output_plot <- function(i) {
    tempdata <- plot_data[[i]]
    if (!is.null(tempdata)) {
      if (order_factor) {
        means_plot <- ggplot(tempdata, aes(x = reorder(tempdata[, 1], -tempdata[, 3]), y = tempdata[, 3]))
      } else {
        means_plot <- ggplot(tempdata, aes(x = tempdata[, 1], y = tempdata[, 3]))
      }
      means_plot <- means_plot +
        geom_point() +
        labs(
          y = str_aes(names(tempdata)[3]),
          x = str_wrap(str_aes(names(tempdata)[1]), width = width),
          title = title,
          caption = note
        ) +
        theme_bw(base_size = base_size) +
        scale_x_discrete(labels = scales::wrap_format(width)) +
        coord_flip()
      if (type == "se") {
        means_plot <- means_plot + geom_errorbar(aes(ymin = tempdata[, 3] - se, ymax = tempdata[, 3] + se), width = .1) +
          labs(caption = paste("Bars are standard errors", note))
      }
      if (type == "ci") {
        means_plot <- means_plot + geom_errorbar(aes(ymin = tempdata[, 3] - ci, ymax = tempdata[, 3] + ci), width = .1) +
          labs(caption = paste("Bars are confidence intervals", note))
      }
      if (type == "sd") {
        means_plot <- means_plot + geom_errorbar(aes(ymin = tempdata[, 3] - sd, ymax = tempdata[, 3] + sd), width = .1) +
          labs(caption = paste("Bars are standard deviations", note))
      }
      minaxis <- ggplot_build(means_plot)$layout$panel_scales_y[[1]]$range$range[[1]]
      if (!is.null(minaxis)) {
        means_plot <- means_plot + annotate("text", x = tempdata[, 1], y = minaxis, label = paste0("N:", tempdata$N), alpha = .5, size = base_size / 10 * 2, hjust = 0, vjust = 2)
      }
      ggpubr::as_ggplot(gridExtra::arrangeGrob(means_plot))
    }
  }
  
  df[, iv] <- change_data_type(data.frame(df[, iv]), "factor")
  combinations <- expand.grid(names(df)[iv], names(df)[dv])
  names(combinations) <- c("iv", "dv")
  row.names(combinations) <- paste0(combinations$iv, "_", combinations$dv)
  combinations <- change_data_type(combinations, type = "character")
  
  n_rows <- nrow(combinations)
  n_cores <- parallel::detectCores()
  use_parallel <- n_cores * 4 < n_rows
  
  if (use_parallel) {
    message("Parallel processing with ", n_cores, " workers for ", n_rows, " plots")
    future::plan(future::multisession, workers = n_cores)
    plot_data <- setNames(
      future.apply::future_lapply(seq_len(n_rows), output_data, future.seed = TRUE),
      row.names(combinations)
    )
    plots <- setNames(
      future.apply::future_lapply(seq_len(n_rows), output_plot, future.seed = TRUE),
      row.names(combinations)
    )
    future::plan(future::sequential)
  } else {
    plot_data <- setNames(lapply(seq_len(n_rows), output_data), row.names(combinations))
    plots <- setNames(lapply(seq_len(n_rows), output_plot), row.names(combinations))
  }
  
  plot_data_df <- Reduce(plyr::rbind.fill, plot_data)
  names_input_missing <- setdiff(names(df)[c(iv, dv)], names(plot_data_df))
  names_input <- names(df)[c(iv, dv)]
  names_input <- names_input[!names_input %in% names_input_missing]
  plot_data_df <- plot_data_df[, c(names_input, "N", "sd", "se", "ci")]
  
  result<-list(plot_data = plot_data, plot_data_df = plot_data_df, plots = invisible(plots))
  invisible(lapply(result$plots,print))
  return(invisible(result))
}
##########################################################################################
# PLOT TWO WAY INTERACTION
##########################################################################################
#' @title Plot two-way interaction graphs for all IV pair and DV combinations
#' @description For every unique pair of independent variables (IV1 x IV2) and
#'   every dependent variable (DV), produces a line-and-point interaction plot
#'   with group means on the y-axis. IV1 levels appear on the x-axis (flipped)
#'   and IV2 levels are represented by colour and line group. Optional error
#'   bars and per-group sample size annotations are included.
#'
#'   When the number of combinations exceeds four times the available CPU cores
#'   the plots are produced in parallel via \code{future.apply}, otherwise
#'   sequentially.
#'
#' @inheritParams plot_oneway
#'
#' @return A named list with three elements:
#'   \itemize{
#'     \item \code{plot_data} — named list of summary data frames (one per
#'       IV1-IV2-DV combination) as returned by \code{Rmisc::summarySE}.
#'     \item \code{plot_data_df} — single data frame combining all summary
#'       data frames row-wise.
#'     \item \code{plots} — named list of ggplot objects (one per combination).
#'   }
#'   All list elements are named \code{"iv1_iv2_dv"}.
#'
#' @import ggplot2
#' @importFrom future plan multisession sequential
#' @importFrom future.apply future_lapply
#' @importFrom parallel detectCores
#' @importFrom plyr ddply numcolwise rbind.fill
#' @importFrom Rmisc summarySE
#' @importFrom scales wrap_format
#' @importFrom ggpubr as_ggplot
#' @importFrom gridExtra arrangeGrob
#' @keywords ANOVA
#' @export
#' @examples
#' # Single DV, two IVs
#' plot_interaction(df = mtcars, dv = 2, iv = 8:9, base_size = 20, type = "se")
#'
#' # Multiple DVs, two IVs
#' plot_interaction(df = mtcars, dv = 2:3, iv = 8:9, base_size = 20, type = "se")
#' plot_interaction(df = mtcars, dv = 2:3, iv = 8:9, base_size = 20, type = "ci")
#' plot_interaction(df = mtcars, dv = 2:3, iv = 9:10, base_size = 20, type = "sd")
#'
#' # No error bars, unordered factor axis
#' plot_interaction(df = mtcars, dv = 2, iv = 9:10, base_size = 20, type = "", order_factor = FALSE)
plot_interaction <- function(df, dv, iv, base_size = 20, type = "se", order_factor = TRUE, title = "", note = "") {
  se <- ci <- NULL
  output_data <- function(i) {
    factors <- c(combinations$iv1[i], combinations$iv2[i])
    cors <- combinations$dv[i]
    tempdata_complete_cases <- df[complete.cases(df[, c(factors, cors)]), c(factors, cors)]
    if (nrow(tempdata_complete_cases) > 1) {
      Rmisc::summarySE(tempdata_complete_cases, measurevar = cors, groupvars = factors, na.rm = TRUE, .drop = TRUE)
    }
  }
  output_plot <- function(i) {
    tempdata <- plot_data[[i]]
    if (!is.null(tempdata)) {
      factors <- c(combinations$iv1[i], combinations$iv2[i])
      cors <- combinations$dv[i]
      tempdata_cases <- plyr::ddply(tempdata, factors[1], plyr::numcolwise(sum, na.rm = TRUE))
      if (order_factor) {
        interactions_plot <- ggplot(tempdata, aes(
          x = reorder(tempdata[, factors[1]], -tempdata[, cors]),
          y = tempdata[, cors],
          color = str_wrap(tempdata[, factors[2]], width = 25),
          group = str_wrap(tempdata[, factors[2]], width = 25)
        ))
      } else {
        interactions_plot <- ggplot(tempdata, aes(
          x = tempdata[, factors[1]],
          y = tempdata[, cors],
          color = str_wrap(tempdata[, factors[2]], width = 25),
          group = str_wrap(tempdata[, factors[2]], width = 25)
        ))
      }
      interactions_plot <- interactions_plot +
        scale_color_discrete(breaks = c(levels(tempdata[, factors[2]])), name = factors[2]) +
        geom_line() +
        geom_point(size = 5) +
        theme_bw(base_size = base_size) +
        guides(color = guide_legend(ncol = 1)) +
        labs(
          y = str_wrap(str_aes(cors), width = 25),
          x = str_wrap(str_aes(factors[1]), width = 25),
          title = title,
          caption = note,
          color = str_wrap(str_aes(tempdata[, factors[2]]), width = 25)
        ) +
        scale_x_discrete(labels = scales::wrap_format(100)) +
        coord_flip()
      if (type == "se") {
        interactions_plot <- interactions_plot +
          geom_errorbar(aes(ymin = tempdata[, cors] - se, ymax = tempdata[, cors] + se), width = .1, position = position_dodge(0.1)) +
          labs(caption = paste("Bars are standard errors", note))
      }
      if (type == "ci") {
        interactions_plot <- interactions_plot +
          geom_errorbar(aes(ymin = tempdata[, cors] - ci, ymax = tempdata[, cors] + ci), width = .1, position = position_dodge(0.1)) +
          labs(caption = paste("Bars are confidence intervals", note))
      }
      if (type == "sd") {
        interactions_plot <- interactions_plot +
          geom_errorbar(aes(ymin = tempdata[, cors] - sd, ymax = tempdata[, cors] + sd), width = .1, position = position_dodge(0.1)) +
          labs(caption = paste("Bars are standard deviations", note))
      }
      minaxis <- ggplot_build(interactions_plot)$layout$panel_scales_y[[1]]$range$range[[1]]
      if (!is.null(minaxis)) {
        interactions_plot <- interactions_plot +
          annotate("text", x = tempdata_cases[, factors[1]], y = minaxis, label = paste("N:", tempdata_cases$N), alpha = .5, size = base_size / 10 * 2, hjust = 0, vjust = 2)
      }
      ggpubr::as_ggplot(gridExtra::arrangeGrob(interactions_plot))
    }
  }
  
  df[, iv] <- change_data_type(df[, iv], type = "factor")
  combinations <- expand.grid(names(df)[iv], names(df)[iv], names(df)[dv])
  names(combinations) <- c("iv1", "iv2", "dv")
  row.names(combinations) <- paste0(combinations$iv1, "_", combinations$iv2, "_", combinations$dv)
  combinations <- change_data_type(combinations, type = "character")
  combinations <- combinations[-which(combinations$iv1 == combinations$iv2), ]
  combinations <- combinations[!duplicated(combinations), ]
  
  n_rows <- nrow(combinations)
  n_cores <- parallel::detectCores()
  use_parallel <- n_cores * 4 < n_rows
  
  if (use_parallel) {
    message("Parallel processing with ", n_cores, " workers for ", n_rows, " plots")
    future::plan(future::multisession, workers = n_cores)
    plot_data <- setNames(
      future.apply::future_lapply(seq_len(n_rows), output_data, future.seed = TRUE),
      row.names(combinations)
    )
    plots <- setNames(
      future.apply::future_lapply(seq_len(n_rows), output_plot, future.seed = TRUE),
      row.names(combinations)
    )
    future::plan(future::sequential)
    gc(full = TRUE)
  } else {
    plot_data <- setNames(lapply(seq_len(n_rows), output_data), row.names(combinations))
    plots <- setNames(lapply(seq_len(n_rows), output_plot), row.names(combinations))
  }
  
  plot_data_df <- Reduce(plyr::rbind.fill, plot_data)
  plot_data_df <- plot_data_df[, c(names(df)[c(iv, dv)], setdiff(c("N", "sd", "se", "ci"), names(df)[c(iv, dv)]))]
  result<-list(plot_data = plot_data, plot_data_df = plot_data_df, plots = plots)
  invisible(lapply(result$plots,print))
  return(invisible(result))
}
##########################################################################################
# PLOT ANOVA DIAGNOSTICS
##########################################################################################
#' @title Diagnostic plots for one-way ANOVA models
#' @description For every combination of independent variable (IV) and dependent
#'   variable (DV), fits a linear model and produces a 6-panel diagnostic plot
#'   via \code{ggfortify::autoplot}: Residuals vs Fitted, Normal Q-Q, Scale-Location,
#'   Cook's Distance, Residuals vs Leverage, and Cook's Distance vs Leverage.
#'
#'   \strong{Interpretation:}
#'   \itemize{
#'     \item \emph{Residuals vs Fitted} — points should be randomly scattered
#'       with no pattern; a funnel shape indicates heteroscedasticity.
#'     \item \emph{Normal Q-Q} — points should follow the diagonal; large
#'       deviations indicate non-normality.
#'   }
#'
#'   When the number of IV-DV combinations exceeds four times the available CPU
#'   cores the plots are produced in parallel via \code{future.apply}, otherwise
#'   sequentially.
#'
#' @param df A data frame containing both the independent and dependent
#'   variables.
#' @param dv Integer vector of column indices for the continuous dependent
#'   variables.
#' @param iv Integer vector of column indices for the categorical independent
#'   variables.
#' @param base_size Base font size in pt passed to \code{theme_bw}. Default
#'   \code{10}.
#'
#' @return A named list of ggplot objects (one 6-panel plot per IV-DV pair),
#'   named \code{"iv_dv"}.
#'
#' @import ggplot2 ggfortify
#' @importFrom future plan multisession sequential
#' @importFrom future.apply future_lapply
#' @importFrom stats formula lm
#' @importFrom parallel detectCores
#' @keywords ANOVA
#' @export
#' @examples
#' nrows <- 1000
#' df <- data.frame(
#'   generate_factor(vector = LETTERS[1:5], nrows = nrows, ncols = 10, type = "random"),
#'   generate_data(nrows = nrows, ncols = 5, type = "normal")
#' )
#' result <- plot_oneway_diagnostics(df = df, dv = 11:15, iv = 1:10)
#'
#' # Single DV, multiple IVs
#' plot_oneway_diagnostics(df = mtcars, dv = 1, iv = 9:10)
#'
#' # Multiple DVs and IVs
#' plot_oneway_diagnostics(df = mtcars, dv = 1:2, iv = 9:10)
plot_oneway_diagnostics <- function(df, dv, iv, base_size = 10) {
  output_plot <- function(i) {
    factors <- combinations$iv[i]
    cors <- combinations$dv[i]
    tempdata <- df[complete.cases(df[, c(cors, factors)]), ]
    tempdata <- tempdata[tempdata[, factors] %in% names(table(tempdata[, factors]))[table(tempdata[, factors]) > 1], ]
    tempdata[, factors] <- factor(tempdata[, factors])
    if (length(unique(tempdata[, factors])) > 1) {
      form <- stats::formula(paste0(cors, "~", factors))
      model <- stats::lm(form, data = tempdata)
      autoplot(model, which = 1:6, ncol = 2, label.size = 3) +
        labs(caption = paste0(deparse(model$terms), "\nobservations=", nrow(model$model))) +
        theme_bw(base_size = base_size) +
        theme(axis.text.x = element_text(angle = 45, hjust = 1))
    }
  }
  
  combinations <- expand.grid(names(df)[iv], names(df)[dv])
  names(combinations) <- c("iv", "dv")
  row.names(combinations) <- paste0(combinations$iv, "_", combinations$dv)
  combinations <- change_data_type(combinations, type = "character")
  
  n_rows <- nrow(combinations)
  n_cores <- parallel::detectCores()
  use_parallel <- n_cores * 4 < n_rows
  
  if (use_parallel) {
    message("Parallel processing with ", n_cores, " workers for ", n_rows, " plots")
    future::plan(future::multisession, workers = n_cores)
    plots <- setNames(
      future.apply::future_lapply(seq_len(n_rows), output_plot, future.seed = TRUE),
      row.names(combinations)
    )
    future::plan(future::sequential)
    gc(full = TRUE)
  } else {
    plots <- setNames(lapply(seq_len(n_rows), output_plot), row.names(combinations))
  }
  invisible(lapply(plots,print))
  return(invisible(plots))
}
