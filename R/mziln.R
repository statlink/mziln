mziln <- function(y, x, xnew = NULL) {

  x <- model.matrix( y~., data = as.data.frame(x) )
  n <- dim(y)[1]  ;  D <- dim(y)[2]  ;  d <- D - 1
  p <- dim(x)[2]  ;  M <- d * (p + 1)
  dd <- diag(d)

  sel1 <- Rfast::rowsums(y > 0) == D
  y1 <- y[sel1, ]
  ly <- log(y1[, -D] / y1[, D])
  x1 <- x[sel1, , drop = FALSE]
  y0 <- y[!sel1, ,drop = FALSE]
  x0 <- x[!sel1, , drop = FALSE]
  n1 <- dim(y1)[1]  ;  n0 <- dim(y0)[1]

  subj_list1 <- Filter( Negate(is.null), lapply( seq_len(n1), function(i) .build_1(ly[i, ], x1[i, ], dd) ) )
  subj_list0 <- Filter( Negate(is.null), lapply( seq_len(n0), function(i) .build_0(y0[i, ], x0[i, ], d, dd) ) )

  xtilde1 <- utilde1 <- list()
  for ( s in subj_list1 ) {
    xtilde1[[ length(xtilde1) + 1 ]] <- s$D
    utilde1[[ length(utilde1) + 1 ]] <- s$u
  }
  xtilde0 <- utilde0 <- list()
  for ( s in subj_list0 ) {
    Omega_i <- solve( s$A %*% t(s$A) )
    Omega_half <- chol(Omega_i)
    xtilde0[[ length(xtilde0) + 1 ]] <- Omega_half %*% s$D
    utilde0[[ length(utilde0) + 1 ]] <- Omega_half %*% s$u
  }

  xtilde <- do.call(c, list(xtilde1, xtilde0))
  utilde <- do.call(c, list(utilde1, utilde0))

  xtilde <- do.call(rbind, xtilde)
  utilde <- do.call(c, utilde)

  be <- matrix( solve( crossprod(xtilde), crossprod(xtilde, utilde) ), ncol = d )

  est <- NULL
  if ( !is.null(xnew) ) {
    xnew <- model.matrix(~., as.data.frame(xnew) )
    ma <- cbind( exp( xnew %*% be ), 1 )
    est <- ma / Rfast::rowsums(ma)  ## fitted values
    colnames(est) <- colnames(y)
  }
  colnames(be) <- colnames(y)[-D]
  rownames(be) <- colnames(x)

  list(be = be, est = est)
}



.build_1 <- function(ly_i, x_i, dd) {
  xi_full <- kronecker(dd, matrix(x_i, nrow = 1) )
  D_i <- dd %*% xi_full
  list(A = dd, D = D_i, u = ly_i)
}


.build_0 <- function(y_i, x_i, d, dd) {
  S <- which(y_i > 0)
  L <- length(S)
  if ( L <= 1 )  return(NULL)
  r <- max(S)
  active <- setdiff(S, r)
  A_i <- matrix(0, nrow = L - 1, ncol = d)

  for ( l in seq_along(active) ) {
    kl <- active[l]
    if ( kl <= d )  A_i[l, kl] <- 1
    if ( r <= d )  A_i[l, r]  <- A_i[l, r] - 1
  }

  u_i <- log(y_i[active] / y_i[r])
  xi_full <- kronecker(dd, matrix(x_i, nrow = 1) )
  D_i <- A_i %*% xi_full

  list(A = A_i, D = D_i, u = u_i)
}
