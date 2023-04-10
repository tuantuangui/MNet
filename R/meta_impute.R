
#' impute the NA in data
#'
#'
#' @param mydata the data frame that your input
#' @param method the method you choose,default is min_0.1. You can choose "mean","median","min","knn"
#'
#'
#' @return a data frame
#' @export
#'
#' @examples
#'
meta_impute <- function(mydata,method,k=k) {
  if (missing (method)) {
    method="min_0.1"
  }
  if (method=="mean") {
    result <- apply(mydata,2,function(x){Hmisc::impute(x,mean)})
  }else if (method=="median") {
    result <- apply(mydata,2,function(x){Hmisc::impute(x,median)})
  }else if (method=="knn") {
    result <- DMwR2::knnImputation(mydata,k=k,meth="median")
  }else if (method=="min") {
    result <- apply(mydata,2,function(x){Hmisc::impute(x,min)})
  }else if (method=="min_0.1") {
    result <- apply(mydata,2,function(x){x[which(is.na(x))] <- 0.1*min(x,na.rm=T);return(x)})
  }
  return(result)
}

