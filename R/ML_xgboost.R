#' @title Feature selection using XGBoost
#'
#' @param object A dataframe-like data object containing log-metabolite intensity values, with columns corresponding to metabolites and must containing the group column, and the rows corresponding to the samples
#' @param seed Random seed for reproducible data partitioning and model fitting
#'
#' @return test
#' 
#' @importFrom magrittr %>%
#' @importFrom dplyr select mutate across arrange pull
#' @importFrom caret createDataPartition
#' @importFrom tidyselect where
#' @importFrom xgboost xgb.DMatrix xgb.train xgboost xgb.importance xgb.plot.importance
#' @importFrom utils head
#' @export
#'
#' @examples
#' library(dplyr)
#' 
#' meta_dat1 <- t(meta_dat) %>%
#'   as.data.frame() %>%
#'   dplyr::mutate(group=group)
#' result_ML_xgboost <- ML_xgboost(meta_dat1)
#' 
#' result_ML_xgboost$p
#' result_ML_xgboost$feature_result
#'
ML_xgboost <- function(object, seed = 123) {
  object <- .mnet_prepare_ml_data(object)
  test_rmse <- iter <- Feature <- Importance <- NULL
  set.seed(seed)
  parts = caret::createDataPartition(object$group, p = .8, list = F)
  train = object[parts, ]
  test = object[-parts, ]
  
  #define predictor and response variables in training set
  #  train_x = as.data.frame(lapply(train[, -which(colnames(object)=="group")],as.numeric)) %>%
  #    as.matrix()
  train_x <- train %>%
    dplyr::select(-.data$group) %>%
    dplyr::mutate(dplyr::across(
      tidyselect::vars_select_helpers$where(is.character),
      as.numeric
    )) %>%
    as.matrix()
  
  group_levels <- unique(object$group)
  train_y <- as.numeric(train$group == group_levels[2])
  
  #define predictor and response variables in testing set
  #  test_x = as.data.frame(lapply(test[, -which(colnames(object)=="group")],as.numeric)) %>%
  #    as.matrix()
  
  test_x <- test %>%
    dplyr::select(-.data$group) %>%
    dplyr::mutate(dplyr::across(
      tidyselect::vars_select_helpers$where(is.character),
      as.numeric
    )) %>%
    as.matrix()
  
  test_y <- as.numeric(test$group == group_levels[2])
  
  #define final training and testing sets
  xgb_train = xgboost::xgb.DMatrix(data = train_x, label = train_y)
  xgb_test = xgboost::xgb.DMatrix(data = test_x, label = test_y)
  
  #define watchlist
  evals = list(train = xgb_train, test = xgb_test)

  # Fit XGBoost reproducibly and keep the validation error for model selection.
  model = xgboost::xgb.train(
    params = list(max_depth = 3, objective = "reg:squarederror",
                  eval_metric = "rmse", seed = seed, nthread = 1),
    data = xgb_train,
    evals = evals,
    nrounds = 70,
    verbose = 0,
    callbacks = list(xgboost::xgb.cb.evaluation.log())
  )
  
  evaluation_log <- attr(model, "evaluation_log")
  if (is.null(evaluation_log) || !"test_rmse" %in% names(evaluation_log)) {
    stop("XGBoost did not return validation RMSE values.")
  }
  nrounds <- evaluation_log$iter[which.min(evaluation_log$test_rmse)]
  
  xgboost_model = xgboost::xgb.train(
    params = list(max_depth = 3, objective = "reg:squarederror",
                  seed = seed, nthread = 1),
    data = xgb_train,
    nrounds = nrounds,
    verbose = 0
  )
  
  importance_matrix <- xgboost::xgb.importance(
    feature_names = colnames(train_x),
    model = xgboost_model
  )
  
  importance_matrix$Feature <- factor(importance_matrix$Feature,
                                      levels = rev(importance_matrix$Feature))
  p_all <- ggplot2::ggplot(importance_matrix, ggplot2::aes(Feature, Importance)) +
    ggplot2::geom_bar(stat = "identity") +
    ggplot2::theme_classic() +
    ggplot2::scale_y_continuous(expand = c(0, 0)) +
    ggplot2::coord_flip()
  
  result <- list(feature_result = importance_matrix, p_all = p_all)
  return(result)
}
