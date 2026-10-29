##########################################################################################
# FERTILITY MAP GIF
##########################################################################################
library(dplyr)
library(ggplot2)
library(gifski)

data_file <- "~/GitHub/vignettes/quarto/illustration/R/mfi_fertility.rds"   # read only
gif_file  <- "~/Desktop/fertility_map.gif"

replacement <- 2.1
lo <- 0.5
hi <- 8
##########################################################################################
# DATA
##########################################################################################
fertility <- readRDS(path.expand(data_file)) %>%
  filter(`Indicator Name` == "Fertility rate, total (births per woman)") %>%
  transmute(code = `Country Code`, year = as.numeric(as.character(Year)), value)

world <- map_data("world") %>% filter(region != "Antarctica")
islands <- c(Kosovo = "XKX", `Canary Islands` = "ESP", `Madeira Islands` = "PRT", Azores = "PRT",
             Micronesia = "FSM", Barbuda = "ATG", Grenadines = "VCT")
regions <- unique(world$region)
world$code <- countrycode::countrycode(regions, "country.name", "iso3c", warn = FALSE,
                                       custom_match = islands)[match(world$region, regions)]
##########################################################################################
# ONE YEAR'S MAP
##########################################################################################
fertility_map <- function(y) {
  d <- fertility %>% filter(year == y)
  ggplot(left_join(world, d, by = "code"), aes(long, lat, group = group, fill = value)) +
    geom_polygon(colour = "#0F1923", linewidth = 0.1) +
    annotate("text", x = -165, y = -45, label = y, hjust = 0,                 # the big year
             size = 30, colour = "white", alpha = 0.15, fontface = "bold") +
    # two colour ramps that meet at 2.1: light blue just below it, light red just above
    scale_fill_gradientn(colours = c("#08306b", "#2171b5", "#9ecae1", "#fcae91", "#de2d26", "#99000d"),
                         values = scales::rescale(c(lo, 1.3, replacement, replacement + 0.001, 4.5, hi),
                                                  from = c(lo, hi)),
                         limits = c(lo, hi),
                         oob = scales::squish, breaks = c(1, 2.1, 4, 6, 8),
                         na.value = "#2a3b4c", name = "children per woman") +
    coord_quickmap(xlim = c(-170, 190), ylim = c(-56, 84), expand = FALSE) +
    labs(title = "Children per woman: red above 2.1, blue below",
         caption = "Source: World Bank, World Development Indicators, via golemworldbank") +
    theme_void(base_size = 13) +
    theme(plot.background   = element_rect(fill = "#0F1923", colour = NA),
          plot.title        = element_text(colour = "white", face = "bold", margin = margin(10, 0, 6, 10)),
          plot.caption      = element_text(colour = "#546E7A", size = 9, margin = margin(6, 10, 8, 0)),
          legend.position   = "bottom",
          legend.title      = element_text(colour = "#90A4AE", vjust = 0.8),
          legend.text       = element_text(colour = "#90A4AE"),
          legend.key.width  = unit(2.5, "cm"),
          legend.key.height = unit(0.35, "cm"))
}
##########################################################################################
# GIF
##########################################################################################
years  <- sort(unique(fertility$year))
frames <- file.path(tempdir(), sprintf("fertility_%03d.png", seq_along(years)))
for (i in seq_along(years)) {
  ragg::agg_png(frames[i], width = 1500, height = 800, res = 100, background = "#0F1923")   # no white bands
  print(fertility_map(years[i]))
  dev.off()
}
gifski(c(frames, rep(tail(frames, 1), 13)), path.expand(gif_file), width = 1000, height = 620, delay = 0.15)
cat("GIF written to", gif_file, "\n")


