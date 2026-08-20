\name{boot.mziln}
\alias{boot.mziln}
\title{
Bootstrap for the MZILN regression model
}

\description{
Bootstrap for the MZILN regression model.
}

\usage{
boot.mziln(y, x, R = 1000)
}

\arguments{
\item{y}{
A matrix with the compositional data (dependent variable). The number of observations
(vectors) with no zero values should be more than the columns of the predictor variables.
Otherwise, the initial values will not be calculated.
}
\item{x}{
The predictor variable(s), they can be either continnuous or categorical or both.
}
\item{R}{
The number of bootstrap resamples to perform.
}
}

\details{
The multivariate zero inflated logistic normal regression is being fitted. The likelihood conists of two components.
The contributions of the non zero compositional values and the contributions of the compositional
vectors with at least one zero value. The second component may have many different sub-categories,
one for each pattern of zeros.
}

\value{
A list including:
\item{be}{
The bootstrapped beta coefficients.
}
\item{sigma}{
The bootstrap estimate of the covariance matrix of the regression parameters.
}
}

\references{
Li Z., Lee K., Karagas M. R., Madan J. C., Hoen A. G., O'malley A. J. and Li H. (2018).
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
\code{\link{mziln}
}
}

\examples{
x <- as.vector(iris[, 4])
y <- as.matrix(iris[, 1:3])
y <- y / rowSums(y)
ind <- sample(150, 10)
for ( k in ind )  y[k, sample(3, 1)] <- 0
y <- y / rowSums(y)
mod <- boot.mziln(y, x, R = 500)
}

