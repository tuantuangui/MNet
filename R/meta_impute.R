
#' impute the NA in data
#'
#'
#' @param object object A dataframe-like data object containing raw metabolite intensity values, with rows corresponding to metabolites, and the columns corresponding to the samples
#' @param method the method used for imputed data, default is min_0.1. You can choose "mean","median","min","knn"
#'
#'
#' @return a data frame
#' @export
#'
#' @examples
#'
meta_impute <- function(object,method,k=k) {
  if (missing (method)) {
    method="min_0.1"
  }
  if (method=="mean") {
    result <- apply(object,2,function(x){Hmisc::impute(x,mean)})
  }else if (method=="median") {
    result <- apply(object,2,function(x){Hmisc::impute(x,median)})
  }else if (method=="knn") {
    result <- DMwR2::knnImputation(object,k=k,meth="median")
  }else if (method=="min") {
    result <- apply(object,2,function(x){Hmisc::impute(x,min)})
  }else if (method=="min_0.1") {
    result <- apply(object,2,function(x){x[which(is.na(x))] <- 0.1*min(x,na.rm=T);return(x)})
  }
  return(result)
}

