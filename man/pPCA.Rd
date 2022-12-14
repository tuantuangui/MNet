% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pPCA.R
\name{pPCA}
\alias{pPCA}
\title{Plot the PCA figure}
\usage{
pPCA(mydata, group)
}
\arguments{
\item{mydata}{the data needed to pca, the raw is the metabolites, and the column is the sample}

\item{group}{the group}
}
\value{
test
}
\description{
Plot the PCA figure
}
\examples{
result <- pPCA(mydata,group)
result$p1
result$p2
result$p3
}
