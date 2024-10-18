#' the gene and the metabolite in the pathway
#'
#' @param pathwayid the pathway id, hsa or name
#'
#' @return the genes and metabolites KEGG ID corresponding to pathway
#' @export
#'
#' @examples
#' result <- pathwayinfo("hsa00630")
#' result <- pathwayinfo("Glyoxylate and dicarboxylate metabolism")
pathwayinfo <- function(pathwayid) {

  GENE <- V2 <- tt <- A <- enzyme <- pathid <- pathname <- NULL

  dat <- PathwayExtendData %>%
	dplyr::filter(kegg_pathwayname == pathwayid | kegg_pathwayid ==pathwayid)

  gene_info <- dat %>%
	dplyr::filter(type=="gene")
  compound_info <- dat %>%
	dplyr::filter(type=="metabolite")

  result <- list(gene_info=gene_info,compound_info=compound_info)
  return(result)
}
