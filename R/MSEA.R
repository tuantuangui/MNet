#' the MSEA (Metabolite Set Enrichment Analysis) result
#'
#' @param Ranks_all the Named vector of compound-level stats. Names should be the same as in 'pathways'
#' @param gseaParam GSEA parameter value, all compound-level statis are raised to the power of 'gseaParam' before calculation of GSEA enrichment scores.
#' @param minSize Minimal size of a compound set to test. All pathways below the threshold are excluded.
#'
#' @return the MSEA result
#' @export
#'
#' @examples
#' library(ggplot2)
#' library(dplyr)
#' result <- MSEA(sim.cpd.data)
MSEA <- function(Ranks_all,minSize = 5,nPermSimple=20000,gseaParam=0.5) {
  fgseaRes_all <- fgsea::fgsea(Pathways, Ranks_all,minSize = minSize,nPermSimple=nPermSimple,gseaParam=gseaParam)
  return(fgseaRes_all)
}
