##########################################################################################
# DESCRIPTIVES
##########################################################################################
#' @title Descriptive statistics
#' @description Computes a comprehensive set of descriptive statistics for one
#'   or more continuous variables, optionally stratified by one or more
#'   grouping (independent) variables. When \code{iv} is supplied the
#'   statistics are computed separately for each combination of dependent and
#'   independent variable levels. Results can be exported to an Excel file.
#' @param df A data frame containing the variables of interest.
#' @param dv Integer vector of column indices identifying the dependent
#'   (continuous) variables to summarise.
#' @param iv Integer vector of column indices identifying the independent
#'   (grouping) variables used to stratify the output. When \code{NULL}
#'   (default) the statistics are computed on the full sample.
#' @param file Character string naming the output Excel file (without
#'   extension). When \code{NULL} (default) no file is written.
#' @return A data frame with one row per variable (and per group level when
#'   \code{iv} is supplied) containing the following columns:
#'   \describe{
#'     \item{factor}{Name of the grouping variable (\code{iv} only).}
#'     \item{levels}{Level of the grouping variable (\code{iv} only).}
#'     \item{variable}{Name of the dependent variable.}
#'     \item{n}{Sample size (non-missing observations).}
#'     \item{mean}{Arithmetic mean.}
#'     \item{sd}{Standard deviation.}
#'     \item{median}{Median.}
#'     \item{trimmed}{10\% trimmed mean.}
#'     \item{mad}{Median absolute deviation.}
#'     \item{min}{Minimum observed value.}
#'     \item{max}{Maximum observed value.}
#'     \item{range}{Difference between maximum and minimum.}
#'     \item{skew}{Skewness; deviations from 0 indicate departure from symmetry.}
#'     \item{kurtosis}{Excess kurtosis; deviations from 0 indicate departure from normality.}
#'     \item{se}{Standard error of the mean.}
#'     \item{IQR}{Interquartile range (Q0.75 - Q0.25).}
#'     \item{Q0.1, Q0.25, Q0.5, Q0.75, Q0.9}{Percentiles at 10, 25, 50, 75, and 90.}
#'   }
#' @importFrom plyr rbind.fill
#' @importFrom psych describe
#' @keywords descriptives
#' @export
#' @examples
#' compute_descriptives(df = mtcars, dv = 1:5)
#' compute_descriptives(df = mtcars, dv = 1:2, iv = 9:10)
#' compute_descriptives(df = mtcars, dv = 1:2)
#' compute_descriptives(df = mtcars, dv = 1:2, iv = 9:10,
#'                      file = "descriptives_factor")
compute_descriptives <- function(df, dv, iv = NULL, file = NULL) {
  comment <- list(
    factor = "independent variable",
    levels = "levels of independent variable\n\ndiscrete variables observed in independent variable",
    variable = "dependent variable\n\ncontinous variable",
    n = "sample size",
    mean = "measure of central tendency\n\nmean",
    sd = "measure of dispersion\nstandard deviation\n\nlow values indicate low dispersion of observations from the mean",
    median = "measure of central tendency\n\nmedian\n\nvalue separating lower half from higher half of ordered observations",
    trimmed = "measure of central tendency\n\ntrimmed mean\n\nmean after dropping .1 of minimum and maximum values in data",
    mad = "measure of dispersion\n\nmedian absolute deviation\n\nlow values indicate low dispersion of observations from the median",
    min = "minimum value observed",
    max = "maximum value observed",
    range = "measure of dispersion\n\nrange\n\ndifference between minimum and maximum value",
    skew = "skewness\nnegative values indicate a left skewed distribution\n\npositive values indicate a right skewed distribution\n\ndeviations from 0 indicate deviation from normality",
    kurtosis = "kurtosis\n\nnegative values generally indicate flat peak\n\npositive values generally indicate sharp peak\n\ndeviations from 0 indicate deviation from normality",
    se = "measure of dispersion\n\nstandard error\n\nlow values indicate low dispersion of observations from the mean",
    IQR = "measure of dispersion\n\ninterquantile range\n\nthe range around the median where 50% of observations fall",
    Q0.1 = "percentile\n\n10% of observations fall bellow this value",
    Q0.25 = "percentile\n\n25% of observations fall bellow this value",
    Q0.5 = "percentile\n\n50% of observations fall bellow this value",
    Q0.75 = "percentile\n\n75% of observations fall bellow this value",
    Q0.9 = "percentile\n\n90% of observations fall bellow this value"
  )
  result_df <- data.frame()
  describe <- function(x) psych::describe(x, skew = TRUE, ranges = TRUE, check = TRUE, fast = FALSE, IQR = TRUE, quant = c(.1, .25, .5, .75, .90), na.rm = TRUE)
  if (is.null(iv)) {
    for (i in names(df)[dv]) {
      result_df <- plyr::rbind.fill(result_df, data.frame(variable = i, describe(df[, i])))
    }
  } else {
    for (i in names(df)[dv]) {
      for (y in names(df)[iv]) {
        temp <- data.frame(df[, i], df[, y])
        names(temp) <- c(i, y)
        temp <- temp[complete.cases(temp), ]
        if (nrow(temp) > 1) {
          if (is.factor(temp[, y])) {
            temp[, y] <- droplevels(temp[, y])
          }
          result <- tapply(temp[, i], temp[, y], FUN = describe)
          result <- data.frame(levels = names(result), do.call(rbind.data.frame, result))
          result_df <- plyr::rbind.fill(result_df, data.frame(factor = y, variable = i, result, row.names = NULL, check.names = FALSE))
        }
      }
    }
  }
  result_df$vars <- NULL
  report_dataframe(result_df, file = file, sheet = "Descriptives", comment = comment)
  return(result_df)
}
##########################################################################################
# DESCRIPTIVES
##########################################################################################
#' @title Aggregate descriptive statistics by group
#' @description Computes a comprehensive set of descriptive statistics for all
#'   numeric columns in a data frame, stratified by one or more grouping
#'   variables. Unlike \code{\link{compute_descriptives}}, this function
#'   operates on every numeric column simultaneously and returns results in a
#'   long format where each row corresponds to one statistic for one group
#'   combination. Results can be exported to an Excel file.
#' @param df A data frame containing the variables of interest. All numeric
#'   columns that are not listed in \code{iv} are summarised.
#' @param iv Integer vector of column indices identifying the grouping
#'   variables used to stratify the output.
#' @param file Character string naming the output Excel file (without
#'   extension). When \code{NULL} (default) no file is written.
#' @return A data frame in long format with one row per statistic per group
#'   combination. The first column is \code{statistic} (see below), followed
#'   by the grouping variable columns, and then one column per numeric
#'   variable in \code{df}. The \code{statistic} column takes the following
#'   values:
#'   \describe{
#'     \item{mean}{Arithmetic mean.}
#'     \item{SD}{Standard deviation.}
#'     \item{median}{Median.}
#'     \item{mad}{Median absolute deviation.}
#'     \item{trimmed mean}{50\% trimmed mean.}
#'     \item{N}{Number of non-missing observations.}
#'     \item{min}{Minimum observed value.}
#'     \item{max}{Maximum observed value.}
#'     \item{range}{Difference between maximum and minimum.}
#'     \item{skewness}{Skewness; deviations from 0 indicate departure from symmetry.}
#'     \item{kurtosis}{Excess kurtosis; deviations from 0 indicate departure from normality.}
#'     \item{IQR}{Interquartile range (Q0.75 - Q0.25).}
#'     \item{SE}{Standard error of the mean.}
#'   }
#' @importFrom plyr ddply numcolwise
#' @importFrom stats sd mad
#' @keywords descriptives
#' @export
#' @examples
#' compute_aggregate(df = mtcars, iv = 9)
#' compute_aggregate(df = mtcars, iv = 9:10)
#' compute_aggregate(df = mtcars, iv = 11)
#' compute_aggregate(df = mtcars, iv = 11, file = "descriptives")
compute_aggregate <- function(df, iv, file = NULL) {
  result_df_mean <- result_df_sd <- result_df_obs <- list()
  factornames <- names(df)[iv]
  result_mean <- data.frame(statistic = "mean", plyr::ddply(df, factornames, plyr::numcolwise(mean, na.rm = TRUE)))
  result_sd <- data.frame(statistic = "SD", plyr::ddply(df, factornames, plyr::numcolwise(sd, na.rm = TRUE)))
  result_median <- data.frame(statistic = "median", plyr::ddply(df, factornames, plyr::numcolwise(median, na.rm = TRUE)))
  result_mad <- data.frame(statistic = "mad", plyr::ddply(df, factornames, plyr::numcolwise(stats::mad, na.rm = TRUE)))
  result_trimmed_mean <- data.frame(statistic = "trimmed mean", plyr::ddply(df, factornames, plyr::numcolwise(mean, trim = .5, na.rm = TRUE)))
  result_obs <- data.frame(statistic = "N", plyr::ddply(df, factornames, plyr::numcolwise(function(x) sum(!is.na(x)))))
  result_min <- data.frame(statistic = "min", plyr::ddply(df, factornames, plyr::numcolwise(min, na.rm = TRUE)))
  result_max <- data.frame(statistic = "max", plyr::ddply(df, factornames, plyr::numcolwise(max, na.rm = TRUE)))
  result_range <- data.frame(statistic = "range", plyr::ddply(df, factornames, plyr::numcolwise(function(x) max(x, na.rm = TRUE) - min(x, na.rm = TRUE))))
  result_skewness <- data.frame(statistic = "skewness", plyr::ddply(df, factornames, plyr::numcolwise(compute_skewness)))
  result_kurtosis <- data.frame(statistic = "kurtosis", plyr::ddply(df, factornames, plyr::numcolwise(compute_kurtosis)))
  result_iqr <- data.frame(statistic = "IQR", plyr::ddply(df, factornames, plyr::numcolwise(IQR, na.rm = TRUE, type = 7)))
  result_se <- data.frame(statistic = "SE", plyr::ddply(df, factornames, plyr::numcolwise(compute_standard_error)))
  result_df <- plyr::rbind.fill(
    result_mean, result_sd, result_median, result_mad, result_trimmed_mean, result_obs,
    result_min, result_max, result_range, result_skewness, result_kurtosis,
    result_iqr, result_se
  )
  report_dataframe(result_df, file = file, sheet = "Descriptives")
  return(result_df)
}
##########################################################################################
# FREQUENCIES
##########################################################################################
#' @title Frequency table for categorical variables
#' @description Computes frequency counts, proportions, and percentages for
#'   every column in a data frame. All columns are processed together and the
#'   results are stacked into a single long-format table. Missing values are
#'   excluded from the frequency counts via \code{table()}. Results can be
#'   exported to an Excel file.
#' @param df A data frame whose columns are the categorical variables to
#'   tabulate. All columns are processed regardless of class.
#' @param file Character string naming the output Excel file (without
#'   extension). When \code{NULL} (default) no file is written.
#' @return A data frame in long format with one row per observed level per
#'   variable, containing the following columns:
#'   \describe{
#'     \item{variable}{Name of the column from \code{df}.}
#'     \item{Observation}{Observed level (category label).}
#'     \item{Frequency}{Count of observations at that level.}
#'     \item{Proportion}{Relative frequency (Frequency / total for that variable).}
#'     \item{Percent}{Proportion multiplied by 100.}
#'   }
#' @importFrom plyr rbind.fill
#' @keywords descriptives
#' @export
#' @examples
#' df = generate_missing(generate_factor(nrows = 10, ncols = 10), missing = 5)
#' compute_frequencies(df = df)
#' compute_frequencies(df = generate_factor())
#' compute_frequencies(df = generate_factor(), file = "descriptives")
compute_frequencies <- function(df, file = NULL) {
  frequency <- data.frame()
  for (i in names(df)) {
    mytable <- table(df[i])
    if (nrow(mytable) > 0) {
      proportion.table <- data.frame(prop.table(mytable), stringsAsFactors = FALSE)
      mytable <- data.frame(mytable, stringsAsFactors = FALSE)
      proportion.table <- data.frame(proportion.table, stringsAsFactors = FALSE)
      mytable <- data.frame(rep(names(df[i]), nrow(mytable)), mytable, proportion.table$Freq)
      names(mytable) <- c("variable", "Observation", "Frequency", "Proportion")
      mytable <- mytable[order(-mytable$Frequency), ]
      frequency <- plyr::rbind.fill(frequency, mytable)
    }
  }
  percent <- frequency$Proportion * 100
  frequency <- data.frame(frequency, "Percent" = percent, stringsAsFactors = FALSE)
  report_dataframe(frequency, file = file, sheet = "Frequency")
  return(frequency)
}
##########################################################################################
# RESPONSE FREQUENCIES
##########################################################################################
#' @title Response frequency table for ordinal or Likert-scale variables
#' @description Tabulates how often each response category was chosen for one
#'   or more ordinal variables (e.g. Likert scale items). For each variable the
#'   function returns the count, proportion, or percentage of respondents who
#'   selected each response option, along with the number of missing or
#'   out-of-range responses. The function is a guard against accidental use on
#'   continuous variables: if the number of unique values exceeds \code{max} the
#'   function returns \code{NULL}.
#' @param df A data frame whose columns are the ordinal variables to tabulate.
#' @param max Integer. Maximum number of unique response options allowed before
#'   the function returns \code{NULL}. Use this to prevent accidentally
#'   tabulating continuous variables. Default is \code{10}.
#' @param uniqueitems Vector of all valid response values (e.g. \code{1:5} for
#'   a 5-point Likert scale). When \code{NULL} (default) the unique values
#'   observed in \code{df} are used.
#' @param type Character string controlling the metric returned. One of
#'   \code{"frequency"} (raw counts), \code{"proportion"} (counts divided by
#'   valid responses), \code{"percent"} (proportion multiplied by 100, default),
#'   or \code{"all"} (all three metrics stacked row-wise).
#' @param file Character string naming the output Excel file (without
#'   extension). When \code{NULL} (default) no file is written.
#' @return A data frame with one row per variable (three rows per variable when
#'   \code{type = "all"}) containing the following columns:
#'   \describe{
#'     \item{type}{\code{"Frequency"}, \code{"Proportion"}, or \code{"Percent"}.}
#'     \item{variable}{Name of the column from \code{df}.}
#'     \item{(response columns)}{One column per value in \code{uniqueitems},
#'       named by the response value, containing the frequency, proportion, or
#'       percent of respondents who chose that category.}
#'     \item{miss}{Observations with values outside \code{uniqueitems}. For
#'       proportions this is the missing rate; for percent it is the missing
#'       percentage.}
#'     \item{responses}{Total number of valid (non-missing) responses.}
#'   }
#'   Returns \code{NULL} if the number of unique values exceeds \code{max}.
#' @keywords descriptives
#' @export
#' @examples
#' df_ocean_N<-df_ocean[,grep("N",names(df_ocean))]
#' response_frequency(df_ocean_N)
#' response_frequency(df_ocean_N,
#'                    uniqueitems = 1:5)
#' response_frequency(df_ocean_N,
#'                    uniqueitems = 1:5,
#'                    type = "proportion")
#' response_frequency(df_ocean_N,
#'                    uniqueitems = 1:5,
#'                    type = "percent")
#' response_frequency(df_ocean_N,
#'                    uniqueitems = 1:5,
#'                    type = "all")
#' response_frequency(df_ocean_N,
#'                    uniqueitems = 1:5,
#'                    type = "all",
#'   file = "descriptives")
response_frequency <- function(df, max = 10, uniqueitems = NULL, type = "percent", file = NULL) {
  df <- data.frame(df)
  min.item <- min(df, na.rm = TRUE)
  max.item <- max(df, na.rm = TRUE)
  if (is.null(uniqueitems)) {
    uniqueitems <- unique(as.vector(unlist(df)))
  }
  if ((max.item - min.item > max) || (nlevels(factor(df[, 1])) > max) || length(uniqueitems) > max) {
    result <- NULL
  } else {
    n_cases <- dim(df)[1]
    # count each column against uniqueitems only, values outside it end up in miss
    frequency <- do.call(rbind, lapply(df, function(x) table(factor(x, levels = sort(uniqueitems)))))
    responses <- rowSums(frequency)
    if (type == "frequency") {
      result <- data.frame(type = "Frequency", variable = row.names(frequency), frequency, miss = n_cases - responses, responses, check.names = FALSE)
    }
    if (type == "proportion") {
      result <- data.frame(type = "Proportion", variable = row.names(frequency), frequency / responses, miss = 1 - responses / n_cases, responses, check.names = FALSE)
    }
    if (type == "percent") {
      result <- data.frame(type = "Percent", variable = row.names(frequency), (frequency / responses) * 100, miss = 100 - ((responses / n_cases) * 100), responses, check.names = FALSE)
    }
    if (type == "all") {
      result <- rbind(data.frame(type = "Frequency", variable = row.names(frequency), frequency, miss = n_cases - responses, responses, check.names = FALSE),
        data.frame(type = "Proportion", variable = row.names(frequency), frequency / responses, miss = 1 - responses / n_cases, responses, check.names = FALSE),
        data.frame(type = "Percent", variable = row.names(frequency), (frequency / responses) * 100, miss = 100 - ((responses / n_cases) * 100), responses, check.names = FALSE),
        make.row.names = FALSE
      )
    }
  }
  if (!is.null(result)) row.names(result) <- NULL
  if (!is.null(file) && !is.null(result)) {
    report_dataframe(result, file = file, sheet = "Frequency")
  }
  return(result)
}
##########################################################################################
# COMPUTE CROSSTABLE
##########################################################################################
#' @title Pairwise cross-tabulation of categorical variables
#' @description Computes contingency tables (frequency counts and percentages)
#'   for pairs of categorical variables. Variable pairs can be supplied
#'   explicitly via \code{combinations}, or all unique pairs within a set of
#'   columns can be generated automatically via \code{factor_index}.
#' @param df A data frame containing the variables to cross-tabulate.
#' @param factor_index Integer vector of column indices. When provided and
#'   \code{combinations} is \code{NULL}, all unique pairwise combinations of
#'   the selected columns are computed (self-pairs and duplicate pairs are
#'   excluded).
#' @param combinations A data frame with two character columns named
#'   \code{index1} and \code{index2}, each row specifying one variable pair to
#'   cross-tabulate. Takes precedence over \code{factor_index}.
#' @return A data frame with one row for each combination of levels of each
#'   pair of variables, with the following columns:
#'   \describe{
#'     \item{f1}{Name of the first variable.}
#'     \item{f2}{Name of the second variable.}
#'     \item{l1}{Level of the first variable.}
#'     \item{l2}{Level of the second variable.}
#'     \item{Frequency}{Observed count for the \code{l1} × \code{l2} cell.}
#'     \item{Percent}{Cell count as a percentage of all observations in that
#'       variable pair (\code{Frequency / total * 100}).}
#'   }
#'   Variable pairs with zero total observations are silently dropped.
#' @keywords descriptives
#' @export
#' @examples
#' combinations <- data.frame(index1 = c("vs", "am", "gear"), 
#'                            index2 = c("cyl", "cyl", "cyl"))
#' compute_crosstable(df = mtcars, combinations = combinations)
#' combinations <- data.frame(index1 = c("vs", "am"), 
#'                            index2 = c("cyl", "cyl"))
#' compute_crosstable(df = mtcars, combinations = combinations)
#' compute_crosstable(df = mtcars, factor_index = 8:10)
compute_crosstable <- function(df, factor_index = NULL, combinations = NULL) {
  frequency <- proportion <- data.frame()
  counter <- 0
  if (is.null(combinations)) {
    combinations <- expand.grid(names(df)[factor_index], names(df)[factor_index], stringsAsFactors = FALSE, KEEP.OUT.ATTRS = FALSE)
    names(combinations) <- c("index1", "index2")
    combinations <- combinations[!combinations$index1 == combinations$index2, ]
    combinations <- combinations[!duplicated(t(apply(combinations, 1, sort))), ]
  }
  combinations <- change_data_type(combinations, type = "character")
  for (i in 1:nrow(combinations)) {
    counter <- counter + 1

    f1 <- as.character(combinations[i, 1])
    f2 <- as.character(combinations[i, 2])

    df_table <- data.frame(f1 = f1, f2 = f2, table(df[, f1], df[, f2]))
    df_prop_table <- data.frame(f1 = f1, f2 = f2, prop.table(table(df[, f1], df[, f2])) * 100)

    names(df_table) <- c("f1", "f2", "l1", "l2", "Frequency")
    names(df_prop_table) <- c("f1", "f2", "l1", "l2", "Percent")
    if (sum(df_table$Frequency) > 0) {
      frequency <- plyr::rbind.fill(frequency, df_table)
      proportion <- plyr::rbind.fill(proportion, df_prop_table)
    }
  }
  result <- merge(frequency, proportion, by = c("f1", "f2", "l1", "l2"), all = TRUE, sort = FALSE)

  return(result)
}
##########################################################################################
# PLOT CROSSTABLE
##########################################################################################
#' @title Bubble plots for pairwise cross-tabulations
#' @description Creates a bubble (point) plot for each pair of categorical
#'   variables where point size encodes cell frequency and point colour
#'   encodes the levels of the first variable. Variable pairs can be supplied
#'   explicitly via \code{combinations}, or generated automatically from all
#'   unique pairs within \code{factor_index}. A progress bar is displayed
#'   during computation.
#' @param df A data frame containing the variables to plot.
#' @param factor_index Integer vector of column indices. When
#'   \code{combinations} is \code{NULL}, all unique pairwise combinations of
#'   the selected columns are plotted (self-pairs and duplicate pairs are
#'   excluded).
#' @param combinations A data frame with two character columns named
#'   \code{index1} and \code{index2}, each row specifying one variable pair to
#'   plot. Takes precedence over \code{factor_index}.
#' @param shape Integer specifying the ggplot2 point shape. Default is
#'   \code{16} (filled circle).
#' @param angle Numeric angle (in degrees) for x-axis tick labels. Default is
#'   \code{0}.
#' @param base_size Base font size passed to \code{theme_bw()}. Default is
#'   \code{10}.
#' @param title Character string used as the plot title. Default is \code{""}.
#' @param pb Logical; whether to display a progress bar in the console.
#'   Default is \code{FALSE}.
#' @return A named list of \code{ggplot} objects, one per variable pair. Each
#'   element is named \code{"var1_var2"} and shows a bubble chart with cell
#'   frequency as the point size, frequency counts as text labels, and total
#'   observations in the caption. Variable pairs with zero total observations
#'   are silently dropped.
#' @import ggplot2
#' @keywords descriptives
#' @export
#' @examples
#' combinations <- data.frame(index1 = c("vs", "am", "gear"),
#'                            index2 = c("cyl", "cyl", "cyl"))
#' plot_crosstable(df = mtcars, factor_index = 8:9)
#' plot_crosstable(df = mtcars, combinations = combinations)
#' plot_crosstable(df = mtcars, combinations = combinations, pb = TRUE)
plot_crosstable <- function(df, factor_index, combinations = NULL, shape = 16, angle = 0, base_size = 10, title = "", pb = FALSE) {
  variable1 <- variable2 <- Frequency <- NULL
  plot <- list()
  counter <- 0
  if (is.null(combinations)) {
    combinations <- expand.grid(names(df)[factor_index], names(df)[factor_index], stringsAsFactors = FALSE, KEEP.OUT.ATTRS = FALSE)
    names(combinations) <- c("index1", "index2")
    combinations <- combinations[!combinations$index1 == combinations$index2, ]
    combinations <- combinations[!duplicated(t(apply(combinations, 1, sort))), ]
  }
  if (!is.null(combinations)) {
    combinations <- change_data_type(combinations, type = "character")
  }
  if(pb)
    progress <- txtProgressBar(min = 0, max = nrow(combinations), style = 3)
  for (i in 1:nrow(combinations)) {
    counter <- counter + 1
    if(pb) setTxtProgressBar(progress, counter)
    df_table <- data.frame(table(df[, as.character(combinations[i, 1])], df[, as.character(combinations[i, 2])]))
    names(df_table) <- c("variable1", "variable2", "Frequency")
    if (sum(df_table$Frequency) > 0) {
      plot[[paste0(combinations[i, 1], "_", combinations[i, 2])]] <- ggplot(df_table, aes(x = variable1, y = variable2)) +
        geom_point(aes(size = Frequency, color = variable1), shape = shape) +
        scale_size_continuous(range = c(1, 30)) +
        labs(x = str_aes(combinations[i, 1]), y = str_aes(combinations[i, 2])) +
        geom_text(aes(label = Frequency)) +
        theme_bw(base_size = base_size) +
        theme(axis.text.x = element_text(angle = angle, hjust = 1), legend.position = "none") +
        labs(title = title, caption = paste("Observations:", sum(df_table$Frequency)))
    }
  }
  if(pb) close(progress)
  invisible(lapply(plot,print))
  return(invisible(plot))
}
##########################################################################################
# PLOT MOSAIC
##########################################################################################
#' @title Mosaic plots for pairwise categorical variables
#' @description Creates a mosaic plot for every ordered pair of categorical
#'   variables within \code{factor_index}. In each plot, bar widths represent
#'   the marginal proportion of the first variable and bar heights represent
#'   the conditional proportion of the second variable given the first,
#'   making it straightforward to assess both marginal distributions and
#'   conditional relationships simultaneously. Rows with missing values are
#'   excluded pair-wise. A progress bar is displayed during computation.
#' @param df A data frame containing the variables to plot.
#' @param factor_index Integer vector of column indices identifying the
#'   categorical variables. All ordered pairs of distinct columns are plotted.
#' @param base_size Base font size passed to \code{theme_bw()}. Default is
#'   \code{10}.
#' @param title Character string prepended to each plot title. Default is
#'   \code{""}.
#' @param pb Logical; whether to display a progress bar in the console.
#'   Default is \code{FALSE}.
#' @return A named list of \code{ggplot} objects, one per ordered variable
#'   pair. Each element is named \code{"var1 var2"} and shows a mosaic chart
#'   with bar widths proportional to the marginal distribution of \code{var1},
#'   bar heights proportional to the conditional distribution of \code{var2}
#'   given \code{var1}, and total complete-case observations in the caption.
#'   Variables with fewer than two observed levels are handled gracefully by
#'   adding a placeholder level.
#' @import ggplot2
#' @importFrom stats complete.cases na.omit
#' @keywords descriptives
#' @export
#' @examples
#' plot_mosaic(df = mtcars, factor_index = 8:9)
#' plot_mosaic(df = mtcars, factor_index = 9:10)
#' plot_mosaic(df = mtcars, factor_index = 9:10, pb = TRUE)
plot_mosaic <- function(df, factor_index, base_size = 10, title = "", pb = FALSE) {
  var1Center <- var2height <- NULL
  plot <- list()
  counter <- 0
  if(pb) 
    progress <- txtProgressBar(min = 0, max = length(names(df[, factor_index])), style = 3)
  for (i in names(df[, factor_index])) {
    counter <- counter + 1
    if(pb) setTxtProgressBar(progress, counter)
    for (y in names(df[, factor_index])) {
      if (!i == y) {
        tempdata <- df[complete.cases(df[, c(i, y)]), c(i, y)]
        v1 <- factor(stats::na.omit(tempdata[, i]))
        v2 <- factor(stats::na.omit(tempdata[, y]))
        levVar1 <- length(levels(v1))
        levVar2 <- length(levels(v2))
        if (levVar1 < 2) {
          levels(v1) <- c(levels(v1), "Second Level is Not Available")
        }
        if (levVar2 < 2) {
          levels(v2) <- c(levels(v2), "Second Level is Not Available")
        }
        plotData <- data.frame(prop.table(table(v1, v2)))
        plotData$marginVar1 <- prop.table(table(v1))
        plotData$var2height <- plotData$Freq / plotData$marginVar1
        plotData$var1Center <- c(0, cumsum(plotData$marginVar1)[1:levVar1 - 1]) + plotData$marginVar1 / 2
        plot[[paste(i, y)]] <- ggplot(plotData, aes(var1Center, var2height)) +
          geom_bar(stat = "identity", aes(fill = v2), width = plotData$marginVar1, col = "White") +
          # geom_bar(stat="identity",aes(width=marginVar1,fill=v2),col="White")+
          geom_text(aes(label = v1, x = var1Center, y = .5, angle = 90)) +
          labs(
            x = paste("Proportion"),
            y = paste("Proportion"),
            title = paste0(title, "\n", str_aes(i), " By ", str_aes(y)),
            fill = i,
            caption = paste("Observations:", nrow(tempdata))
          ) +
          theme_bw(base_size = base_size) +
          theme(
            legend.title = element_blank(),
            panel.grid.major = element_blank(),
            panel.grid.minor = element_blank()
          ) +
          coord_fixed()
      }
    }
  }
  if (pb) close(progress)
  invisible(lapply(plot,print))
  return(invisible(plot))
}
##########################################################################################
# PLOT RESPONSE FREQUENCY
##########################################################################################
#' @title Horizontal bar charts of response frequencies
#' @description Creates one horizontal bar chart per variable showing the
#'   frequency count of each observed level. Missing values are excluded
#'   before tabulation. Variables with no valid observations are silently
#'   dropped from the output.
#' @param df A data frame containing the variables to plot.
#' @param factor_index Integer vector of column indices identifying the
#'   variables to plot.
#' @param base_size Base font size passed to \code{theme_bw()}. Default is
#'   \code{10}.
#' @param title Character string prepended to each plot title. Default is
#'   \code{""}.
#' @param width Integer controlling the character wrap width applied to the
#'   variable name in the plot title. Default is \code{100}.
#' @param reorder Logical. When \code{TRUE} bars are ordered by frequency in
#'   ascending order (longest bar at the top). When \code{FALSE} (default)
#'   the original level order is preserved.
#' @return A named list of \code{ggplot} objects, one per variable, named by
#'   the column name. Each plot is a horizontal bar chart with counts on the
#'   x-axis and total observations shown in the caption.
#' @import ggplot2
#' @importFrom stats reorder
#' @keywords descriptives
#' @export
#' @examples
#' df_ocean_N<-df_ocean[,grep("N",names(df_ocean))]
#' plot_response_frequencies(df = df_ocean_N)
#' plot_response_frequencies(df = df_ocean_N, factor_index = 1)
plot_response_frequencies <- function(df, factor_index, base_size = 10, title = "", width = 100, reorder = FALSE) {
  Freq <- NULL
  plots <- list()
  for (i in names(df[, factor_index])) {
    tempdata <- df[complete.cases(df[, i]), i]
    tempdata <- data.frame(table(tempdata))
    if (nrow(tempdata) > 0) {
      if (reorder) {
        plots[[i]] <- ggplot(data.frame(tempdata), aes(x = stats::reorder(tempdata, Freq), y = Freq)) +
          geom_bar(stat = "identity") +
          labs(x = "", y = "Count", title = paste(title, str_wrap(i, width = width), collapse = "\n"), caption = paste0("Observations:", sum(tempdata$Freq))) +
          coord_flip() +
          theme_bw(base_size = base_size)
      } else {
        plots[[i]] <- ggplot(data.frame(tempdata), aes(x = tempdata, y = Freq)) +
          geom_bar(stat = "identity") +
          labs(x = "", y = "Count", title = paste(title, str_wrap(i, width = width), collapse = "\n"), caption = paste0("Observations:", sum(tempdata$Freq))) +
          coord_flip() +
          theme_bw(base_size = base_size)
      }
    }
  }
  invisible(lapply(plots,print))
  return(invisible(plots))
}
