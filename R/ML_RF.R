#' feature selection in random forest
#'
#' @param mydata the data
#' @param ylim_min the min ylim,default is 0
#' @param seed the seed
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
#' result <- ML_RF(mydata_t)
ML_RF <- function(mydata,ylim_min=0,seed=NULL) {

  group <- MeanDecreaseAccuracy <- test_set<- AUC <- type<- NULL
  set.seed(seed)

  mydata_raw <- mydata
  mydata <- data.frame(mydata)

  data1 <- data.frame(raw=names(mydata_raw),frame=names(mydata))
  mydata$group <- as.factor(mydata$group)
  rf_model <- randomForest::randomForest(group~.,data=mydata,ntree=500,importance=TRUE,proximity=TRUE)

  rf_model_accuracy <- randomForest::importance(rf_model) %>%
    as.data.frame() %>%
    dplyr::arrange(dplyr::desc(MeanDecreaseAccuracy))
  rf_model_accuracy$names <- rownames(rf_model_accuracy)

  rf_model_accuracy <- rf_model_accuracy %>%
    dplyr::filter(MeanDecreaseAccuracy>0) %>%
    dplyr::left_join(data1,by=c("names"="frame"))

  rf_model_accuracy$raw <- factor(rf_model_accuracy$raw,levels = rev(rf_model_accuracy$raw))

  
  p1 <- ggplot2::ggplot(rf_model_accuracy,ggplot2::aes(raw,MeanDecreaseAccuracy))+
    ggplot2::geom_point(shape=19,color="blue")+
    ggplot2::theme_bw()+
    ggplot2::coord_flip()+
    ggplot2::theme(panel.grid.major.x = ggplot2::element_blank(),panel.grid.minor.x = ggplot2::element_blank())+
    ggplot2::labs(x=NULL)
#  plot(rf_model)
#  varImpPlot(rf_model)

  result <- list(feature_result=tibble::as_tibble(rf_model_accuracy),p=p1)
  return(result)
}

