
#' The survival analysis and plot
#'
#' @param clinical_survival the data.frame must have the column name of status, time, group;the test data is from survival
#'
#' @return test
#' @export
#'
#' @examples
#' p <- survCli(clinical_survival)
survCli <- function(clinical_survival) {

  #OS surv_object
  fit_cluster <- survival::survfit(survival::Surv(time = time, event = status)~group,data=clinical_survival)
  p <- survminer::ggsurvplot(fit_cluster, data = clinical_survival, pval = TRUE,title="survival")

  return(p)
}
