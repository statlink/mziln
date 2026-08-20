boot.mziln <- function(y, x, R = 1000) {

  D <- dim(y)[2]  ;  d <- D - 1  ;  n <- dim(y)[1]
  sel1 <- Rfast::rowsums(y > 0) == D
  x <- model.matrix( y~., data = as.data.frame(x) )
  y1 <- y[sel1, ]  ;  n1 <- dim(y1)[1]
  x1 <- x[sel1, -1, drop = FALSE]
  y2 <- y[!sel1, , drop = FALSE]
  x2 <- x[!sel1, -1, drop = FALSE]
  n2 <- dim(y2)[1]
  p <- dim(x)[2]

  bbe <- matrix(nrow = R, ncol = p * d)
  for ( i in 1:R ) {
    id1 <- rangen::Sample.int(n1, n1, replace = TRUE)
    yb1 <- y1[id1, ]
    xb1 <- x1[id1, , drop = FALSE]
    id2 <- rangen::Sample.int(n2, n2, replace = TRUE)
    yb2 <- y2[id2, ]
    xb2 <- x2[id2, , drop = FALSE]
    yb <- rbind(yb1, yb2)
    xb <- rbind(xb1, xb2)
    bbe[i, ] <- as.vector( mziln::mziln(yb, xb)$be )
  }
  sigma <- cov(bbe)
  namx <- colnames(x)
  namy <- colnames(y)
  if ( is.null( namy ) )  {
    namy <- paste("Y", 2:(d + 1), sep = "")
  } else namy <- namy[-1]
  nam <- NULL
  for ( i in 1:p )  nam <- c(nam, paste(namy, ":", namx[i], sep = "") )
  colnames(sigma) <- rownames(sigma) <- colnames(bbe) <- nam
  list(be = bbe, sigma = sigma)

}
