#' feature selection in XGBoost
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
#' result <- ML_xgboost(mydata_t)


ML_xgboost <- function(mydata) {
  test_rmse <- iter <- Feature <- Importance <- NULL
  parts = caret::createDataPartition(mydata$group, p = .8, list = F)
  train = mydata[parts, ]
  test = mydata[-parts, ]

  #define predictor and response variables in training set
#  train_x = as.data.frame(lapply(train[, -which(colnames(mydata)=="group")],as.numeric)) %>%
#    as.matrix()
  train_x <- train %>%
    dplyr::select(-"group") %>%
    dplyr::mutate(dplyr::across(tidyselect::vars_select_helpers$where(is.character), as.numeric)) %>%
    as.matrix()

  train_y = train[,which(names(mydata)=="group")]

  train_y[which(train_y==unique(mydata$group)[1])] <- 0
  train_y[which(train_y==unique(mydata$group)[2])] <- 1
  train_y <- as.numeric(train_y)

  #define predictor and response variables in testing set
#  test_x = as.data.frame(lapply(test[, -which(colnames(mydata)=="group")],as.numeric)) %>%
#    as.matrix()
  
  test_x <- test %>%
    dplyr::select(-"group") %>%
    dplyr::mutate(dplyr::across(tidyselect::vars_select_helpers$where(is.character), as.numeric)) %>%
    as.matrix()

  test_y = test[, which(names(mydata)=="group")]
  test_y[which(test_y==unique(mydata$group)[1])] <- 0
  test_y[which(test_y==unique(mydata$group)[2])] <- 1
  test_y <- as.numeric(test_y)

  #define final training and testing sets
  xgb_train = xgboost::xgb.DMatrix(data = train_x, label = train_y)
  xgb_test = xgboost::xgb.DMatrix(data = test_x, label = test_y)

  #define watchlist
  watchlist = list(train=xgb_train, test=xgb_test)

  #fit XGBoost model and display training and testing data at each round
  model = xgboost::xgb.train(data = xgb_train, max.depth = 3, watchlist=watchlist, nrounds = 70)

  nrounds <- model$evaluation_log %>%
    dplyr::arrange(test_rmse) %>%
    utils::head(n=1) %>%
    dplyr::pull(iter)

  xgboost_model = xgboost::xgboost(data = xgb_train, max.depth = 3, nrounds = nrounds, verbose = 0)

  importance_matrix = xgboost::xgb.importance(colnames(xgb_train), model = xgboost_model)
  importance_matrix = xgboost::xgb.plot.importance(importance_matrix)

  importance_matrix$Feature <- factor(importance_matrix$Feature,levels=rev(importance_matrix$Feature))
  p_all <- ggplot2::ggplot(importance_matrix,ggplot2::aes(Feature,Importance))+
    ggplot2::geom_bar(stat="identity")+
    ggplot2::theme_classic()+
    ggplot2::scale_y_continuous(expand = c(0, 0))+
    ggplot2::coord_flip()

  result <- list(feature_result=importance_matrix,p_all=p_all)
  return(result)
}
