#' @title The survival analysis and visualization
#'
#' @param clinical_survival the data.frame must have the column name of status, time, group
#'
#' @return Figure
#'
#' @importFrom survival survfit Surv
#' @importFrom survminer ggsurvplot
#' @export
#'
#' @examples
#' # names(aml)[3] ="group"
#' # plot = survCli(aml)
#' # plot
#' 
survCli <- function(clinical_survival) {
  #OS surv_object
  fit_cluster <- survival::survfit(survival::Surv(time = time, event = status) ~
                                     group, data = clinical_survival)
  p <- survminer::ggsurvplot(fit_cluster,
                             data = clinical_survival,
                             pval = TRUE,
                             title = "survival")
  
  return(p)
}
