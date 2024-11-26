#' @title The eSEAlyser
#' @description the Extended-data Set Enrichment Analysis which includes gene and metabolite
#'
#' @param Ranks_all the Named vector of compound-level stats or gene-level stats. Names should be KEGG ID and (or) gene symbol.
#' @param gseaParam GSEA parameter value, all compound-level and(or) gene-level stats are raised to the power of 'gseaParam' before calculation of GSEA enrichment scores.
#' @param minSize Minimal size of a compound and(or) gene set to test. All pathways below the threshold are excluded.
#' @param out The pathway type for gene or metabolite,or extended pathway included genes and metabolites,default is "Extended",alternative is "metabolite" and "gene"
#' @param nPermSimple nPermSimple is the number of permutations used to estimate the significance of the enrichment score. The default value is 20000.
#' 
#' @return the eSEAlyser result
#'
#' @importFrom fgsea fgsea
#' @export
#'
#' @examples
#' result <- eSEAlyser(sim.cpd.data, out="metabolite")
#' result
#'
eSEAlyser <- function(Ranks_all,
                 minSize = 5,
                 nPermSimple = 20000,
                 gseaParam = 0.5,
                 out = "Extended") {
  utils::data("Pathways_all")
  utils::data("Pathways_gene")
  utils::data("Pathways_metabolite")
  
  Ranks_all <- sort(Ranks_all, decreasing = TRUE)
  
  if (out == "Extended") {
    fgseaRes_all <- fgsea::fgsea(
      Pathways_all,
      Ranks_all,
      minSize = minSize,
      nPermSimple = nPermSimple,
      gseaParam = gseaParam
    )
  } else if (out == "gene") {
    fgseaRes_all <- fgsea::fgsea(
      Pathways_gene,
      Ranks_all,
      minSize = minSize,
      nPermSimple = nPermSimple,
      gseaParam = gseaParam
    )
  } else if (out == "metabolite") {
    fgseaRes_all <- fgsea::fgsea(
      Pathways_metabolite,
      Ranks_all,
      minSize = minSize,
      nPermSimple = nPermSimple,
      gseaParam = gseaParam
    )
  }
  fgseaRes_all$leadingEdge <- sapply(fgseaRes_all$leadingEdge, function(x) paste(x, collapse = ", "))
  return(fgseaRes_all)
}
