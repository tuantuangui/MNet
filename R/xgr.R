#' Plot the figure using XGR
#'
#' @param metabolites_keggid the metabolites's keggid
#' @param database the database used
#' @param p_cutoff p_cutoff used to declare the significant terms. By default, it is set to 0.05
#'
#' @return test
#' @export
#'
#' @examples
#' library(dplyr)
#' kegg_pathway_filter <- kegg_pathway %>%
#' dplyr::filter(!is.na(pathway_type)) %>%
#'   dplyr::select(ENTRY,PATHWAY)
#'
#' kegg_id_need <- c("C05984","C02494")
#' xgr_result <- xgr(kegg_id_need,kegg_pathway_filter)
#' xgr_result$output
#' xgr_result$gp
xgr <- function(metabolites_keggid,database,p_cutoff=0.05) {

  nOverlap <- NULL
  eTerm <- XGR::xEnricherYours(metabolites_keggid,database, min.overlap=0, test='fisher')

  # output
  output <- eTerm %>%
    XGR::xEnrichViewer(details=TRUE,top_num=100) %>%
    dplyr::filter(nOverlap>0) %>%
    dplyr::filter(pvalue < p_cutoff) %>%
    tibble::as_tibble()

  # plot
  gp <- XGR::xEnrichLadder(eTerm,top_num=nrow(output))

  result <- list(gp=gp,output=output)
  class(result) <- "eLadder"
  return(result)
}
