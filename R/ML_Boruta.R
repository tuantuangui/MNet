#' feature selection in Boruta
#'
#' @param mydata the data
#'
#' @return test
#' @export
#'
#' @examples
#' library(dplyr)
#' mydata_t <- mydata %>%
#'   t() %>%
#'   as.data.frame()
#' # the group information must be tumor and normal
#' mydata_t$group <- group
#' result <- ML_Boruta(mydata_t)


ML_Boruta <- function(mydata) {

  decision <- NULL
  mydata$group <- as.factor(mydata$group)
  model_boruta <- Boruta::Boruta(group ~ ., data = mydata, doTrace = 2, maxRuns = 500)
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

