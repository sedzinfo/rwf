library(ggplot2)

# scores: named vector R, I, A, S, E, C; max: highest possible score per type
holland_point <- function(scores, max = 5) {
  s <- scores[c("R", "I", "A", "S", "E", "C")] / max   # 0..1, so a pure type sits on its vertex
  c(x = 1.73 * (s[["I"]] + s[["A"]] - s[["E"]] - s[["C"]]),
    y = 2 * s[["R"]] + s[["I"]] - s[["A"]] - 2 * s[["S"]] - s[["E"]] + s[["C"]])
}

plot_holland <- function(scores, max = 5, title = "Holland profile") {
  # hexagon vertices: radius 2, R on top, then clockwise I, A, S, E, C
  ang <- pi / 2 - (0:5) * pi / 3
  hex <- data.frame(type = c("Realistic", "Investigative", "Artistic", "Social", "Enterprising", "Conventional"),
                    x = 2 * cos(ang), y = 2 * sin(ang))
  # the person's 6 scores along the spokes (a radar shape inside the hexagon)
  s <- scores[c("R", "I", "A", "S", "E", "C")] / max
  prof <- data.frame(x = 2 * s * cos(ang), y = 2 * s * sin(ang))
  p <- holland_point(scores, max)
  ggplot() +
    geom_polygon(data = hex, aes(x, y), fill = NA, colour = "grey60", linetype = "dashed") +
    geom_polygon(data = prof, aes(x, y), fill = "#4A64FF", alpha = 0.25, colour = "#4A64FF") +
    geom_hline(yintercept = 0, colour = "grey85") + geom_vline(xintercept = 0, colour = "grey85") +
    geom_point(aes(p[["x"]], p[["y"]]), size = 5, colour = "#FF4C15") +
    geom_label(data = hex, aes(x, y, label = type), fill = "#D9604C", colour = "white", size = 10) +
    annotate("text", x = c(0, 0, -2.5, 2.5), y = c(2.4, -2.4, 0, 0),
             label = c("THINGS", "PEOPLE", "DATA", "IDEAS"), colour = "grey50", size = 5) +
    coord_equal(xlim = c(-2.8, 2.8), ylim = c(-2.6, 2.6)) +
    labs(title = title, subtitle = "Area: the six scores; dot: position on Prediger's dimensions") +
    theme_void()
}

scores=c(R = 2, I = 1, A = 1, S = 1, E = 5, C = 5)

plot_holland(c(R = 2, I = 1, A = 1, S = 1, E = 2, C = 2))
