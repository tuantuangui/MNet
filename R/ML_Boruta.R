.mnet_prepare_ml_data <- function(object, min_class_size = 2L) {
  if (!is.data.frame(object)) {
    object <- tryCatch(as.data.frame(object), error = function(e) NULL)
  }
  if (is.null(object) || !"group" %in% names(object) || ncol(object) < 2L) {
    stop("Input must be a data frame with numeric predictors and a 'group' column.", call. = FALSE)
  }

  group <- as.character(object$group)
  if (anyNA(group) || any(!nzchar(group)) || length(unique(group)) != 2L) {
    stop("The 'group' column must contain exactly two non-missing classes.", call. = FALSE)
  }
  class_counts <- table(group)
  if (any(class_counts < min_class_size)) {
    stop(sprintf("Each group must contain at least %d samples.", min_class_size), call. = FALSE)
  }

  predictors <- setdiff(names(object), "group")
  if (!length(predictors) || anyDuplicated(predictors)) {
    stop("Input must contain at least one uniquely named predictor.", call. = FALSE)
  }
  for (column in predictors) {
    values <- object[[column]]
    if (is.factor(values) || is.character(values)) {
      values <- suppressWarnings(as.numeric(as.character(values)))
    }
    if (!is.numeric(values) || anyNA(values) || any(!is.finite(values))) {
      stop(sprintf("Predictor '%s' must contain only finite numeric values.", column), call. = FALSE)
    }
    object[[column]] <- values
  }
  object$group <- factor(group)
  object
}

#' @title Feature selection using Boruta
#'
#' @param object A dataframe-like data object containing log-metabolite intensity values, with columns corresponding to metabolites and must containing the group column, and the rows corresponding to the samples
#' @param seed Random seed for reproducible feature selection
#'
#' @return test
#' 
#' @importFrom magrittr %>%
#' @importFrom dplyr filter
#' @importFrom Boruta Boruta attStats
#' @importFrom tibble rownames_to_column
#' @export
#'
#' @examples
#' library(dplyr)
#' 
#' meta_dat1 <- t(meta_dat) %>%
#'   as.data.frame() %>%
#'   dplyr::mutate(group=group)
#'
#' result_ML_Boruta <- ML_Boruta(meta_dat1)
#' result_ML_Boruta
#'
ML_Boruta <- function(object, seed = 123) {
  decision <- NULL
  object <- .mnet_prepare_ml_data(object)
  set.seed(seed)
  object$group <- as.factor(object$group)
  model_boruta <- Boruta::Boruta(group ~ .,
                                 data = object,
                                 doTrace = 2,
                                 maxRuns = 500)
  #print(boruta)
  #plot(boruta, las = 2, cex.axis = 0.7)
  #plotImpHistory(boruta)
  #bor <- TentativeRoughFix(boruta)
  #print(bor)
  #attStats(boruta)
  
  filter_result <- Boruta::attStats(model_boruta) %>%
    tibble::rownames_to_column(var = "name") %>%
    dplyr::filter(decision == "Confirmed")
  return(filter_result)
}
