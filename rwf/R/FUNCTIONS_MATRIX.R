##########################################################################################
# MATRIX DISPLAY DIAGONAL
##########################################################################################
#' Keep the lower or upper triangle of a matrix
#'
#' Keeps one triangle of a matrix, including the diagonal, and fills the other
#' triangle with \code{off_diagonal}; optionally replaces the diagonal. Useful
#' for displaying correlation or covariance matrices without repeated values.
#'
#' @param m A numeric matrix, or an object that \code{as.matrix()} turns into
#'   a numeric matrix (e.g. a data frame of numbers).
#' @param off_diagonal Value used to fill the dropped triangle. Default
#'   \code{NA}.
#' @param diagonal Value(s) to place on the diagonal: a single value or one
#'   value per diagonal element. If \code{NULL} (default), the original
#'   diagonal is kept.
#' @param type Character, \code{"lower"} (default) or \code{"upper"}: the
#'   triangle to keep.
#'
#' @return A numeric matrix with the same dimensions and row / column names as
#'   \code{m}.
#'
#' @seealso \code{\link{display_upper_lower_triangle}},
#'   \code{\link{symmetric_matrix}}
#' @keywords functions matrix
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
#' Combine the upper triangle of one matrix with the lower triangle of another
#'
#' Builds a matrix whose upper triangle comes from \code{m_upper} and whose
#' lower triangle comes from \code{m_lower}, e.g. to show two correlation
#' matrices, or correlations and p values, in a single table.
#'
#' @param m_upper A square numeric matrix (or an object that \code{as.matrix()}
#'   turns into one) supplying the upper triangle.
#' @param m_lower A square numeric matrix of the same size supplying the lower
#'   triangle.
#' @param diagonal What to place on the diagonal: \code{NA} (default) for
#'   \code{NA}, \code{"upper"} for the diagonal of \code{m_upper},
#'   \code{"lower"} for the diagonal of \code{m_lower}, or any other value(s),
#'   either a single value or one value per diagonal element.
#'
#' @return A matrix with the dimensions and row / column names of
#'   \code{m_lower}. It is numeric, unless \code{diagonal} contains text, in
#'   which case the whole matrix becomes character.
#'
#' @seealso \code{\link{matrix_triangle}}, \code{\link{symmetric_matrix}}
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
  m<-as.matrix(lower)
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
#' Make a matrix symmetric by mirroring one triangle
#'
#' Copies the lower or upper triangle of a square matrix onto the opposite
#' triangle, producing a symmetric matrix; optionally replaces the diagonal.
#' The row names are set to the column names, so both sides carry the same
#' labels.
#'
#' @param matrix A square matrix. Unlike \code{\link{matrix_triangle}}, a data
#'   frame is not accepted; convert it with \code{as.matrix()} first.
#' @param duplicate Character, \code{"lower"} (default) to copy the lower
#'   triangle into the upper, or \code{"upper"} to copy the upper triangle
#'   into the lower.
#' @param diagonal Value(s) to place on the diagonal: a single value (e.g.
#'   \code{NA}) or one value per diagonal element. Leave it out to keep the
#'   original diagonal; passing \code{NULL} explicitly is an error.
#'
#' @return A symmetric matrix with the same dimensions as \code{matrix}, whose
#'   row names are the column names of \code{matrix}.
#'
#' @seealso \code{\link{matrix_triangle}},
#'   \code{\link{display_upper_lower_triangle}}
#' @keywords functions matrix
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
#' Row and column indices around the diagonal of a square matrix
#'
#' For each diagonal position \code{i} of a \code{length} x \code{length}
#' matrix, returns the indices of the diagonal cell and of its two neighbours
#' in the same row: the cell to the right (just above the diagonal, column
#' \code{i + 1}) and the cell to the left (just below the diagonal, column
#' \code{i - 1}).
#'
#' @param length Integer (at least 1). Number of rows and columns of the
#'   square matrix.
#'
#' @return A data frame (not a matrix) with \code{length} rows and four numeric
#'   columns:
#'   \describe{
#'     \item{x1}{Row index \code{i}.}
#'     \item{x2}{Column index of the diagonal cell (same as \code{x1}).}
#'     \item{x3}{Column index of the cell to the right, \code{i + 1}; in the
#'       last row this is \code{length + 1}, outside the matrix.}
#'     \item{x4}{Column index of the cell to the left, \code{i - 1}; in the
#'       first row this is \code{0}, outside the matrix.}
#'   }
#'
#' @seealso \code{\link{matrix_triangle}}
#' @keywords functions matrix
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

