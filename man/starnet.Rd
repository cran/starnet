% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/functions.R
\name{starnet}
\alias{starnet}
\title{Stacked Elastic Net Regression}
\usage{
starnet(
  y,
  X,
  family = "gaussian",
  nalpha = 21,
  alpha = NULL,
  nfolds = 10,
  foldid = NULL,
  type.measure = "deviance",
  alpha.meta = 1,
  penalty.factor = NULL,
  intercept = NULL,
  upper.limit = NULL,
  unit.sum = NULL,
  ...
)
}
\arguments{
\item{y}{response\strong{:}
numeric vector of length \eqn{n}}

\item{X}{covariates\strong{:}
numeric matrix with \eqn{n} rows (samples)
and \eqn{p} columns (variables)}

\item{family}{character "gaussian", "binomial" or "poisson"}

\item{nalpha}{number of \code{alpha} values}

\item{alpha}{elastic net mixing parameters\strong{:}
vector of length \code{nalpha} with entries
between \eqn{0} (ridge) and \eqn{1} (lasso);
or \code{NULL} (equidistance)}

\item{nfolds}{number of folds}

\item{foldid}{fold identifiers\strong{:}
vector of length \eqn{n} with entries between \eqn{1} and \code{nfolds};
or \code{NULL} (balance)}

\item{type.measure}{loss function\strong{:}
character "deviance", "class", "mse" or "mae"
(see \code{\link[glmnet]{cv.glmnet}})}

\item{alpha.meta}{meta-learner\strong{:}
value between \eqn{0} (ridge) and \eqn{1} (lasso)
for elastic net regularisation; 
\code{NA} for convex combination}

\item{penalty.factor}{differential shrinkage\strong{:}
vector of length \eqn{n} with entries
between \eqn{0} (include) and \eqn{Inf} (exclude), 
or \code{NULL} (all \eqn{1})}

\item{intercept, upper.limit, unit.sum}{settings for meta-learner\strong{:} logical,
or \code{NULL}
(\code{intercept=!is.na(alpha.meta)},
\code{upper.limit=TRUE},
\code{unit.sum=is.na(alpha.meta)})}

\item{...}{further arguments passed to \code{\link[glmnet]{glmnet}}}
}
\value{
Object of class \code{\link[starnet]{starnet}}.
The slots \code{base} and \code{meta}
contain \code{\link[glmnet]{cv.glmnet}}-like objects,
for the base and meta learners, respectively.
}
\description{
Implements stacked elastic net regression.
}
\details{
Post hoc feature selection\strong{:} consider
argument \code{nzero} in functions
\code{\link{coef}} and \code{\link{predict}}.
}
\examples{
\dontshow{
if(!grepl('SunOS',Sys.info()['sysname'])){
set.seed(1)
n <- 50; p <- 100
y <- rnorm(n=n)
X <- matrix(rnorm(n*p),nrow=n,ncol=p)
object <- starnet(y=y,X=X,family="gaussian")}}
\donttest{
set.seed(1)
n <- 50; p <- 100
y <- rnorm(n=n)
X <- matrix(rnorm(n*p),nrow=n,ncol=p)
object <- starnet(y=y,X=X,family="gaussian")}

}
\references{
A Rauschenberger, E Glaab, and MA van de Wiel (2021).
"Predictive and interpretable models via the stacked elastic net".
\emph{Bioinformatics}. 37(14):2012-2016.
\doi{10.1093/bioinformatics/btaa535}.
\email{armin.rauschenberger@uni.lu}
}
