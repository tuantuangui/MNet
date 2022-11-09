
#' The metabolites' survival plot
#' automatic classify the samples by each selected metabolites by mean or median, and then plot the survival
#'
#' @param dat the row is the sample, and the first 2 column is status and time, the rest of column
#' is the metabolites' value
#' @param metabolites the selected metabolites that used to classify the samples
#' @param cluster_method "mean" or "median",defalult is "mean"
#' @param out_dir the output directory,default is "survival/metabolites"
#'
#' @return test
#' @export
#'
#' @examples
#' metabolites <- c("C03819","C02918","C03916")
#' survMet(dat,metabolites,cluster_method="mean",out_dir="result/survival/metabolites/")

survMet <- function(dat,metabolites,cluster_method="mean",out_dir="survival/metabolites/") {
   
  metabolite_mean_median <- NULL


  dir.create(out_dir,recursive = TRUE)
  for (metabolite in metabolites) {

    mydata_filter <- dat[,c(1,2,which(colnames(dat) == metabolite))] %>%
      as.data.frame()
    rownames(mydata_filter) <- rownames(dat)
    names(mydata_filter)[3]="metabolite"

    if (cluster_method=="mean"){
      mydata_filter$metabolite_mean_median <- mean(mydata_filter[,"metabolite"])
    }else if(cluster_method=="median") {
      mydata_filter$metabolite_mean_median <- stats::median(mydata_filter[,"metabolite"])
    }

    mydata_cluster <- mydata_filter %>%
      dplyr::mutate(cluster=ifelse(metabolite > metabolite_mean_median,"higher","lower"))

    #OS surv_object
#    surv_object <- survival::Surv(time = mydata_cluster$time, event = mydata_cluster$status)
#    fit_cluster <- survival::survfit(surv_object ~ cluster, data = mydata_cluster)

    fit_cluster <- survival::survfit(survival::Surv(time = time, event = status) ~ cluster,data=mydata_cluster)
    p1 <- survminer::ggsurvplot(fit_cluster, data = mydata_cluster, pval = TRUE,title=metabolite)
    grDevices::pdf(paste0(out_dir,"/",metabolite,".survival.pdf"),width=8,height=8,onefile=FALSE)
    print(p1)
    grDevices::dev.off()
    grDevices::png(paste0(out_dir,"/",metabolite,".survival.png"))
    print(p1)
    grDevices::dev.off()

  }
}
