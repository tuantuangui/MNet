#' get the reaction from the gene and the metabolite
#'
#' @param genesymbol the gene symbol
#' @param metabolite the metabolite's kegg id
#'
#' @return test
#' @export
#'
#' @examples
#' genesymbol <- "SLCO1B1"
#' metabolite <- "C00288"
#' result <- reaction_metabolite_gene(genesymbol,metabolite)
reaction_metabolite_gene <- function(genesymbol,metabolite) {
  gene <- keggId <- NULL
  gene_filter <- gene_reaction %>%
    dplyr::filter(gene==genesymbol)
  metabolite_filter <- metabolite_reaction %>%
    dplyr::filter(keggId==metabolite)

  dat <- gene_filter %>%
    dplyr::inner_join(metabolite_filter,by="reaction") %>%
    dplyr::select(c("reaction","description","formula","subsystem","gene","abbreviation","keggId","hmdb","score"))
  return(dat)
}
