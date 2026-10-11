render_all_rmd <- function(path = ".",
                           output_format = "html_document",
                           recursive = FALSE) {
  
  files <- list.files(
    path = path,
    pattern = "\\.rmd$",
    recursive = recursive,
    full.names = TRUE
  )
  
  if (length(files) == 0) {
    message("No Rmd files found.")
    return(invisible(NULL))
  }
  
  for (f in files) {
    message("Rendering: ", basename(f))
    
    tryCatch(
      rmarkdown::render(
        input = f,
        knit_root_dir=path,
        output_format = output_format,
        envir = new.env(parent = globalenv())
      ),
      error = function(e) {
        message("Failed: ", basename(f))
        message("  ", e$message)
      }
    )
  }
  
  invisible(files)
}

directory<-paste0(dirname(rstudioapi::getActiveDocumentContext()$path),"/")
render_all_rmd(path="C:/Users/dzach/Documents/GitHub/rwf/vignettes/")




list.files("C:/Users/dzach/Documents/GitHub/rwf", recursive = TRUE)
