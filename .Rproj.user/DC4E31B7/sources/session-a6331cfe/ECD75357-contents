\name{mziln}
\alias{mziln}
\title{
Multivariate zero inflated logistic normal regression
}

\description{
Multivariate zero inflated logistic normal regression.
}

\usage{
mziln(y, x, xnew = NULL)
}

\arguments{
\item{y}{
A matrix with the compositional data (dependent variable) with zero values present.
}
\item{x}{
The predictor variable(s), they can be either continnuous or categorical or both.
}
\item{xnew}{
If you have new data use it, otherwise leave it NULL.
}
}

\details{
The conditional logistic normal regression is being fitted. The likelihood conists of two components.
The contributions of the non zero compositional values and the contributions of the compositional
vectors with at least one zero value. The second component may have many different sub-categories,
one for each pattern of zeros.
}

\value{
A list including:
\item{be}{
The beta coefficients.
}
\item{est}{
The fitted or the predicted values (if xnew is not NULL).
}
}

\references{
Li Z., Lee K., Karagas M. R., Madan J. C., Hoen A. G., O'Malley A. J. and Li H. (2018).
Conditional regression based on a multivariate zero-inflated logistic-normal model for
microbiome relative abundance data.
Statistics in Biosciences, 10(3): 587--608.
}

\author{
Michail Tsagris.

R implementation and documentation: Michail Tsagris \email{mtsagris@uoc.gr}.
}

%\note{
%%  ~~further notes~~
%}

\seealso{
\code{\link{boot.mziln}
}
}

\examples{
x <- as.vector(iris[, 4])
y <- as.matrix(iris[, 1:3])
y <- y / rowSums(y)
ind <- sample(150, 10)
for ( k in ind )  y[k, sample(3, 1)] <- 0
y <- y / rowSums(y)
mod <- mziln(y, x)
}

