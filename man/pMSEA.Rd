% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pMSEA.R
\name{pMSEA}
\alias{pMSEA}
\title{the plot of MSEA of one pathway}
\usage{
pMSEA(
  pathway_name,
  Ranks_all,
  gseaParam = 0.5,
  minSize = 5,
  ticksSize = 0.2,
  out = "Extended"
)
}
\arguments{
\item{pathway_name}{the pathway name for plot}

\item{Ranks_all}{the Named vector of compound-level stats. Names should be the same as in 'pathways'}

\item{gseaParam}{GSEA parameter value, all compound-level statis are raised to the power of 'gseaParam' before calculation of GSEA enrichment scores.}

\item{minSize}{Minimal size of a compound set to test. All pathways below the threshold are excluded.}

\item{ticksSize}{width of vertical line corresponding to a compound (default: 0.2)}

\item{out}{The pathway type for gene or metabolite,or extended pathway included genes and metabolites,default is "Extended",alternative is "metabolite" and "gene"}
}
\value{
a plot for the pathway's MSEA
}
\description{
the plot of MSEA of one pathway
}
\examples{
library(ggplot2)
library(dplyr)
result <- pMSEA("Butanoate metabolism",sim.cpd.data,out="metabolite")
}
