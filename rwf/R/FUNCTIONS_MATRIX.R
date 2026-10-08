##########################################################################################
# MATRIX DISPLAY DIAGONAL
##########################################################################################
#' Extract the upper or lower triangle of a matrix
#'
#' Returns a matrix with the off-triangle values replaced by a fill value,
#' optionally overriding the diagonal. Useful for displaying correlation or
#' covariance matrices without redundant values.
#'
#' @param m A numeric matrix or object coercible to one.
#' @param off_diagonal Value to fill the suppressed triangle with. Default is \code{NA}.
#' @param diagonal Value to place on the diagonal. If \code{NULL}, the original
#'   diagonal of \code{m} is preserved. Default is \code{NULL}.
#' @param type Character. Which triangle to retain. One of \code{"lower"} or
#'   \code{"upper"}. Default is \code{"lower"}.
#'
#' @return A matrix of the same dimensions as \code{m}, with the off-triangle
#'   filled by \code{off_diagonal} and the diagonal set by \code{diagonal}.
#'
#' @export
#' @examples
#' m<-matrix(1:9,nrow=3,ncol=3)
#' matrix_triangle(m=m)
#' matrix_triangle(m=m,diagonal=NA,type="lower")
#' matrix_triangle(m=m,diagonal=NULL,type="lower")
#' matrix_triangle(m=m,diagonal=NA,type="upper")
#' matrix_triangle(m=m,diagonal=NULL,type="upper")
matrix_triangle<-function(m,off_diagonal=NA,diagonal=NULL,type="lower") {
  m<-as.matrix(m)
  if (!is.null(dim(m))) {
    matrix_diagonal<-diag(m)
    if(type=="lower") {
      md<-lower.tri(m,diag=TRUE)*m
      md[upper.tri(md)]<-off_diagonal
    }
    if(type=="upper") {
      md<-upper.tri(m,diag=TRUE)*m
      md[lower.tri(md)]<-off_diagonal
    }
    if(!is.null(diagonal))
      diag(md)<-diagonal
    return(md)
  } else
    return(m)
}
##########################################################################################
# MATRIX DISPLAY UPPER LOWER TRIANGLE
##########################################################################################
#' @title Return upper diagonal from one matrix and lower diagonal from another matrix
#' @param m_upper matrix
#' @param m_lower matrix
#' @param diagonal if "upper" it returns upper diagonal if "lower" it returns lower diagonal if NA returns NA in diagonal otherwise it returns any value specified
#' @keywords functions matrix
#' @export
#' @examples
#' m1<-matrix(1:9,nrow=3,ncol=3)
#' m2<-matrix(11:19,nrow=3,ncol=3)
#' display_upper_lower_triangle(m_upper=m1,m_lower=m2,diagonal="upper")
#' display_upper_lower_triangle(m_upper=m1,m_lower=m2,diagonal="lower")
#' display_upper_lower_triangle(m_upper=m1,m_lower=m2,diagonal=NA)
#' display_upper_lower_triangle(m_upper=m1,m_lower=m2,diagonal=1)
#' display_upper_lower_triangle(m_upper=m1,m_lower=m2,diagonal=c("X1","X2","X3"))
#' display_upper_lower_triangle(m_upper=m1,m_lower=m2,diagonal=c(1,2,3))
#' display_upper_lower_triangle(m_upper=m1,m2)
display_upper_lower_triangle<-function(m_upper,m_lower,diagonal=NA) {
  upper<-matrix_triangle(m_upper,diagonal=NULL,type="upper")
  lower<-matrix_triangle(m_lower,diagonal=NULL,type="lower")
  lower[upper.tri(lower)]<-upper[upper.tri(upper)]
  m<-as.matrix(data.frame(lower))
  if(unique(is.na(diagonal)))
    diag(m)<-NA
  else if(unique(diagonal=="upper"))
    diag(m)<-diag(m_upper)
  else if(unique(diagonal=="lower"))
    diag(m)<-diag(m_lower)
  else
    diag(m)<-diagonal
  return(m)
}
##########################################################################################
# MAKE SYMMETRIC MATRIX
##########################################################################################
#' Make a symmetric matrix by duplicating one triangle
#'
#' Mirrors either the lower or upper triangle of a matrix to the opposite side,
#' producing a symmetric matrix. Optionally sets the diagonal.
#'
#' @param matrix A square numeric matrix.
#' @param duplicate Character. Which triangle to use as the source. One of:
#'   \code{"lower"} mirrors the lower triangle to the upper, or \code{"upper"}
#'   mirrors the upper triangle to the lower. Default is \code{"lower"}.
#' @param diagonal Value to place on the diagonal. If omitted, the original
#'   diagonal of \code{matrix} is preserved. Pass \code{NA} to fill with
#'   \code{NA}.
#'
#' @return A symmetric matrix of the same dimensions as the input.
#'
#' @seealso \code{\link{matrix_triangle}}
#'
#' @export
#' @examples
#' m_lower<-matrix_triangle(matrix(1:9,nrow=3,ncol=3),type="lower",diagonal=NA)
#' m_upper<-matrix_triangle(matrix(11:19,nrow=3,ncol=3),type="upper",diagonal=NA)
#' symmetric_matrix(matrix=m_lower,duplicate="lower",diagonal=NA)
#' symmetric_matrix(matrix=m_upper,duplicate="upper",diagonal=NA)
symmetric_matrix<-function(matrix,duplicate="lower",diagonal=NULL) {
  if (missing(diagonal))
    diagonal<-diag(matrix)
  if(duplicate=="lower")
    matrix[upper.tri(matrix)]<-t(matrix)[upper.tri(matrix)]
  if(duplicate=="upper")
    matrix[lower.tri(matrix)]<-t(matrix)[lower.tri(matrix)]
  rownames(matrix)<-colnames(matrix)
  diag(matrix)<-diagonal
  return(matrix)
}
##########################################################################################
# INDEX OFF DIAGONAL
##########################################################################################
#' Get off-diagonal indices for a square matrix
#'
#' Returns a data frame of row/column index pairs for navigating just above and
#' below the diagonal, useful for accessing or modifying off-diagonal neighbours.
#'
#' @param length Integer. The size of the diagonal (i.e. number of rows/columns
#'   in the square matrix).
#'
#' @return A data frame with \code{length} rows and four columns:
#'   \describe{
#'     \item{x1}{Row index.}
#'     \item{x2}{Column index (same as \code{x1}, i.e. the diagonal position).}
#'     \item{x3}{Index of the element just above (\code{i + 1}).}
#'     \item{x4}{Index of the element just below (\code{i - 1}).}
#'   }
#'
#' @export
#' @examples
#' off_diagonal_index(length=6)
off_diagonal_index<-function(length){
  index<-data.frame(x1=0,x2=0,x3=0,x4=0)
  for (i in 1:length) {
    p<-i+1
    m<-i-1
    index[i,]=c(i,i,p,m)
  }
  return(index)
}

