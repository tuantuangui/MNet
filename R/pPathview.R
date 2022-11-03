
#' the pathview of differential metabolites
#'
#' @param cpd.data character vector,the metabolites' value, log2(fold change)
#' @param gene.data default is NULL, the gene expression data, log2(fold change)
#'
#' @return test
#' @export
#'
#' @examples
#' dir.create("test")
#' setwd("test")
#' kegg_id <- c("C02494","C03665","C01546","C05984","C14088","C00587")
#' value <- c(-0.3824620,0.1823628,-1.1681486,0.5164899,1.6449798,-0.7340652)
#' names(value) <- kegg_id
#' cpd.data <- value
#' pPathview(cpd.data)

pPathview <- function(cpd.data,gene.data=NULL) {

  utils::data("bods", package = "pathview")

#  value <- value
#  names(value) <- kegg_id
  kegg_id <- names(cpd.data)
  pathway_id <- unique(keggid2pathway(kegg_id)$V2)

  for (pathway_id_1 in pathway_id) {
    pathview::pathview(gene.data=gene.data,
                     cpd.data=cpd.data,
                     pathway.id=pathway_id_1)
  }
}


