
#' fold change, p value and vip of the data
#'
#' @param mydata the rows are metabolites, and the columns are the samples
#' @param group the group information of the sample
#'
#' @return a data frame of the result contains fold change,p value and vip
#' @export
#'
#' @examples
#' library(dplyr)
#' result <- DM(mydata,group)
DM <- function(mydata,group) {
  fold_change <- c(); group1_mean <- c(); group2_mean <- c()
  for (i in seq(1,nrow(mydata))){
    group1_mean[i] <- mean(as.numeric(mydata[i,which(group=="normal")])) ###mean or median
    group2_mean[i] <- mean(as.numeric(mydata[i,which(group=="tumor")]))
    fold_change[i] <- group2_mean[i]/group1_mean[i]
  }
  fold_change_result <- as.data.frame(fold_change)
  fold_change_result$name <- rownames(mydata)

  fold_change_result <- fold_change_result %>%
    dplyr::filter(fold_change!=1)

  mydata <- mydata[rownames(mydata) %in% fold_change_result$name,]

  t_test <- c(); p_value_t <- c(); wilcox_test <- c(); p_value_wilcox<-c()
  mydata_norm <- myscale(mydata)
  for (i in seq(1,nrow(mydata_norm))) {
    group1_var <- as.numeric(mydata_norm[i,which(group=="normal")])
    group2_var <- as.numeric(mydata_norm[i,which(group=="tumor")])
    if (length(unique(group1_var))==1 && length(unique(group2_var))==1 && as.character(unique(group1_var))==as.character(unique(group2_var))) {
      p_value_t[i] <- 1
      p_value_wilcox[i] <- 1
      print(i)
    }else if (length(unique(group1_var))==1 && length(unique(group2_var))==1 && unique(group1_var)!=unique(group2_var)){
      p_value_t[i] <- 0
      p_value_wilcox[i] <- 0
      print(i)
    } else {
      t_test <- stats::t.test(group1_var ,group2_var)
      wilcox_test <- stats::wilcox.test(group1_var,group2_var,exact = FALSE)
      p_value_t[i] <- t_test$p.value
      p_value_wilcox[i] <- wilcox_test$p.value
    }
  }
  fdr_t=stats::p.adjust(p_value_t, "BH")
  fdr_wilcox = stats::p.adjust(p_value_wilcox,"BH")

  p_value_result <- data.frame(t_value=p_value_t,fdr_t=fdr_t,wilcox_value=p_value_wilcox,fdr_wilcox=fdr_wilcox)
  p_value_result$name <- rownames(mydata)

  oplsda <- ropls::opls(t(mydata_norm), group, predI = 1, orthoI = 1)
  vip_result <- data.frame(vip=oplsda@vipVn)
  vip_result$name <- rownames(vip_result)

  result <- fold_change_result %>%
    dplyr::left_join(p_value_result,by="name") %>%
    dplyr::left_join(vip_result,by="name") %>%
    as_tibble()

  return(result)
}

