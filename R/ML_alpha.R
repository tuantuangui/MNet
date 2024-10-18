#' feature selection using lasso or elastic network
#'
#' @param object A dataframe-like data object containing log-metabolite intensity values, with columns corresponding to metabolites and must containing the group column, and the rows corresponding to the samples
#' @param method the feature selection method,default is "lasso", "elastic" is optional
#'
#' @return test
#' @export
#'
#' @examples
#' library(dplyr)
#' meta_dat1 <- t(meta_dat) %>%
#'   as.data.frame() %>%
#'   dplyr::mutate(group=group)
#' result_ML_lasso <- ML_alpha(meta_dat1,method="lasso")

ML_alpha <- function(object,method="lasso"){

  s1 <- feature <- NULL
  object1 <- object %>%
    dplyr::select(-group) %>%
    dplyr::mutate(dplyr::across(tidyselect::vars_select_helpers$where(is.character), as.numeric))
  object1$group <- object$group
  object <- object1
  
  object$group <- as.character(object$group)
  object1 <- object[which(object$group==unique(object$group)[1]),]
  object2 <- object[which(object$group==unique(object$group)[2]),]
  train_sub1 = base::sample(nrow(object1),round(8/10*nrow(object1),0))
  train_sub2 = base::sample(nrow(object2),round(8/10*nrow(object2),0))
  
  train_data = rbind(object1[train_sub1,],object2[train_sub2,])
  test_data <- rbind(object1[-train_sub1,],object2[-train_sub2,])
  
  train_data$group<- as.factor(train_data$group)
  test_data$group <- as.factor(test_data$group)
  
  
  lambda <- 10^seq(-3, 3, length = 100)
  
  ##计算岭回归
  if (method=="ridge") {
    # Build the model
    ridge <- caret::train(
      group ~., data = object, method = "glmnet",
      trControl = caret::trainControl("cv", number = 10),
      tuneGrid = expand.grid(alpha = 0, lambda = lambda)
    )
    # Model coefficients
    coef_ridge <- as.matrix(stats::coef(ridge$finalModel, ridge$bestTune$lambda)) %>%
      as.data.frame() %>%
      dplyr::filter(s1 != 0) %>%
      tibble::rownames_to_column(var="feature") %>%
      dplyr::filter(feature != "(Intercept)")
    
    return(coef_ridge)
    
    # Make predictions
#    predictions <- ridge %>% stats::predict(test_data)
    # Model prediction performance
 #   data.frame(RMSE = RMSE(predictions, test_data$medv),
 #     Rsquare = R2(predictions, test_data$medv))
  }else if (method=="lasso") {
    ## 计算LASSO回归
    # Build the model
#    set.seed(123)
    lasso <- caret::train(
      group ~., data = object, method = "glmnet",
      trControl = caret::trainControl("cv", number = 10),
      tuneGrid = expand.grid(alpha = 1, lambda = lambda)
    )
    # Model coefficients
    coef_lasso <- stats::coef(lasso$finalModel, lasso$bestTune$lambda) %>%
                    as.matrix() %>%
                    as.data.frame() %>%
                    dplyr::filter(s1!=0) %>%
                    tibble::rownames_to_column(var="feature") %>%
                    dplyr::filter(feature != "(Intercept)")
 
    return(coef_lasso)
    # Make predictions
    predictions <- lasso %>% stats::predict(test_data)
    # Model prediction performance
#    data.frame(RMSE = RMSE(predictions, test_data$medv),
#      Rsquare = R2(predictions, test_data$medv))
  } else if (method=="elastic") {
    ## 弹性网络回归
    # Build the model
#    set.seed(123)
    elastic <- caret::train(
      group ~., data = object, method = "glmnet",
      trControl = caret::trainControl("cv", number = 10),
      tuneLength = 10
    )
    # Model coefficients
    coef_elastic <- stats::coef(elastic$finalModel, elastic$bestTune$lambda) %>%
                      as.matrix() %>%
                      as.data.frame() %>%
                      dplyr::filter(s1!=0) %>%
                      tibble::rownames_to_column(var="feature") %>%
                      dplyr::filter(feature != "(Intercept)")

    return(coef_elastic)

    # Make predictions
 #   predictions <- elastic %>% stats::predict(test_data)
    # Model prediction performance
#    data.frame(RMSE = RMSE(predictions, test.data$medv),
#      Rsquare = R2(predictions, test.data$medv))
  }
}
  
  ##比较模型性能
  #models <- list(ridge = ridge, lasso = lasso, elastic = elastic)
  #resamples(models) %>% summary( metric = "RMSE")

