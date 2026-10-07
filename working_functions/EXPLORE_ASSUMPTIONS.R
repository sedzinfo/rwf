##########################################################################################
# PLOT NORMALITY ASSUMPTIONS BASE PLOT
##########################################################################################
#' @title Normality diagnostic plots (histogram, density, boxplot, Q-Q)
#' @description For each numeric column of \code{df}, produces a 2×2 panel of
#'   base-graphics normality diagnostics: histogram, density curve, boxplot, and
#'   Q-Q plot with a reference line. A progress bar is printed to the console.
#'   When \code{file} is supplied the panels are also written to a PDF via
#'   \code{\link{report_pdf}}.
#' @param df Data frame or numeric vector. Non-numeric columns are silently
#'   dropped. Columns with fewer than three non-missing values or zero variance
#'   are skipped.
#' @param breaks Histogram breaks passed to \code{\link[graphics]{hist}}. May
#'   be a method name (\code{"Sturges"}, \code{"Scott"}, \code{"FD"}) or a
#'   positive integer specifying the number of bins. Default is
#'   \code{"Sturges"}.
#' @param title Character string used as the outer plot title and as the PDF
#'   title. Default is \code{""}.
#' @param file Character string naming the output PDF file (without extension).
#'   When \code{NULL} (default) no PDF is written.
#' @param w Width of the PDF in inches. Default is \code{10}.
#' @param h Height of the PDF in inches. Default is \code{10}.
#' @param pb Logical; whether to display a progress bar in the console.
#'   Default is \code{FALSE}.
#' @return A named list of recorded plots (one element per numeric column),
#'   returned invisibly. Each element is a \code{\link[grDevices]{recordPlot}}
#'   object.
#' @importFrom graphics plot par hist boxplot title
#' @importFrom stats qqnorm qqline na.omit density
#' @importFrom utils txtProgressBar setTxtProgressBar
#' @importFrom grDevices recordPlot
#' @keywords assumptions
#' @export
#' @examples
#' vector <- generate_missing(rnorm(50), missing = 10)
#' df <- generate_missing(mtcars[, 1:2], missing = 10)
#' plot_normality_diagnostics(df = vector, file = "rnorm", breaks = 30)
#' plot_normality_diagnostics(df = vector)
#' plot_normality_diagnostics(df = df, title = "mtcars")
#' plot_normality_diagnostics(df = df, title = "mtcars", pb = TRUE)
#' plot_normality_diagnostics(df = df, title = "mtcars", file = "rnorm")
plot_normality_diagnostics <- function(df, breaks = NULL, title = "", file = NULL, w = 10, h = 10, pb = FALSE) {
  # default_par<-par(no.readonly=TRUE)
  par(mfrow = c(2, 2), adj = .01)
  if (is.null(breaks)) {
    breaks <- "Sturges"
  }
  plot <- list()
  data_name <- deparse(substitute(df))
  df <- data.frame(df)
  df <- data.frame(df[, sapply(df, is.numeric)])
  if (length(df) == 1) {
    names(df) <- data_name
  }
  if (pb)
    progress <- txtProgressBar(min = 0, max = length(names(df)), style = 3)
  counter <- 0
  for (i in names(df)) {
    counter <- counter + 1
    if (pb) {
      setTxtProgressBar(progress, counter)
    }
    vector <- stats::na.omit(df[, i])
    if (length(vector) > 2 & var(vector) != 0) {
      hist(vector, main = "Histogram", xlab = "", warn.unused = FALSE, breaks = breaks)
      plot(stats::density(vector, na.rm = TRUE), main = "Density Function")
      boxplot(vector, main = "Boxplot", xlab = "")
      stats::qqnorm(vector)
      stats::qqline(vector)
      title(
        main = title,
        sub = paste0(
          "\nVariable=", str_aes(i),
          "\nObservations=", length(vector),
          "\nMean=", round(mean(vector), 2),
          "\nSD=", round(stats::sd(vector), 2),
          "\nMedian=", round(stats::median(vector), 2)
        ),
        outer = TRUE, line = -1
      )
      plot[[i]] <- recordPlot()
    } else {
      cat("Graph not produced for", i, "due to sample size\n")
    }
  }
  if (pb) close(progress)
  # on.exit(par(default_par))
  par(mfrow = c(1, 1), adj = 0.5)
  report_pdf(plotlist = plot, file = file, title = title, w = w, h = h)
}
##########################################################################################
# PLOT OUTLIER
##########################################################################################
#' @title Dot plot of outliers by detection method
#' @description For each numeric column of \code{df}, draws a dot plot with
#'   observations coloured by outlier status and row-name labels repelled away
#'   from flagged points. Three outlier-detection rules are available via
#'   \code{method}: mean ± 2 SD, median ± 2 MAD (rescaled), or boxplot IQR
#'   fences. Reference lines for the centre and the upper/lower bounds are
#'   overlaid on each plot.
#' @param df Data frame or numeric vector. Non-numeric columns are silently
#'   dropped.
#' @param method Character string selecting the outlier-detection rule:
#'   \describe{
#'     \item{\code{"mean"}}{Flags observations more than 2 standard deviations
#'       from the mean.}
#'     \item{\code{"median"}}{Flags observations more than 2 rescaled MADs
#'       (\eqn{2 \times \mathrm{MAD}/0.6745}) from the median.}
#'     \item{\code{"boxplot"}}{Flags observations outside
#'       \eqn{Q1 - 1.5 \times IQR} or \eqn{Q3 + 1.5 \times IQR}.}
#'   }
#'   Default is \code{"mean"}.
#' @param title Character string used as the plot title. Default is \code{""}.
#' @param base_size Base font size passed to \code{theme_bw()}. Default is
#'   \code{10}.
#' @param pb Logical; whether to display a progress bar in the console.
#'   Default is \code{FALSE}.
#' @return A named list of \code{ggplot} objects, one per numeric column.
#' @import ggplot2
#' @importFrom stats median sd quantile na.omit
#' @importFrom ggrepel geom_text_repel
#' @keywords assumptions
#' @author unknown
#' @export
#' @examples
#' vector <- generate_missing(rnorm(50), missing = 10)
#' df <- generate_missing(mtcars[, 1:2], missing = 10)
#' plot_outlier(df = vector, method = "mean", title = "random vector")
#' plot_outlier(df = vector, method = "median")
#' plot_outlier(df = vector, method = "boxplot")
#' plot_outlier(df = df, method = "mean", title = "random vector")
#' plot_outlier(df = df, method = "median")
#' plot_outlier(df = df, method = "boxplot")
#' plot_multiplot(plotlist = plot_outlier(df = mtcars[1:5, 2:5], method = "mean"), cols = 2)
plot_outlier <- function(df, method = "mean", title = "", base_size = 10, pb = FALSE) {
  obs <- Outlier <- NULL
  plot <- list()
  data_name <- deparse(substitute(df))
  df <- data.frame(df)
  df <- data.frame(df[, sapply(df, is.numeric)])
  id <- row.names(df)
  if (length(names(df)) == 1) {
    names(df) <- data_name
  }
  if(pb)
    progress <- txtProgressBar(min = 0, max = length(df), style = 3)
  for (i in 1:(length(df))) {
    if(pb) setTxtProgressBar(progress, i)
    vector <- df[, i]
    midp <- median_point <- stats::median(vector, na.rm = TRUE)
    mean_point <- mean(vector, na.rm = TRUE)
    std <- stats::sd(vector, na.rm = TRUE)
    mad <- stats::median(abs(median_point - vector), na.rm = TRUE)
    if (method == "mean") {
      df_outlier <- data.frame(id = id, obs = vector, Outlier = abs(vector - mean_point) > 2 * std)
      df_outlier <- df_outlier[complete.cases(df_outlier), ]
      midp <- mean_point
      lower <- mean_point - 2 * std
      upper <- mean_point + 2 * std
      outliern <- length(which(df_outlier == "TRUE"))
    }
    if (method == "median") {
      df_outlier <- data.frame(id = id, obs = vector, Outlier = abs(vector - median_point) > 2 * (mad / 0.6745))
      df_outlier <- df_outlier[complete.cases(df_outlier), ]
      lower <- median_point - 2 * (mad / 0.6745)
      upper <- median_point + 2 * (mad / 0.6745)
      outliern <- length(which(df_outlier == "TRUE"))
    }
    if (method == "boxplot") {
      Q1 <- stats::quantile(vector, 0.25, na.rm = TRUE)
      Q3 <- stats::quantile(vector, 0.75, na.rm = TRUE)
      IntQ <- Q3 - Q1
      df_outlier <- data.frame(id = id, obs = vector, Outlier = vector < Q1 - 1.5 * IntQ | vector > Q3 + 1.5 * IntQ)
      df_outlier <- df_outlier[complete.cases(df_outlier), ]
      lower <- Q1 - 1.5 * IntQ
      upper <- Q3 + 1.5 * IntQ
      outliern <- length(which(df_outlier == "TRUE"))
    }
    plot[[names(df)[i]]] <- ggplot(df_outlier, aes(x = id, y = obs, label = id)) +
      geom_point(aes(colour = Outlier)) +
      ggrepel::geom_text_repel(data = subset(df_outlier, Outlier == "TRUE"), aes(label = id), size = 2.7, colour = "black", box.padding = unit(0.35, "lines"), point.padding = unit(0.3, "lines")) +
      labs(
        x = paste("Observation ID \n Outliers:", outliern),
        y = names(df)[i],
        title = paste(title),
        caption = paste0(
          "\nMethod=", method,
          "\nObservations=", nrow(df_outlier),
          "\nMean=", round(mean(stats::na.omit(df_outlier$obs)), 2),
          "\nSD=", round(stats::sd(stats::na.omit(df_outlier$obs)), 2),
          "\nMedian=", round(stats::median(stats::na.omit(df_outlier$obs)), 2)
        )
      ) +
      theme_bw(base_size = base_size) +
      theme(legend.position = "none") +
      geom_hline(yintercept = midp, colour = "black", linetype = "longdash") +
      geom_hline(yintercept = lower, colour = "black", linetype = "longdash") +
      geom_hline(yintercept = upper, colour = "black", linetype = "longdash") +
      coord_flip()
  }
  if (pb) close(progress)
  invisible(lapply(plot,print))
  return(invisible(plot))
}
##########################################################################################
#  PLOT HISTOGRAM
##########################################################################################
#' @title Histograms per numeric column
#' @description Produces one \code{ggplot} histogram per numeric column of
#'   \code{df}. Each plot caption shows the observation count, mean, SD, and
#'   median of the column. A progress bar is printed to the console.
#' @param df Data frame or numeric vector. Non-numeric columns are silently
#'   dropped.
#' @param bins Number of histogram bins passed to
#'   \code{\link[ggplot2]{geom_histogram}}. Default is \code{30}.
#' @param xlims Length-2 numeric vector setting the x-axis limits, e.g.
#'   \code{c(0, 50)}. When \code{NULL} (default) limits are determined
#'   automatically.
#' @param title Character string used as the plot title. Default is \code{""}.
#' @param ylab Y-axis label. Default is \code{"Count"}.
#' @param base_size Base font size passed to \code{theme_bw()}. Default is
#'   \code{10}.
#' @param fill Fill colour of the histogram bars. Default is \code{"gray25"}.
#' @param color Outline colour of the histogram bars. Default is
#'   \code{"gray50"}.
#' @param pb Logical; whether to display a progress bar in the console.
#'   Default is \code{FALSE}.
#' @return A named list of \code{ggplot} objects, one per numeric column.
#' @import ggplot2
#' @importFrom stats sd median na.omit
#' @keywords assumptions
#' @export
#' @examples
#' vector <- generate_missing(rnorm(50), missing = 10)
#' df <- generate_missing(mtcars[, 1:2], missing = 10)
#' plot_histogram(df = vector)
#' plot_histogram(df = df, xlims = c(0, 50))
#' plot_histogram(df = df)
#' plot_multiplot(plotlist = plot_histogram(df = mtcars[,1:4]), cols = 2)
plot_histogram <- function(df, bins = 30, title = "", base_size = 10, xlims = NULL, fill = "gray25", color = "gray50", ylab = "Count", pb = FALSE) {
  data <- NULL
  plot <- list()
  df <- data.frame(df, id = 1:nrow(data.frame(df)), check.names = FALSE)
  df <- df[, sapply(df, is.numeric)]
  if (length(names(df)) == 2) {
    names(df)[1] <- ""
  }
  if(pb)
    progress <- txtProgressBar(min = 0, max = length(df), style = 3)
  for (i in 1:(length(df) - 1)) {
    if(pb) setTxtProgressBar(progress, i)
    vector <- data.frame(data = df[, i])
    plot[[names(df)[i]]] <- ggplot(vector, aes(x = data)) +
      geom_histogram(bins = bins, fill = fill, color = color, na.rm = TRUE) +
      theme_bw(base_size = base_size) +
      labs(
        title = title,
        # x=str_aes(names(df)[i],proper=TRUE),
        x = names(df)[i],
        y = ylab,
        caption = paste0(
          "\nObservations=", length(vector[complete.cases(vector), ]),
          "\nMean=", round(mean(vector[, 1], na.rm = TRUE), 2),
          "\nSD=", round(stats::sd(vector[, 1], na.rm = TRUE), 2),
          "\nMedian=", round(stats::median(vector[, 1], na.rm = TRUE), 2)
        )
      ) +
      if (!is.null(xlims)) {
        lims(x = xlims)
      }
  }
  if(pb) close(progress)
  invisible(lapply(plot,print))
  return(invisible(plot))
}
##########################################################################################
# PLOT QQ
##########################################################################################
#' @title Q-Q plots against the normal distribution
#' @description Produces one quantile-quantile plot per numeric column of
#'   \code{df}, comparing the empirical distribution to the theoretical normal.
#'   A reference line is fitted through the 25th and 75th percentiles (the same
#'   convention used by \code{\link[stats]{qqline}}). Non-numeric columns are
#'   skipped silently. A progress bar is printed to the console.
#' @param df Data frame or vector. Non-numeric columns are skipped.
#' @param title Character string used as the plot title. Default is \code{""}.
#' @param base_size Base font size passed to \code{theme_bw()}. Default is
#'   \code{10}.
#' @param pb Logical; whether to display a progress bar in the console.
#'   Default is \code{FALSE}.
#' @return A named list of \code{ggplot} objects, one per numeric column.
#' @import ggplot2
#' @importFrom stats quantile qnorm
#' @keywords assumptions
#' @export
#' @examples
#' vector <- generate_missing(rnorm(50), missing = 10)
#' df <- generate_missing(mtcars[, 1:2], missing = 10)
#' plot_qq(df = vector)
#' plot_qq(df = df)
#' plot_multiplot(plotlist = plot_qq(df = mtcars[,1:4]), cols = 2)
plot_qq <- function(df, title = "", base_size = 10, pb = FALSE) {
  resids <- NULL
  data_name <- deparse(substitute(df))
  df <- data.frame(df)
  if (length(names(df)) == 1) {
    names(df) <- data_name
  }
  names_df <- names(df)
  if(pb)
    progress <- txtProgressBar(min = 0, max = length(df), style = 3)
  plot <- list()
  for (i in 1:length(df)) {
    if(pb) setTxtProgressBar(progress, i)
    if (is.numeric(df[, i])) {
      values <- df[, i][is.finite(df[, i])]
      y <- stats::quantile(values, c(0.25, 0.75))
      x <- stats::qnorm(c(0.25, 0.75))
      slope <- diff(y) / diff(x)
      intercept <- y[1L] - slope * x[1L]
      d <- data.frame(resids = values)
      plot[[names(df)[i]]] <- ggplot(d, aes(sample = resids)) +
        stat_qq(alpha = .1) +
        geom_abline(slope = slope, intercept = intercept) +
        theme_bw(base_size = base_size) +
        labs(
          title = title,
          caption = paste0(
            "\nVariable=", names(df)[i],
            "\nObservations=", length(values),
            "\nMean=", round(mean(values), 2),
            "\nSD=", round(stats::sd(values), 2),
            "\nMedian=", round(stats::median(values), 2)
          )
        )
    }
  }
  if(pb) close(progress)
  invisible(lapply(plot,print))
  return(invisible(plot))
}
##########################################################################################
# PLOT BOXPLOT
##########################################################################################
#' @title Side-by-side boxplots for all numeric columns
#' @description Melts all numeric columns of \code{df} into a single long
#'   format and draws them as side-by-side horizontal boxplots on one plot.
#'   Non-numeric columns are silently dropped.
#' @param df Data frame or numeric vector. Non-numeric columns are silently
#'   dropped.
#' @param title Character string used as the plot title. Default is \code{""}.
#' @param base_size Base font size passed to \code{theme_bw()}. Default is
#'   \code{10}.
#' @return A single \code{ggplot} object.
#' @import ggplot2
#' @importFrom reshape2 melt
#' @keywords assumptions
#' @export
#' @examples
#' vector <- generate_missing(rnorm(50), missing = 10)
#' df <- generate_missing(mtcars[, 1:2], missing = 10)
#' plot_boxplot(df = vector)
#' plot_boxplot(df = df)
plot_boxplot <- function(df, title = "", base_size = 10) {
  variable <- value <- NULL
  data_name <- deparse(substitute(df))
  df <- data.frame(df)
  df <- data.frame(df[, sapply(df, is.numeric)])
  if (length(df) == 1) {
    names(df) <- data_name
  }
  vector <- reshape2::melt(df, measure.vars = names(df), value.name = "value", variable.name = "variable")
  vector <- vector[is.finite(vector$value), ]
  plot <- ggplot(vector, aes(x = variable, y = value)) +
    geom_boxplot() +
    labs(title = title, y = "", x = "", caption = paste("Observations=", nrow(df))) +
    theme_bw(base_size = base_size) +
    coord_flip()
  return(plot)
}
##########################################################################################
# NORMALITY TESTS
##########################################################################################
#' @title Battery of normality tests
#' @description Runs eight normality tests on each numeric column of \code{df}:
#'   Shapiro-Wilk, Anderson-Darling, Cramér-von Mises, Shapiro-Francia,
#'   Jarque-Bera, Kolmogorov-Smirnov, Lilliefors, and Pearson chi-squared.
#'   Each column is z-standardised before testing. Columns with fewer than 8 or
#'   more than 4999 non-missing observations are skipped with a console message.
#'   Results are printed to the console; when \code{file} is supplied they are
#'   also written to a \code{.log} file and a colour-coded \code{.xlsx} file
#'   with significant p-values (\eqn{p \le 0.05}) highlighted.
#' @param df Data frame or numeric vector.
#' @param file Character string naming the output files (without extension).
#'   When supplied, a \code{.log} and an \code{.xlsx} file are written.
#'   When \code{NULL} (default) no files are written.
#' @return Invisibly returns \code{NULL}. Called for its side effects of
#'   printing results and optionally writing output files.
#' @importFrom plyr rbind.fill
#' @importFrom DescTools AndersonDarlingTest CramerVonMisesTest ShapiroFranciaTest JarqueBeraTest LillieTest PearsonTest
#' @importFrom stats ks.test na.omit shapiro.test
#' @importFrom openxlsx createWorkbook saveWorkbook
#' @keywords assumptions
#' @export
#' @examples
#' vector <- generate_missing(rnorm(50), missing = 10)
#' df <- generate_missing(mtcars[, 1:2], missing = 10)
#' report_normality_tests(df = df)
#' report_normality_tests(df = vector, file = "normality_tests")
report_normality_tests <- function(df, file = NULL) {
  df <- data.frame(df)
  n <- nrow(df)
  instruction_shapiro <- "Shapiro-Wilk Composite null hypothesis: any normal distribution"
  instruction_anderson <- "Anderson-Darling Composite null hypothesis: any normal distribution"
  instruction_crammer <- "Cramer-von-Mises Composite null hypothesis: any normal distribution"
  instruction_shapiro_francia <- "Shapiro-Francia Composite null hypothesis: any normal distribution"
  instruction_jarque <- "Jarque-Bera Composite null hypothesis: any normal distribution"
  instruction_lilliefors <- "Lilliefors Composite null hypothesis: any normal distribution"
  instruction_kolmogorov <- "Kolmogorov-Smirnov Exact null hypothesis: fully specified normal distribution"
  instruction_pearson <- "Pearson X2 Tests weaker null hypothesis: any distribution with the same probabilities for the given class intervals"
  result_df <- data.frame()
  for (i in names(df)) {
    vector <- compute_standard(stats::na.omit(df[, i]), type = "z")
    N <- length(vector)
    if (length(vector) < 5000 & length(vector) > 7 & var(vector) != 0) {
      result_shapiro <- data.frame(variable = i, N = N, t(unlist(shapiro.test(vector))), instruction = instruction_shapiro)
      result_anderson <- data.frame(variable = i, N = N, t(unlist(DescTools::AndersonDarlingTest(vector))), instruction = instruction_anderson)
      result_cramer <- data.frame(variable = i, N = N, t(unlist(DescTools::CramerVonMisesTest(vector))), instruction = instruction_crammer)
      result_francia <- data.frame(variable = i, N = N, t(unlist(DescTools::ShapiroFranciaTest(vector))), instruction = instruction_shapiro_francia)
      result_jarque <- data.frame(variable = i, N = N, t(unlist(DescTools::JarqueBeraTest(vector))), instruction = instruction_jarque)
      result_lillie <- data.frame(variable = i, N = N, t(unlist(DescTools::LillieTest(vector))), instruction = instruction_lilliefors)
      result_kolmogorov <- data.frame(variable = i, N = N, t(unlist(stats::ks.test(vector, "pnorm", mean = mean(vector), sd = stats::sd(vector), alternative = "two.sided"))), instruction = instruction_kolmogorov)
      result_pearson <- data.frame(variable = i, N = N, t(unlist(DescTools::PearsonTest(vector, n.classes = ceiling(2 * (n^(2 / 5))), adjust = TRUE))), instruction = instruction_pearson)
      
      names(result_shapiro) <- c("variable", "n", "statistic", "p", "method", "data.name", "instruction")
      names(result_anderson) <- c("variable", "n", "statistic", "p", "method", "method1", "data.name", "instruction")
      names(result_cramer) <- c("variable", "n", "statistic", "p", "method", "data.name", "instruction")
      names(result_francia) <- c("variable", "n", "statistic", "p", "method", "data.name", "instruction")
      names(result_jarque) <- c("variable", "n", "statistic", "df", "p", "method", "data.name", "instruction")
      names(result_lillie) <- c("variable", "n", "statistic", "p", "method", "data.name", "instruction")
      names(result_kolmogorov) <- c("variable", "n", "statistic", "p", "alternative", "method", "data.name", "exact", "instruction")
      names(result_pearson) <- c("variable", "n", "statistic", "p", "method", "data.name", "n.classes", "df", "instruction")
      
      result <- plyr::rbind.fill(
        result_shapiro,
        result_anderson,
        result_cramer,
        result_francia,
        result_jarque,
        result_lillie,
        result_kolmogorov,
        result_pearson
      )
      result_df <- plyr::rbind.fill(result_df, result)
      
      result_df <- result_df[, c("variable", "n", "statistic", "df", "p", "method", "method1", "alternative", "n.classes", "instruction")]
    } else {
      cat("NORMALITY INDICES NOT CALCULATED DUE TO OUT OF BOUNDS SAMPLE SIZE FOR", i, "\n")
    }
  }
  message <- "Significant values indicate deviation from normality,p values depend on sample size"
  write_txt(
    {
      output_separator("NORMALITY TESTS", output = result_df, instruction = "")
    },
    file = file
  )
  if (!is.null(file)) {
    filename <- paste0(file, ".xlsx")
    if (file.exists(filename)) file.remove(filename)
    wb <- openxlsx::createWorkbook()
    excel_critical_value(result_df, workbook = wb, sheet = "Normality Tests", critical = list(p = "<=0.05"), numFmt = "#0.00")
    openxlsx::saveWorkbook(wb = wb, file = filename, overwrite = TRUE)
  }
}
##########################################################################################
# OUTLIERS
##########################################################################################
#' @title Percentage of outliers at three z-score thresholds
#' @description Z-standardises \code{vector} and counts the percentage of
#'   observations whose absolute z-score exceeds 1.96, 2.58, and 3.29,
#'   corresponding approximately to the 95 \%, 99 \%, and 99.9 \% tails of the
#'   normal distribution. Designed to be applied across columns with
#'   \code{sapply}.
#' @param vector Numeric vector. Missing values are removed before
#'   z-standardisation and counts.
#' @return A one-row data frame with three character columns:
#'   \describe{
#'     \item{abs_z_1.96}{Percentage of observations with \eqn{|z| \ge 1.96}.}
#'     \item{abs_z_2.58}{Percentage of observations with \eqn{|z| \ge 2.58}.}
#'     \item{abs_z_3.29}{Percentage of observations with \eqn{|z| \ge 3.29}.}
#'   }
#' @importFrom stats sd na.omit
#' @keywords assumptions
#' @export
#' @examples
#' vector <- generate_missing(rnorm(50), missing = 10)
#' df <- generate_missing(mtcars[, 1:2], missing = 10)
#' outlier_summary(vector)
#' data.frame(sapply(mtcars, outlier_summary))
outlier_summary <- function(vector) {
  zvariable <- (vector - mean(vector, na.rm = TRUE)) / stats::sd(vector, na.rm = TRUE)
  outlier95 <- abs(zvariable) >= 1.96
  outlier99 <- abs(zvariable) >= 2.58
  outlier999 <- abs(zvariable) >= 3.29
  ncases <- length(stats::na.omit(zvariable))
  percent95 <- round(100 * length(subset(outlier95, outlier95 == TRUE)) / ncases, 2)
  percent99 <- round(100 * length(subset(outlier99, outlier99 == TRUE)) / ncases, 2)
  percent999 <- round(100 * length(subset(outlier999, outlier999 == TRUE)) / ncases, 2)
  result <- data.frame(outlier = rbind(
    "|z-score| > 1.96" = paste(percent95, "%"),
    "|z-score| > 2.58" = paste(percent99, "%"),
    "|z-score| > 3.29" = paste(percent999, "%")
  ))
  result <- data.frame(
    abs_z_1.96 = paste(percent95, "%"),
    abs_z_2.58 = paste(percent99, "%"),
    abs_z_3.29 = paste(percent999, "%")
  )
  return(result)
}
##########################################################################################
# OUTLIERS
##########################################################################################
#' @title Replace outliers with NA using IQR fences
#' @description Replaces values outside the boxplot fences with \code{NA}.
#'   The fences are computed as \eqn{Q1 - 1.5 \times IQR} and
#'   \eqn{Q3 + 1.5 \times IQR}, where \eqn{Q1} and \eqn{Q3} are the quantiles
#'   specified by \code{probs}. Designed to be applied across columns with
#'   \code{sapply}.
#' @param vector Numeric vector.
#' @param probs Length-2 numeric vector giving the lower and upper quantile
#'   probabilities used to define the fence boundaries. Default is
#'   \code{c(0.25, 0.75)} (standard quartiles).
#' @param na.rm Logical; whether to remove \code{NA} values when computing
#'   quantiles and IQR. Default is \code{TRUE}.
#' @param ... Additional arguments passed to \code{\link[stats]{quantile}}.
#' @return A numeric vector the same length as \code{vector} with outlying
#'   values replaced by \code{NA}.
#' @importFrom stats quantile IQR
#' @keywords assumptions
#' @export
#' @examples
#' vector <- generate_missing(rnorm(50), missing = 10)
#' df <- generate_missing(mtcars[, 1:2], missing = 10)
#' remove_outliers(vector)
#' data.frame(sapply(df, remove_outliers))
remove_outliers <- function(vector, probs = c(.25, .75), na.rm = TRUE, ...) {
  qnt <- stats::quantile(vector, probs = probs, na.rm = na.rm, ...)
  H <- 1.5 * stats::IQR(vector, na.rm = na.rm)
  y <- vector
  y[vector < (qnt[1] - H)] <- NA
  y[vector > (qnt[2] + H)] <- NA
  return(y)
}
