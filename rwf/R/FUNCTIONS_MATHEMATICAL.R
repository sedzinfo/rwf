##########################################################################################
# ANGLE RADIANS TO DEGREES
##########################################################################################
#' @title Convert radians to degrees
#' @param radians radians
#' @keywords correlation
#' @export
#' @examples
#' rad2deg(pi)
rad2deg <- function(radians) {
  (radians * 180) / (pi)
}
##########################################################################################
# ANGLE DEGREES TO RADIANS
##########################################################################################
#' @title Convert degrees to radians
#' @param degrees degrees
#' @keywords correlation
#' @export
#' @examples
#' deg2rad(180)
deg2rad <- function(degrees) {
  (degrees * pi) / (180)
}
