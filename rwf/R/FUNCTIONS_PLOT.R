##########################################################################################
# MULTIPLOT
##########################################################################################
#' Arrange multiple ggplot objects in a grid layout
#'
#' Combines multiple ggplot objects into a single paged display using a grid
#' layout. Plots are arranged by column across one or more pages, with each
#' page recorded and returned as a list.
#'
#' @param ... ggplot objects passed directly.
#' @param plotlist A list of ggplot objects. Combined with any plots passed via
#'   \code{...}.
#' @param cols Integer. Number of columns in the layout grid. Ignored if
#'   \code{layout} is provided. Default is \code{2}.
#' @param layout A matrix specifying plot positions. Each cell contains the index
#'   of the plot to display at that position. If \code{NULL}, a layout is
#'   generated automatically from \code{cols}. Default is \code{NULL}.
#'
#' @return If a single plot is provided, returns it directly. Otherwise returns
#'   a list of recorded plots (\code{\link[grDevices]{recordPlot}}), one per page.
#'
#' @importFrom grid grid.newpage pushViewport viewport grid.layout
#' @importFrom grDevices recordPlot
#'
#' @export
#' @examples
#' p1 <- ggplot(ChickWeight, aes(x = Time, y = weight, colour = Diet, group = Chick)) +
#'   geom_line() +
#'   ggtitle("Growth curve for individual chicks") +
#'   theme_bw()
#' p2 <- ggplot(ChickWeight, aes(x = Time, y = weight, colour = Diet)) +
#'   geom_point(alpha = .3) +
#'   geom_smooth(alpha = .2, size = 1, method = "loess", formula = "y~x") +
#'   ggtitle("Fitted growth curve per diet") +
#'   theme_bw()
#' p3 <- ggplot(subset(ChickWeight, Time == 21), aes(x = weight, colour = Diet)) +
#'   geom_density() +
#'   ggtitle("Final weight, by diet") +
#'   theme_bw()
#' p4 <- ggplot(subset(ChickWeight, Time == 21), aes(x = weight, fill = Diet)) +
#'   geom_histogram(colour = "black", binwidth = 50) +
#'   facet_grid(Diet ~ .) +
#'   ggtitle("Final weight, by diet") +
#'   theme_bw()
#' cars_plot <- plot_histogram(mtcars[1:4])
#' plot_multiplot(p1, p2, p3, p4, cols = 2)
#' plot_multiplot(plotlist = plot_histogram(mtcars[, 1:4]), cols = 2)
#' plot_multiplot(plotlist = plot_histogram(mtcars), layout = matrix(1:4, ncol = 2, byrow = TRUE))
#' plot_multiplot(plotlist = cars_plot, layout = matrix(1:4, ncol = 2, byrow = TRUE))
#' plot_multiplot(plotlist = cars_plot, cols = 3)
plot_multiplot <- function(..., plotlist = NULL, cols = 2, layout = NULL) {
  p <- list()
  plots <- c(list(...), plotlist)
  nplots <- length(plots)
  if (is.null(layout)) {
    layout <- matrix(seq(1, cols * ceiling(nplots / cols)),
      ncol = cols,
      nrow = ceiling(nplots / cols), byrow = TRUE
    )
  }
  if (nplots == 1) {
    return(plots[[1]])
  } else {
    pages <- ceiling(nplots / max(layout))
    plots_per_page <- max(layout)
    counter <- 1
    for (page in 1:pages) {
      grid::grid.newpage()
      grid::pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
      for (i in 1:plots_per_page) {
        position <- as.data.frame(which(layout == i, arr.ind = TRUE))
        if (counter <= nplots) {
          print(plots[[counter]], vp = grid::viewport(layout.pos.row = position$row, layout.pos.col = position$col))
        }
        counter <- counter + 1
      }
      p[[page]] <- grDevices::recordPlot()
    }
  }
  invisible(lapply(p,print))
  return(invisible(p))
}
##########################################################################################
# DUPLICATE Y AXIS
##########################################################################################
#' @title Invert a title grob horizontally
#' @description Helper used by \code{duplicate_y_axis} to mirror a grob's
#'   width layout and text alignment so it renders correctly on the right-hand
#'   side of a plot.
#' @param grob A grob object (titleGrob or similar) to invert.
#' @return The modified grob.
#' @import grid gtable
#' @keywords functions plot
plot_hinvert_title_grob <- function(grob) {
  widths <- grob$widths
  grob$widths[1] <- widths[3]
  grob$widths[3] <- widths[1]
  if (!is.null(grob$vp)) {
    grob$vp[[1]]$layout$widths[1] <- widths[3]
    grob$vp[[1]]$layout$widths[3] <- widths[1]
  }
  grob$children[[1]]$hjust <- 1 - grob$children[[1]]$hjust
  grob$children[[1]]$vjust <- 1 - grob$children[[1]]$vjust
  grob$children[[1]]$x <- unit(1, "npc") - grob$children[[1]]$x
  grob
}
#' @title Duplicate the y axis on the right side of a ggplot
#' @description Takes two ggplot objects and renders \code{p1} with the y axis
#'   of \code{p2} mirrored onto the right side. Useful when overlaying two
#'   series with different scales or simply to frame the plot with matching
#'   axes on both sides.
#' @param p1 A ggplot object. This plot is drawn with the duplicated right axis.
#' @param p2 A ggplot object whose left y axis is mirrored to the right of
#'   \code{p1}. Typically the same as \code{p1}.
#' @return Invisibly returns \code{NULL}. The combined plot is drawn to the
#'   current graphics device.
#' @importFrom ggplot2 ggplotGrob
#' @importFrom gtable gtable_add_cols gtable_add_grob
#' @importFrom grid grid.newpage grid.draw unit
#' @keywords functions plot
#' @export
#' @examples
#' p1 <- ggplot(ChickWeight, aes(x = Time, y = weight, colour = Diet, group = Chick)) +
#'   geom_line() +
#'   ggtitle("Growth curve for individual chicks")
#' plot_duplicate_y_axis(p1 = p1, p2 = p1)
plot_duplicate_y_axis <- function(p1, p2) {
  name <- r <- NULL
  g1 <- ggplotGrob(p1)
  g2 <- ggplotGrob(p2)
  pp <- c(subset(g1$layout, name == "panel", se = t:r))
  index <- which(g2$layout$name == "ylab-l")
  if (length(index) > 0) {
    ylab <- g2$grobs[[index]]
    ylab <- plot_hinvert_title_grob(ylab)
    g1 <- gtable::gtable_add_cols(g1, g2$widths[g2$layout[index, ]$l], pp$r)
    g1 <- gtable::gtable_add_grob(g1, ylab, pp$t, pp$r + 1, pp$b, pp$r + 1, clip = "off", name = "ylab-r")
  }
  index <- which(g2$layout$name == "axis-l")
  yaxis <- g2$grobs[[index]]
  tg <- yaxis$children[[2]]
  tg$grobs[[1]]$x <- unit(1, "npc") - tg$grobs[[1]]$x
  tg$grobs[[2]] <- plot_hinvert_title_grob(tg$grobs[[2]])
  max_col <- max(c(tg$layout$l, tg$layout$r))
  tg$layout$l <- max_col + 1 - tg$layout$l
  tg$layout$r <- max_col + 1 - tg$layout$r
  swap <- tg$layout$l > tg$layout$r
  tmp <- tg$layout$l[swap]
  tg$layout$l[swap] <- tg$layout$r[swap]
  tg$layout$r[swap] <- tmp
  tg$widths <- rev(tg$widths)
  yaxis$children[[2]] <- tg
  g1 <- gtable::gtable_add_cols(g1, g2$widths[g2$layout[index, ]$l], pp$r)
  g1 <- gtable::gtable_add_grob(g1, yaxis, pp$t, pp$r + 1, pp$b, pp$r + 1, clip = "off", name = "axis-r")
  grid::grid.newpage()
  grid::grid.draw(g1)
}
##########################################################################################
# REPORT PDF
##########################################################################################
#' Save or display a list of plots as a multi-page PDF
#'
#' Writes one or more plot objects to a multi-page PDF file using
#' \code{cairo_pdf}, optionally also printing them to the
#' active graphics device.
#'
#' @param ... Plot objects passed directly (ggplot or recorded plots).
#' @param plotlist A list of plot objects. Combined with any plots passed via
#'   \code{...}.
#' @param file Character or \code{NULL}. Output filename without extension. If
#'   \code{NULL}, no PDF is written. Default is \code{NULL}.
#' @param title Character or \code{NULL}. Optional suffix appended to \code{file}
#'   (separated by an underscore) to form the final filename. Default is
#'   \code{NULL}.
#' @param w Numeric. Width of the PDF in inches. Default is \code{10}.
#' @param h Numeric. Height of the PDF in inches. Default is \code{10}.
#' @param print_plot Logical. If \code{TRUE}, plots are also printed to the active
#'   graphics device. Default is \code{TRUE}.
#'
#' @return Called for its side effects. Returns \code{NULL} invisibly.
#'
#' @importFrom grDevices cairo_pdf dev.off
#' @importFrom purrr walk
#'
#' @export
#' @examples
#' p1 <- ggplot(ChickWeight, aes(x = Time, y = weight, colour = Diet, group = Chick)) +
#'   geom_line() +
#'   ggtitle("Growth curve for individual chicks") +
#'   theme_bw()
#' p2 <- ggplot(ChickWeight, aes(x = Time, y = weight, colour = Diet)) +
#'   geom_point(alpha = .3) +
#'   geom_smooth(alpha = .2, size = 1, method = "loess", formula = "y~x") +
#'   ggtitle("Fitted growth curve per diet") +
#'   theme_bw()
#' cars_plot_multiplot <- plot_multiplot(plotlist = plot_histogram(mtcars[, 1:4]), cols = 2)
#' cars_plot_base <- plot_normality_diagnostics(mtcars)
#' report_pdf(p1, p2, print_plot = TRUE)
#' report_pdf(p1, p2, file = "report", print_plot = FALSE)
#' report_pdf(plotlist = cars_plot_multiplot, print_plot = TRUE)
#' report_pdf(plotlist = cars_plot_multiplot, file = "report", print_plot = FALSE)
#' report_pdf(plotlist = cars_plot_base, print_plot = TRUE)
#' report_pdf(plotlist = cars_plot_base, file = "report", print_plot = FALSE)
report_pdf <- function(..., plotlist = NULL, file = NULL, title = NULL, w = 10, h = 10, print_plot = TRUE) {
  plotlist <- c(list(...), plotlist)
  if (!is.null(title)) {
    title <- paste0("_", title)
  }
  if (!is.null(file)) {
    cairo_pdf(invisible(paste0(file, title, ".pdf")), onefile = TRUE, width = w, height = h)
    purrr::walk(plotlist, function(p) {
      print(p)
    })
    grDevices::dev.off()
  }
  if (print_plot) {
    purrr::walk(plotlist, function(p) {
      print(p)
    })
  }
}
