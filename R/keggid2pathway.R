#' search the kegg pathway corresponding to kegg id
#'
#' @param keggid the kegg id that be searched pathway
#'
#' @return test
#' @export
#'
#' @examples
#' keggid <- c("C05984","C02494")
#' kegg_result <- keggid2pathway(keggid)
keggid2pathway <- function(keggid) {
  library(dplyr)
  ENTRY <- NULL
  result <- kegg_pathway %>%
    dplyr::filter(ENTRY %in% keggid)
  return(result)
}
