
#' Scale the data
#'
#' @param mydata the data that row is the metabolites, and the column is the sample
#' @param method default is "log_zscore","raw_zscore" is alternative
#'
#' @return test
#' @export
#'
#' @examples
#' mydata_scale <- myscale(mydata)
myscale <- function(mydata,method="log_zscore") {

  if (method=="log_zscore") {
    mydata <- log2(t(mydata))
    centered.x <- scale(mydata,center=TRUE, scale = TRUE)
    mydata_norm <- as.data.frame(t(centered.x))
    return(mydata_norm)
  }else if (method=="raw_zscore") {
    mydata <- t(mydata)
    centered.x <- scale(mydata,center=TRUE, scale = TRUE)
    mydata_norm <- as.data.frame(t(centered.x))
    return(mydata_norm)
  }
}

