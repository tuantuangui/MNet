#' the kegg pathway corresponding to kegg id
#'
#' @param keggid the KEGG ID
#'
#' @return result
#' @export
#'
#' @examples
#' keggid <- c("C05984","C02494")
#' kegg_result <- keggid2pathway(keggid)
keggid2pathway <- function(keggid) {
  ENTRY <- NULL
  result <- kegg_pathway %>%
    dplyr::filter(ENTRY %in% keggid) %>%
    tibble::as_tibble()
  return(result)
}
