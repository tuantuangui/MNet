#' @title Univariate Cox analysis of metabolites
#'
#' @param dat A data frame containing numeric `time`, binary `status` (0=censored, 1=event), and one or more numeric metabolite columns
#'
#' @return A table of coefficient, hazard ratio with 95% confidence interval, Wald statistic, and p-value for each metabolite
#'
#' @importFrom tibble as_tibble
#' @export
#'
#' @examples
#' result <- MetCox(dat_surv)
#' result
#'
MetCox <- function(dat) {
  if (!is.data.frame(dat)) {
    dat <- tryCatch(as.data.frame(dat), error = function(e) NULL)
  }
  if (is.null(dat) || !all(c("time", "status") %in% names(dat)) || ncol(dat) < 3L) {
    stop("`dat` must contain numeric 'time', binary 'status', and at least one metabolite column.", call. = FALSE)
  }
  if (!is.numeric(dat$time) || anyNA(dat$time) || any(!is.finite(dat$time)) || any(dat$time < 0)) {
    stop("`time` must contain finite, non-negative numeric values.", call. = FALSE)
  }
  status <- as.character(dat$status)
  if (anyNA(status) || !all(status %in% c("0", "1")) || length(unique(status)) != 2L) {
    stop("`status` must contain both binary values 0 (censored) and 1 (event), with no missing values.", call. = FALSE)
  }
  metabolite_names <- setdiff(names(dat), c("time", "status"))

  results <- lapply(metabolite_names, function(feature) {
    predictor <- dat[[feature]]
    if (is.factor(predictor) || is.character(predictor)) {
      predictor <- suppressWarnings(as.numeric(as.character(predictor)))
    }
    if (!is.numeric(predictor)) {
      stop(sprintf("Metabolite '%s' must be numeric.", feature), call. = FALSE)
    }
    model_data <- data.frame(time = dat$time, status = as.numeric(status), predictor = predictor)
    model_data <- model_data[stats::complete.cases(model_data), , drop = FALSE]
    if (nrow(model_data) < 3L || length(unique(model_data$status)) != 2L ||
        length(unique(model_data$predictor)) < 2L) {
      return(data.frame(
        name = feature, beta = NA_real_, `HR (95% CI for HR)` = NA_character_,
        wald.test = NA_real_, `p-value` = NA_real_, check.names = FALSE
      ))
    }

    fit <- tryCatch(
      survival::coxph(survival::Surv(time, status) ~ predictor, data = model_data),
      error = function(e) NULL
    )
    if (is.null(fit)) {
      return(data.frame(
        name = feature, beta = NA_real_, `HR (95% CI for HR)` = NA_character_,
        wald.test = NA_real_, `p-value` = NA_real_, check.names = FALSE
      ))
    }
    fit_summary <- summary(fit)
    coefficient <- fit_summary$coefficients[1, ]
    confidence <- fit_summary$conf.int[1, ]
    hr_ci <- sprintf("%.8g (%.8g-%.8g)", confidence["exp(coef)"],
                     confidence["lower .95"], confidence["upper .95"])
    data.frame(
      name = feature,
      beta = signif(coefficient["coef"], 2),
      `HR (95% CI for HR)` = hr_ci,
      wald.test = signif(fit_summary$wald["test"], 2),
      `p-value` = signif(fit_summary$wald["pvalue"], 2),
      check.names = FALSE,
      stringsAsFactors = FALSE
    )
  })
  tibble::as_tibble(do.call(rbind, results))
}
