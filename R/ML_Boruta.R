#' feature selection using Boruta
#'
#' @param object A dataframe-like data object containing log-metabolite intensity values, with columns corresponding to metabolites and must containing the group column, and the rows corresponding to the samples
#'
#' @return test
#' @export
#'
#' @examples
#' library(dplyr)
#' meta_dat1 <- t(meta_dat) %>%
#'   as.data.frame() %>%
#'   dplyr::mutate(group=group)
#' result_ML_Boruta <- ML_Boruta(meta_dat1)

ML_Boruta <- function(object) {

  decision <- NULL
  object$group <- as.factor(object$group)
  model_boruta <- Boruta::Boruta(group ~ ., data = object, doTrace = 2, maxRuns = 500)
  #print(boruta)
  #plot(boruta, las = 2, cex.axis = 0.7)
  #plotImpHistory(boruta)
  #bor <- TentativeRoughFix(boruta)
  #print(bor)
  #attStats(boruta)
  
  filter_result <- Boruta::attStats(model_boruta) %>%
    tibble::rownames_to_column(var="name") %>%
    dplyr::filter(decision=="Confirmed")
  return(filter_result)
}

