#' @title The gene and the metabolite in the pathway
#'
#' @param pathwayid the pathway id, hsa or name
#'
#' @return the genes and metabolites KEGG ID corresponding to pathway
#'
#' @importFrom magrittr %>%
#' @importFrom dplyr filter
#' @export
#'
#' @examples
#' result <- pathwayinfo("hsa00630")
#' result
#'
#' result <- pathwayinfo("Glyoxylate and dicarboxylate metabolism")
#' result
#'
pathwayinfo <- function(pathwayid) {
  GENE <- V2 <- tt <- A <- enzyme <- pathid <- pathname <- NULL
  
  dat <- PathwayExtendData %>%
    dplyr::filter(.data$kegg_pathwayname == pathwayid |
                    .data$kegg_pathwayid == pathwayid)
  
  gene_info <- dat %>%
    dplyr::filter(.data$type == "gene")
  compound_info <- dat %>%
    dplyr::filter(.data$type == "metabolite")
  
  result <- list(gene_info = gene_info, compound_info = compound_info)
  return(result)
}
