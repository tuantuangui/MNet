#' @title Change the pathway name to pathway id
#'
#' @param pathwayname the pathway name,such as "Glycolysis / Gluconeogenesis"
#'
#' @return test
#' 
#' @importFrom magrittr %>%
#' @importFrom dplyr select filter rename
#' @export
#'
#' @examples
#' pathwayid <- pathway2pathwayid("Glycolysis / Gluconeogenesis")
#' pathwayid
#'
pathway2pathwayid <- function(pathwayname) {
  #pathway2pathwayid("Glycolysis / Gluconeogenesis")
  
  PATHWAY <- V2 <- NULL
  result <- kegg_pathway %>%
    dplyr::select(PATHWAY, V2) %>%
    unique() %>%
    dplyr::filter(PATHWAY %in% pathwayname) %>%
    dplyr::rename(pathwayid = V2)
  return(result)
  
}
