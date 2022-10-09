

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

