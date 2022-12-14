#' the KEGG pathway analysis which includes the extended pathway analysis of gene and metabolites
#'
#' @param name The genes' or the metabolites' names which to analysis pathway
#' @param out The pathway type for gene or metabolite,or extended pathway included genes and metabolites,default is extended pathway
#'
#' @return test
#' @export
#'
#' @examples
#' name <- c("C15973","C16254","MDH1")
#' result <- PathwayAnalysis(name,out="Extended")
#' name <- "C15973"
#' result <- PathwayAnalysis(name,out="metabolite")
#' name <- "MDH1"
#' result <- PathwayAnalysis(name,out="gene")
PathwayAnalysis <- function(name,out="Extended") {
  if (out=="Extended") {
      PathwayExtendData <- PathwayExtendData %>%
        dplyr::select(name,kegg_pathwayname)
      result <- xgr(name,PathwayExtendData)
  }else if (out=="gene") {
    PathwayExtendData <- PathwayExtendData %>%
      dplyr::filter(type=="gene") %>%
      dplyr::select(name,kegg_pathwayname)
    result <- xgr(name,PathwayExtendData)
  }else if (out=="metabolite") {
    PathwayExtendData <- PathwayExtendData %>%
      dplyr::filter(type=="metabolite") %>%
      dplyr::select(name,kegg_pathwayname)
    result <- xgr(name,PathwayExtendData)
  }
  
  return(result)
}


