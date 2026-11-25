#' @title Feature selection using logistic regression
#'
#' @param object A dataframe with numeric predictors and a two-class `group` column
#' @param out_dir Directory where ROC plots and the AUC table are saved
#' @param seed Random seed for the stratified train/test split
#' @param auc_cutoff Minimum test-set AUC for saving an individual ROC plot
#'
#' @return A data frame containing each predictor's test-set AUC
#'
#' @importFrom caret createDataPartition
#' @importFrom reshape2 melt
#' @importFrom stats glm predict
#' @importFrom pROC auc roc
#' @importFrom grDevices pdf dev.off rainbow
#' @importFrom graphics text
#' @importFrom dplyr arrange
#' @importFrom utils write.table
#' @export
#'
ML_logistic <- function(object,
                        out_dir = "logistic/",
                        seed = 123,
                        auc_cutoff = 0.8) {
  object <- .mnet_prepare_ml_data(object, min_class_size = 2L)
  if (length(auc_cutoff) != 1L || is.na(auc_cutoff) || auc_cutoff < 0 || auc_cutoff > 1) {
    stop("`auc_cutoff` must be a single value between 0 and 1.", call. = FALSE)
  }

  set.seed(seed)
  if (!dir.exists(out_dir) && !dir.create(out_dir, recursive = TRUE)) {
    stop("Could not create output directory: ", out_dir, call. = FALSE)
  }
  parts <- caret::createDataPartition(object$group, p = 0.8, list = FALSE)
  train_data <- object[parts, , drop = FALSE]
  test_data <- object[-parts, , drop = FALSE]
  if (length(unique(train_data$group)) != 2L || length(unique(test_data$group)) != 2L) {
    stop("The train/test split must contain both group classes.", call. = FALSE)
  }

  predictors <- setdiff(names(object), "group")
  auc_rows <- lapply(predictors, function(feature) {
    train_frame <- data.frame(group = train_data$group, predictor = train_data[[feature]])
    test_frame <- data.frame(predictor = test_data[[feature]])
    model <- stats::glm(group ~ predictor, data = train_frame,
                        family = stats::binomial(link = "logit"),
                        control = list(maxit = 200))
    predicted <- stats::predict(model, newdata = test_frame, type = "response")
    roc_curve <- pROC::roc(test_data$group, predicted, quiet = TRUE)
    auc_value <- as.numeric(pROC::auc(roc_curve))

    if (is.finite(auc_value) && auc_value > auc_cutoff) {
      safe_feature <- gsub("[^A-Za-z0-9_.-]+", "_", feature)
      grDevices::pdf(file.path(out_dir, paste0(safe_feature, ".pdf")))
      tryCatch({
        graphics::plot(roc_curve, col = grDevices::rainbow(10),
             main = paste("ROC for Logistic Regression model in", feature, "in test set"))
        graphics::text(0.8, 0.2, labels = paste0("AUC=", round(auc_value, 3)), cex = 1.2)
      }, finally = grDevices::dev.off())
    }
    data.frame(test_set = feature, auc = round(auc_value, 3), stringsAsFactors = FALSE)
  })

  result <- do.call(rbind, auc_rows)
  result <- result[order(result$auc), , drop = FALSE]
  result$test_set <- factor(result$test_set, levels = result$test_set)
  plot_auc <- ggplot2::ggplot(result, ggplot2::aes(x = test_set, y = as.numeric(auc))) +
    ggplot2::geom_bar(stat = "identity", width = 0.5, fill = "#6a855b") +
    ggplot2::theme_bw() +
    ggplot2::coord_flip(ylim = c(0.3, 1.02)) +
    ggplot2::theme(
      axis.text.x = ggplot2::element_text(angle = 45, hjust = 1),
      axis.ticks.y = ggplot2::element_blank(),
      panel.grid.major.x = ggplot2::element_blank(),
      panel.grid.minor.x = ggplot2::element_blank()
    ) +
    ggplot2::labs(x = NULL, y = "auc in test set")

  ggplot2::ggsave(file.path(out_dir, "AUC.pdf"), plot_auc)
  utils::write.table(result, file.path(out_dir, "AUC.txt"), quote = FALSE,
                     sep = "\t", row.names = FALSE)
  invisible(result)
}
