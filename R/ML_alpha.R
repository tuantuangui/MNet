#' @title Feature selection using lasso or elastic network
#'
#' @param object A dataframe-like data object containing log-metabolite intensity values, with columns corresponding to metabolites and must containing the group column, and the rows corresponding to the samples
#' @param method the feature selection method,default is "lasso", "elastic" is optional
#' @param seed Random seed for reproducible resampling
#'
#' @return test
#' 
#' @importFrom magrittr %>%
#' @importFrom dplyr select mutate across filter
#' @importFrom tibble rownames_to_column
#' @importFrom tidyselect where
#' @importFrom caret train trainControl
#' @importFrom stats coef predict
#' @export
#'
#' @examples
#' library(dplyr)
#' 
#' meta_dat1 <- t(meta_dat) %>%
#'   as.data.frame() %>%
#'   dplyr::mutate(group=group)
#' result_ML_lasso <- ML_alpha(meta_dat1, method="lasso")
#' result_ML_lasso
#'
ML_alpha <- function(object, method = "lasso", seed = 123) {
  method <- match.arg(method, c("lasso", "ridge", "elastic"))
  object <- .mnet_prepare_ml_data(object, min_class_size = 2L)
  set.seed(seed)

  cv_folds <- min(10L, min(table(object$group)))
  train_control <- caret::trainControl("cv", number = cv_folds)
  lambda <- 10 ^ seq(-3, 3, length = 100)
  if (method == "lasso") {
    model <- caret::train(
      group ~ ., data = object, method = "glmnet", trControl = train_control,
      tuneGrid = expand.grid(alpha = 1, lambda = lambda)
    )
  } else if (method == "ridge") {
    model <- caret::train(
      group ~ ., data = object, method = "glmnet", trControl = train_control,
      tuneGrid = expand.grid(alpha = 0, lambda = lambda)
    )
  } else {
    model <- caret::train(
      group ~ ., data = object, method = "glmnet", trControl = train_control,
      tuneLength = 10
    )
  }

  coefficients <- as.matrix(stats::coef(model$finalModel, model$bestTune$lambda))
  result <- data.frame(
    feature = rownames(coefficients),
    s1 = as.numeric(coefficients[, 1]),
    stringsAsFactors = FALSE
  )
  result <- result[result$feature != "(Intercept)" & result$s1 != 0, , drop = FALSE]
  rownames(result) <- NULL
  result
}

##比较模型性能
#models <- list(ridge = ridge, lasso = lasso, elastic = elastic)
#resamples(models) %>% summary( metric = "RMSE")
