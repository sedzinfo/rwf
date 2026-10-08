##########################################################################################
# MODEL PLOT
##########################################################################################
#' @title Plot CFA model (semPlot-free)
#' @param model A fitted lavaan object
#' @param what One of "std" (standardized), "est" (unstandardized), or "eq" (parameter labels)
#' @param layout One of "tree", "circle", or "spring"
#' @param label_size Size of node labels
#' @param edge_label_size Size of path coefficient labels
#' @param color_latent Fill colour for latent variable nodes
#' @param color_observed Fill colour for observed variable nodes
#' @param ... Ignored (kept for API compatibility with plot_cfa)
#' @return A named list of ggplot objects
#' @importFrom lavaan parameterEstimates lavNames
#' @importFrom ggplot2 ggplot aes geom_segment geom_curve geom_rect geom_text annotate coord_fixed theme_void theme labs scale_x_continuous scale_y_continuous
#' @importFrom igraph graph_from_data_frame layout_in_circle layout_as_tree layout_with_fr
#' @export
#' @examples
#' model='LATENT1=~X1+X2+X3
#'        LATENT2=~X4+X5+X6'
#' df<-lavaan::simulateData(model=model,model.type="cfa",
#'                              return.type="data.frame",sample.nobs=100)
#' df<-generate_missing(df)
#' fit<-lavaan::cfa(model,data=df,missing="ML")
#' plot_cfa_gg(fit,what="std")
#' plot_cfa_gg(fit,what="std",layout="tree")
#' plot_cfa_gg(fit,what="std",layout="circle")
#' plot_cfa_gg(fit,what="std",layout="spring")
plot_cfa_gg <- function(model,
                        what        = c("std", "est", "eq"),
                        layout      = c("tree", "circle", "spring"),
                        label_size      = 3.2,
                        edge_label_size = 2.6,
                        color_latent    = "#4f8ef7",
                        color_observed  = "#e8eaf0",
                        ...) {
  hh<-hw<-mx<-my<-name<-x<-x_from<-x_to<-y<-y_from<-y_to<-NULL
  
  
  what   <- match.arg(what)
  layout <- match.arg(layout)
  
  # -- 1. Extract parameter table -------------------------------------------
  pe <- lavaan::parameterEstimates(model, standardized = TRUE)
  
  # Choose which column to display on edges
  edge_col <- switch(what,
                     std = "std.all",
                     est = "est",
                     eq  = "label"
  )
  
  # -- 2. Identify nodes ----------------------------------------------------
  latent_vars   <- unique(pe$lhs[pe$op == "=~"])
  observed_vars <- unique(pe$rhs[pe$op == "=~"])
  all_nodes     <- unique(c(latent_vars, observed_vars))
  
  node_df <- data.frame(
    name    = all_nodes,
    is_lat  = all_nodes %in% latent_vars,
    stringsAsFactors = FALSE
  )
  
  # -- 3. Compute node layout -----------------------------------------------
  # Build an igraph just for layout purposes
  edge_list <- pe[pe$op %in% c("=~", "~"), c("lhs","rhs"), drop=FALSE]
  edge_list <- edge_list[edge_list$lhs %in% all_nodes &
                           edge_list$rhs %in% all_nodes, ]
  
  g <- igraph::graph_from_data_frame(
    d        = edge_list,
    directed = TRUE,
    vertices = node_df
  )
  
  coords <- switch(layout,
                   circle = igraph::layout_in_circle(g),
                   tree   = {
                     # root = latent variables
                     roots <- which(igraph::V(g)$name %in% latent_vars)
                     igraph::layout_as_tree(g, root = roots, flip.y = TRUE)
                   },
                   spring = igraph::layout_with_fr(g, niter = 1000)
  )
  
  node_df$x <- coords[, 1]
  node_df$y <- coords[, 2]
  
  # normalise to [0,10] for stable sizing
  rng_x <- range(node_df$x); rng_y <- range(node_df$y)
  safe_scale <- function(v, rng) {
    if (diff(rng) == 0) rep(5, length(v)) else (v - rng[1]) / diff(rng) * 10
  }
  node_df$x <- safe_scale(node_df$x, rng_x)
  node_df$y <- safe_scale(node_df$y, rng_y)
  
  # node half-dimensions
  node_df$hw <- ifelse(node_df$is_lat, 0.90, 0.70)   # half-width
  node_df$hh <- ifelse(node_df$is_lat, 0.55, 0.42)   # half-height
  
  # -- 4. Build edge data for factor loadings (=~) --------------------------
  loadings <- pe[pe$op == "=~", ]
  
  edge_df <- merge(
    loadings,
    node_df[, c("name","x","y")],
    by.x = "lhs", by.y = "name"
  )
  names(edge_df)[names(edge_df) %in% c("x","y")] <- c("x_from","y_from")
  
  edge_df <- merge(
    edge_df,
    node_df[, c("name","x","y")],
    by.x = "rhs", by.y = "name"
  )
  names(edge_df)[names(edge_df) %in% c("x","y")] <- c("x_to","y_to")
  
  # label to display
  edge_df$display <- if (what == "eq") {
    ifelse(is.na(edge_df$label) | edge_df$label == "",
           formatC(edge_df$est, digits = 3, format = "f"),
           edge_df$label)
  } else {
    formatC(edge_df[[edge_col]], digits = 3, format = "f")
  }
  
  # midpoints for edge labels
  edge_df$mx <- (edge_df$x_from + edge_df$x_to) / 2
  edge_df$my <- (edge_df$y_from + edge_df$y_to) / 2
  
  # -- 5. Covariance arcs between latent variables --------------------------
  cov_df <- pe[pe$op == "~~" & pe$lhs != pe$rhs &
                 pe$lhs %in% latent_vars & pe$rhs %in% latent_vars, ]
  
  if (nrow(cov_df) > 0) {
    cov_df <- merge(cov_df, node_df[, c("name","x","y")],
                    by.x = "lhs", by.y = "name")
    names(cov_df)[names(cov_df) %in% c("x","y")] <- c("x_from","y_from")
    cov_df <- merge(cov_df, node_df[, c("name","x","y")],
                    by.x = "rhs", by.y = "name")
    names(cov_df)[names(cov_df) %in% c("x","y")] <- c("x_to","y_to")
    cov_df$display <- formatC(cov_df[[edge_col]], digits = 3, format = "f")
    cov_df$mx <- (cov_df$x_from + cov_df$x_to) / 2
    cov_df$my <- (cov_df$y_from + cov_df$y_to) / 2
  }
  
  # -- 6. Build plot --------------------------------------------------------
  plot_title <- switch(what,
                       std = "Standardised Estimates",
                       est = "Unstandardised Estimates",
                       eq  = "Parameters with Equality Constraints"
  )
  
  p <- ggplot2::ggplot() +
    
    # factor loading edges
    ggplot2::geom_segment(
      data = edge_df,
      ggplot2::aes(x = x_from, y = y_from, xend = x_to, yend = y_to),
      colour   = "#555a6b",
      linewidth = 0.55,
      arrow = ggplot2::arrow(length = ggplot2::unit(6, "pt"),
                             type = "closed", ends = "last")
    ) +
    
    # loading labels
    ggplot2::geom_label(
      data = edge_df,
      ggplot2::aes(x = mx, y = my, label = .data$display),
      size      = edge_label_size,
      fill      = "white",
      label.size = 0,
      label.padding = ggplot2::unit(1.5, "pt"),
      colour    = "#333745"
    ) +
    
    # node rectangles - observed
    ggplot2::geom_rect(
      data = node_df[!node_df$is_lat, ],
      ggplot2::aes(
        xmin = x - hw, xmax = x + hw,
        ymin = y - hh, ymax = y + hh
      ),
      fill   = color_observed,
      colour = "#8890a8",
      linewidth = 0.4
    ) +
    
    # node ellipses - latent (drawn as wider rounded rects via annotate_custom;
    # simplest portable approach: just use distinctly-coloured rects)
    ggplot2::geom_rect(
      data = node_df[node_df$is_lat, ],
      ggplot2::aes(
        xmin = x - hw, xmax = x + hw,
        ymin = y - hh, ymax = y + hh
      ),
      fill   = color_latent,
      colour = "#2a5cc7",
      linewidth = 0.5
    ) +
    
    # node labels - observed
    ggplot2::geom_text(
      data   = node_df[!node_df$is_lat, ],
      ggplot2::aes(x = x, y = y, label = name),
      size   = label_size,
      colour = "#222533",
      fontface = "plain"
    ) +
    
    # node labels - latent
    ggplot2::geom_text(
      data   = node_df[node_df$is_lat, ],
      ggplot2::aes(x = x, y = y, label = name),
      size   = label_size,
      colour = "white",
      fontface = "bold"
    ) +
    
    ggplot2::coord_fixed(clip = "off") +
    ggplot2::theme_void(base_size = 11) +
    ggplot2::theme(
      plot.title   = ggplot2::element_text(
        hjust = 0.5, size = 12, margin = ggplot2::margin(b = 8)),
      plot.margin  = ggplot2::margin(20, 20, 20, 20)
    ) +
    ggplot2::labs(title = paste0(plot_title, " \u2014 ", layout))
  
  # add covariance arcs if present
  if (nrow(cov_df) > 0) {
    p <- p +
      ggplot2::geom_curve(
        data = cov_df,
        ggplot2::aes(x = x_from, y = y_from, xend = x_to, yend = y_to),
        curvature = 0.35,
        colour    = "#e87c4f",
        linewidth  = 0.5,
        linetype  = "dashed",
        arrow = ggplot2::arrow(length = ggplot2::unit(5, "pt"),
                               type = "open", ends = "both")
      ) +
      ggplot2::geom_label(
        data = cov_df,
        ggplot2::aes(x = mx, y = my, label = .data$display),
        size      = edge_label_size,
        fill      = "#fff5f0",
        label.size = 0,
        colour    = "#993c1d"
      )
  }
  
  return(p)
}
##########################################################################################
# MODEL PLOT
##########################################################################################
#' @title Batch-plot CFA across layouts and display modes
#' @description Drop-in replacement for \code{plot_cfa()} - same signature,
#'   returns a named list of ggplot objects instead of base-graphics recordings.
#' @param model A fitted lavaan object
#' @param ... Extra arguments forwarded to \code{plot_cfa_gg()}
#' @return Named list of ggplot objects (same keys as the original \code{plot_cfa})
#' @export
plot_cfa <- function(model, ...) {
  
  layouts  <- c("circle", "tree", "spring")
  whats    <- c("est", "std", "eq")
  what_key <- c(est = "estimates",
                std = "standard_estimates",
                eq  = "parameters_wih_equality_constraints")
  
  plots <- list()
  
  for (lay in layouts) {
    for (wh in whats) {
      key <- paste0(lay, "_", what_key[[wh]])
      plots[[key]] <- tryCatch(
        plot_cfa_gg(model, what = wh, layout = lay, ...),
        error = function(e) {
          message(sprintf("Skipping %s: %s", key, conditionMessage(e)))
          NULL
        }
      )
    }
  }
  
  plots <- Filter(Negate(is.null), plots)
  return(plots)
}
##########################################################################################
# MODEL
##########################################################################################
#' @title Report
#' @param model lavaan object
#' @param file output filename
#' @param w width of pdf file
#' @param h height of pdf file
#' @importFrom stats predict
#' @importFrom lavaan inspect parameterEstimates modificationIndices
#' @importFrom stringr str_replace_all fixed
#' @importFrom openxlsx createWorkbook saveWorkbook
#' @keywords SEM
#' @export
#' @examples
#' model='LATENT=~ITEM1+ITEM2+ITEM3+ITEM4+ITEM5'
#' df<-lavaan::simulateData(model=model,model.type="cfa",
#'                              return.type="data.frame",sample.nobs=100)
#' df<-generate_missing(df)
#' fit<-lavaan::cfa(model,data=df,missing="ML")
#' report_cfa(fit)
#' report_cfa(fit,file="cfa")
report_cfa<-function(model,file=NULL,w=10,h=10) {
  pt<-options(fit=c("GFI","AGFI","RMSEA","NFI","NNFI","CFI","RNI","IFI","SRMR","AIC","AICc","BIC","CAIC"))
  r_squared<-data.frame(r_squared=lavaan::inspect(model,"rsquare",add.labels=TRUE,add.class=TRUE,list.by.group=TRUE,drop.list.single.group=TRUE))
  fit<-data.frame(fit=lavaan::inspect(model,"fit",add.labels=TRUE,add.class=TRUE,list.by.group=TRUE,drop.list.single.group=TRUE))
  unstandardized_estimates<-lavaan::inspect(model,"est",add.labels=TRUE,add.class=TRUE,list.by.group=TRUE,drop.list.single.group=TRUE)
  standardized_estimates<-lavaan::inspect(model,"std",add.labels=TRUE,add.class=TRUE,list.by.group=TRUE,drop.list.single.group=TRUE)
  group<-data.frame()
  if(model@Model@ngroups>1) {
    group<-data.frame(data.frame(GROUP_COLLUMN=lavaan::inspect(model,what="group",add.labels=TRUE,add.class=TRUE,list.by.group=TRUE,drop.list.single.group=TRUE)),
                      data.frame(GROUPS=lavaan::inspect(model,what="group.label",add.labels=TRUE,add.class=TRUE,list.by.group=TRUE,drop.list.single.group=TRUE)),
                      data.frame(NGROUPS=lavaan::inspect(model,what="ngroups",add.labels=TRUE,add.class=TRUE,list.by.group=TRUE,drop.list.single.group=TRUE)),
                      data.frame(OBSERVATIONS=lavaan::inspect(model,what="nobs",add.labels=TRUE,add.class=TRUE,list.by.group=TRUE,drop.list.single.group=TRUE)),
                      data.frame(ORIGINAL_OBSERVATIONS=lavaan::inspect(model,what="norig",add.labels=TRUE,add.class=TRUE,list.by.group=TRUE,drop.list.single.group=TRUE)),
                      data.frame(TOTAL=lavaan::inspect(model,what="ntotal",add.labels=TRUE,add.class=TRUE,list.by.group=TRUE,drop.list.single.group=TRUE)))
  }
  parameters<-data.frame(lavaan::parameterEstimates(model,se=TRUE,zstat=TRUE,pvalue=TRUE,ci=TRUE,level=0.95,boot.ci.type="perc",standardized=TRUE,fmi=FALSE,remove.system.eq=TRUE,remove.eq=FALSE,remove.ineq=FALSE,remove.def=FALSE,rsquare=TRUE,add.attributes=TRUE))
  modification_indices<-data.frame(lavaan::modificationIndices(model,standardized=TRUE,cov.std=TRUE,information="expected",power=TRUE,delta=0.1,alpha=0.05,high.power=0.75,sort.=TRUE,minimum.value=0,free.remove=FALSE,na.remove=TRUE,op=NULL))
  sample_covariance<-data.frame(model@SampleStats@cov)
  if(typeof(lavaan::predict(model))=="list")
    predict<-data.frame(do.call(rbind.data.frame,model@Data@X),do.call(rbind.data.frame,lavaan::predict(model)))
  else
    predict<-data.frame(model@Data@X,lavaan::predict(model))
  call<-data.frame(call=stringr::str_replace_all(deparse(model@call),stringr::fixed(" "),""),stringsAsFactors=FALSE)
  result<-list(r_squared=r_squared,fit_indices=fit,parameters=parameters,modification_indices=modification_indices,sample_covariance=sample_covariance,
               unstandardized_estimates=unstandardized_estimates,standardized_estimates=standardized_estimates,group=group,predict=predict,call=call)
  
  plot<-plot_cfa(model)
  report_pdf(plotlist=plot,file=file,title="diagram",w=w,h=h,print_plot=TRUE)
  write_txt({
    output_separator("SUMMARY",output=lavaan::summary(model,standardized=TRUE,fit.measures=TRUE,rsquare=TRUE))
    output_separator("R_SQUARED",output=data.frame(result$r_squared))
    output_separator("FIT INDICES",output=data.frame(result$fit_indices))
    output_separator("PARAMETERS",output=result$parameters)
    output_separator("UNSTANDARDIZED PARAMETERS",output=result$unstandardized_estimates)
    output_separator("STANDARDIZED PARAMETERS",output=result$standardized_estimates)
    output_separator("SAMPLE COVARIANCE",output=result$sample_covariance)
    output_separator("CALL",output=result$call$call)
  },file=file)
  if(!is.null(file)){
    filename<-paste0(file,".xlsx")
    if (file.exists(filename)) file.remove(filename)
    wb<-openxlsx::createWorkbook()
    excel_critical_value(result$r_squared,workbook=wb,sheet="R_Squared",numFmt="#0.00")
    excel_critical_value(result$fit_indices,workbook=wb,sheet="Fit_Indices",numFmt="#0.00")
    excel_critical_value(result$parameters,workbook=wb,sheet="Parameters",numFmt="#0.00")
    excel_critical_value(result$modification_indices,workbook=wb,sheet="Modification_Indices",numFmt="#0.00")
    excel_critical_value(result$group,workbook=wb,sheet="Groups",numFmt="#0.00")
    excel_matrix(result$sample_covariance,workbook=wb,sheet="Sample_Covariance",numFmt="#0.00")
    excel_matrix(result$predict,workbook=wb,sheet="Scores",numFmt="#0.00")
    excel_critical_value(result$call,workbook=wb,sheet="Call",numFmt="#0.00")
    openxlsx::saveWorkbook(wb=wb,file=filename,overwrite=TRUE)
  }
  return(result)
}
##########################################################################################
# SIMULATE CFA FROM FROM COEFFICIENTS
##########################################################################################
#' @title Simulate CFA model fit across sample sizes
#' @description Runs a confirmatory factor analysis (CFA) repeatedly across a
#'   range of sample sizes and returns fit indices for each. Useful for power
#'   analysis and sample size planning in SEM.
#'
#'   Two workflows are supported:
#'   \itemize{
#'     \item \strong{Coefficient-based}: supply \code{model_sim} with fixed
#'       loadings - data are generated from those population parameters at each
#'       sample size.
#'     \item \strong{Correlation-based}: supply \code{df} - data are
#'       bootstrapped from the observed correlation structure of \code{df} at
#'       each sample size.
#'   }
#'   Iterations run in parallel via \code{future.apply}. Results are written to
#'   a PDF (scatter plots of fit indices vs. sample size) and an Excel file.
#'
#' @param model_sim A \code{lavaan} model string with fixed coefficients (e.g.
#'   \code{"F =~ 1*x1 + 0.8*x2"}). Used to generate population data. Mutually
#'   exclusive with \code{df}; supply one or the other.
#' @param model A \code{lavaan} model string with free coefficients specifying
#'   the CFA structure to be estimated at each sample size (e.g.
#'   \code{"F =~ x1 + x2"}).
#' @param df A data frame of observed data. When supplied, each iteration
#'   simulates data by sampling from the observed correlation structure.
#'   Mutually exclusive with \code{model_sim}.
#' @param minnobs Integer. Smallest sample size to evaluate. Default \code{50}.
#' @param maxnobs Integer. Largest sample size to evaluate. Default \code{1000}.
#' @param stepping Integer. Increment between sample sizes. Default \code{10}.
#' @param file Character. Base name (without extension) for the output PDF and
#'   Excel files. If \code{NULL} no files are written.
#' @param w Numeric. Width of the output PDF in inches. Default \code{10}.
#' @param h Numeric. Height of the output PDF in inches. Default \code{10}.
#'
#' @return A list of two elements:
#'   \itemize{
#'     \item \code{[[1]]} - a data frame with one row per sample size and one
#'       column per lavaan fit index (CFI, RMSEA, SRMR, etc.).
#'     \item \code{[[2]]} - a named list of ggplot scatter plots, one per fit
#'       index, showing how the index changes with sample size.
#'   }
#'
#' @importFrom future plan multisession sequential
#' @importFrom future.apply future_lapply
#' @importFrom parallel detectCores
#' @keywords SEM
#' @export
#' @examples
#' model_sim <- 'LATENT =~ 1*X1 + 0.5*X2 + 1.5*X3 + 1.5*X4 + X5'
#' model     <- 'LATENT =~ X1 + X2 + X3 + X4 + X5'
#'
#' # Coefficient-based: generate data from known population parameters
#' result<-simulate_cfa_fit(model_sim=model_sim, model=model,
#'                          minnobs=50, maxnobs=1000, stepping=100, file="report")
#' plot_multiplot(plotlist=result[[2]], cols=4)
#' # Correlation-based: resample from observed data
#' df <- lavaan::simulateData(model=model_sim, model.type="cfa",
#'                            return.type="data.frame", sample.nobs=1000)
#' result<-simulate_cfa_fit(model=model, df=df,
#'                          minnobs=50, maxnobs=10000, stepping=100, file="report")
#' plot_multiplot(plotlist=result[[2]], cols=4)
simulate_cfa_fit<-function(model_sim=NULL,model=NULL,df=NULL,minnobs=50,maxnobs=1000,stepping=10,file=NULL,w=10,h=10) {
  sequence<-seq(from=minnobs,to=maxnobs,by=stepping)
  future::plan(future::multisession,workers=parallel::detectCores())
  sim_results<-do.call(rbind,future.apply::future_lapply(sequence,function(nobs) {
    if(!is.null(model_sim))
      sim<-lavaan::simulateData(model=model_sim,model.type="cfa",return.type="data.frame",sample.nobs=nobs,orthogonal=TRUE)
    if(!is.null(df))
      sim<-rwf::simulate_correlation_from_sample(df,nrows=nobs)
    fit<-lavaan::cfa(model,data=sim)
    fit_indices<-data.frame(FIT=lavaan::inspect(fit,"fit"))
    data.frame(observations=nobs,data.frame(t(fit_indices)),row.names=NULL)
  },future.seed=TRUE))
  future::plan(future::sequential)
  plot_data<-remove_nc(sim_results,remove_rows=TRUE,aggressive=FALSE,remove_cols=TRUE,remove_zero_variance=TRUE)
  combinations<-data.frame(X1=rep("observations",length(names(plot_data))),X2=names(plot_data),stringsAsFactors=FALSE)
  plots<-plot_scatterplot(df=plot_data,combinations=combinations)
  report_dataframe(sim_results,sheet="simulation",file=file)
  report_pdf(plotlist=plots,w=w,h=h,file=file)
  return(list(sim_results,plots))
}
