#' the pathway analysis of combination of gene and metabolites
#'
#' @param name the gene and the metabolites' name
#' @param out the figure's name type, default is "name"
#'
#' @return test
#' @export
#'
#' @examples
#' name <- c("C15973","C16254","MDH1")
#' result <- PathGeneMeta(name)
PathGeneMeta <- function(name,out="name") {
  if (out=="name") {
    result <- xgr(name,gene_metabolite_pathway_backgroud[,c(1,3)])
  }else {
    result <- xgr(name,gene_metabolite_pathway_backgroud)
  }
  return(result)
}


