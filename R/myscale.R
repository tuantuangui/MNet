#' @title Scale the data
#'
#' @param object A dataframe-like data object containing raw metabolite intensity values, with rows corresponding to metabolites, and the columns corresponding to the samples
#' @param method default is "log_zscore","raw_zscore" is alternative
#'
#' @return test
#'
#' @export
#'
#' @examples
#' object_scale <- myscale(meta_dat, method="raw_zscore")
#' object_scale
#'
myscale <- function(object, method = "log_zscore") {
  if (method == "log_zscore") {
    object <- log10(t(object))
    centered.x <- scale(object, center = TRUE, scale = TRUE)
    object_norm <- as.data.frame(t(centered.x))
    return(object_norm)
  } else if (method == "raw_zscore") {
    object <- t(object)
    centered.x <- scale(object, center = TRUE, scale = TRUE)
    object_norm <- as.data.frame(t(centered.x))
    return(object_norm)
  }
}
