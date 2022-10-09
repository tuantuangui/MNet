
#' The OS,RFS and EFS's survival analysis
#'
#' @param clinical_survival the data.frame must have the column name of OS_status, OS_time, group;
#' the column name of RFS_status,RFS_time,EFS_status,EFS_time is alternative
#'
#' @return test
#' @export
#'
#' @examples
#' p <- survCli(clinical_survival)
#' p$p_OS
#' p$p_RFS
#' p$p_EFS
survCli <- function(clinical_survival) {

  #OS surv_object
#  surv1 <- survival::Surv(time = clinical_survival$OS_time, event = clinical_survival$OS_status)
#  fit_cluster <- survival::survfit(surv1 ~ group, data = clinical_survival)
  fit_cluster <- survival::survfit(survival::Surv(time = OS_time, event = OS_status)~group,data=clinical_survival)
  p_OS <- survminer::ggsurvplot(fit_cluster, data = clinical_survival, pval = TRUE,title="OS")

  if ("RFS_status" %in% names(clinical_survival)) {
    #RFS surv_object
#    surv_object <- survival::Surv(time = clinical_survival$RFS_time, event = clinical_survival$RFS_status)
#    fit_cluster <- survival::survfit(surv_object ~ group, data = clinical_survival)

   fit_cluster <- survival::survfit(survival::Surv(time = RFS_time, event = RFS_status)~group,data=clinical_survival)
    p_RFS <- survminer::ggsurvplot(fit_cluster, data = clinical_survival, pval = TRUE,title="RFS")
  }

  if ("EFS_status" %in% names(clinical_survival)) {
    #EFS surv_object
#    surv_object <- survival::Surv(time = clinical_survival$EFS_time, event = clinical_survival$EFS_status)
#    fit_cluster <- survival::survfit(surv_object ~ group, data = clinical_survival)
    fit_cluster <- survival::survfit(survival::Surv(time = EFS_time, event = EFS_status)~group,data=clinical_survival)
    p_EFS <- survminer::ggsurvplot(fit_cluster, data = clinical_survival, pval = TRUE,title="EFS")
  }

  p <- list(p_OS=p_OS,p_RFS=p_RFS,p_EFS=p_EFS)
  return(p)
}
