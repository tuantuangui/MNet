% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/impute.R
\name{meta_impute}
\alias{meta_impute}
\title{impute the NA in data}
\usage{
meta_impute(mydata, method, k = k)
}
\arguments{
\item{mydata}{the data frame that your input}

\item{method}{the method you choose,default is min_0.1. You can choose "mean","median","min","knn"}
}
\value{
a data frame
}
\description{
impute the NA in data
}
