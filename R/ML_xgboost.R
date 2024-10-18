#' feature selection using XGBoost
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
#' result_ML_xgboost <- ML_xgboost(meta_dat1)
#' result_ML_xgboost$p
#' result_ML_xgboost$feature_result

ML_xgboost <- function(object) {
  test_rmse <- iter <- Feature <- Importance <- NULL
  parts = caret::createDataPartition(object$group, p = .8, list = F)
  train = object[parts, ]
  test = object[-parts, ]

  #define predictor and response variables in training set
#  train_x = as.data.frame(lapply(train[, -which(colnames(object)=="group")],as.numeric)) %>%
#    as.matrix()
  train_x <- train %>%
    dplyr::select(-group) %>%
    dplyr::mutate(dplyr::across(tidyselect::vars_select_helpers$where(is.character), as.numeric)) %>%
    as.matrix()

  train_y = train[,which(names(object)=="group")]

  train_y[which(train_y==unique(object$group)[1])] <- 0
  train_y[which(train_y==unique(object$group)[2])] <- 1
  train_y <- as.numeric(train_y)

  #define predictor and response variables in testing set
#  test_x = as.data.frame(lapply(test[, -which(colnames(object)=="group")],as.numeric)) %>%
#    as.matrix()
  
  test_x <- test %>%
    dplyr::select(-group) %>%
    dplyr::mutate(dplyr::across(tidyselect::vars_select_helpers$where(is.character), as.numeric)) %>%
    as.matrix()

  test_y = test[, which(names(object)=="group")]
  test_y[which(test_y==unique(object$group)[1])] <- 0
  test_y[which(test_y==unique(object$group)[2])] <- 1
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
