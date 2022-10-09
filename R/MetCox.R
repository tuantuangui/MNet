
#' The cox analysis about the metabolites
#'
#' @param dat the data that row is sample, and column is the metabolite, the column
#' must have time and status
#'
#' @return test
#' @export
#'
#' @examples
#' result <- MetCox(dat)
MetCox <- function(dat) {
  library(dplyr)
  metabolite_name <- names(dat)[3:ncol(dat)]
  univ_formulas <- lapply(metabolite_name,function(x) stats::as.formula(paste('survival::Surv(time, status)~', x)))

  univ_models <- lapply( univ_formulas, function(x){survival::coxph(x, data = dat)})

  # Extract data
  univ_results <- lapply(univ_models,
                         function(x){
                           x <- summary(x)
                           p.value<-signif(x$wald["pvalue"], digits=2)
                           wald.test<-signif(x$wald["test"], digits=2)
                           beta<-signif(x$coef[1], digits=2);#coeficient beta
                           HR <-signif(x$coef[2], digits=2);#exp(beta)
                           HR.confint.lower <- signif(x$conf.int[,"lower .95"], 2)
                           HR.confint.upper <- signif(x$conf.int[,"upper .95"],2)
                           HR <- paste0(HR, " (",
                                        HR.confint.lower, "-", HR.confint.upper, ")")
                           res<-c(beta, HR, wald.test, p.value)
                           names(res)<-c("beta", "HR (95% CI for HR)", "wald.test",
                                         "p.value")
                           return(res)
                           #return(exp(cbind(coef(x),confint(x))))
                         })
  res <- t(as.data.frame(univ_results, check.names = FALSE))
  result <- as.data.frame(res)
  result <- result[which(result$p.value<0.01),] %>%
    tibble::rownames_to_column(var="gene_id")
  return(result)
}
