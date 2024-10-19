#' @title Feature selection using random forest
#'
#' @param object A dataframe-like data object containing log-metabolite intensity values, with columns corresponding to metabolites and must containing the group column, and the rows corresponding to the samples
#' @param ylim_min the min ylim,default is 0
#' @param seed the seed
#'
#' @return test
#' 
#' @importFrom magrittr %>%
#' @importFrom randomForest randomForest importance
#' @importFrom dplyr arrange desc filter left_join
#' @importFrom tibble as_tibble
#' @import ggplot2
#' @export
#'
#' @examples
#' library(dplyr)
#' 
#' meta_dat1 <- t(meta_dat) %>%
#'   as.data.frame() %>%
#'   dplyr::mutate(group=group)
#' result_ML_RF <- ML_RF(meta_dat1)
#'
#' result_ML_RF$p
#' result_ML_RF$feature_result
#'
ML_RF <- function(object,
                  ylim_min = 0,
                  seed = NULL) {
  group <- MeanDecreaseAccuracy <- test_set <- AUC <- type <- NULL
  set.seed(seed)
  
  object_raw <- object
  object <- data.frame(object)
  
  data1 <- data.frame(raw = names(object_raw), frame = names(object))
  object$group <- as.factor(object$group)
  rf_model <- randomForest::randomForest(
    group ~ .,
    data = object,
    ntree = 500,
    importance = TRUE,
    proximity = TRUE
  )
  
  rf_model_accuracy <- randomForest::importance(rf_model) %>%
    as.data.frame() %>%
    dplyr::arrange(dplyr::desc(MeanDecreaseAccuracy))
  rf_model_accuracy$names <- rownames(rf_model_accuracy)
  
  rf_model_accuracy <- rf_model_accuracy %>%
    dplyr::filter(MeanDecreaseAccuracy > 0) %>%
    dplyr::left_join(data1, by = c("names" = "frame"))
  
  rf_model_accuracy$raw <- factor(rf_model_accuracy$raw, levels = rev(rf_model_accuracy$raw))
  
  
  p1 <- ggplot2::ggplot(rf_model_accuracy, ggplot2::aes(raw, MeanDecreaseAccuracy)) +
    ggplot2::geom_point(shape = 19, color = "blue") +
    ggplot2::theme_bw() +
    ggplot2::coord_flip() +
    ggplot2::theme(
      panel.grid.major.x = ggplot2::element_blank(),
      panel.grid.minor.x = ggplot2::element_blank()
    ) +
    ggplot2::labs(x = NULL)
  #  plot(rf_model)
  #  varImpPlot(rf_model)
  
  result <- list(feature_result = tibble::as_tibble(rf_model_accuracy),
                 p = p1)
  return(result)
}
