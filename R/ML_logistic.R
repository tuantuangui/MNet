#' @title Feature selection using logistic regression
#'
#' @param object A dataframe-like data object containing log-metabolite intensity values, with columns corresponding to metabolites and must containing the group column, and the rows corresponding to the samples
#' @param out_dir the out directory
#' @param seed the seed
#' @param auc_cutoff the cut off of auc that be filtered
#'
#' @return test
#' 
#' @importFrom magrittr %>%
#' @importFrom caret createDataPartition
#' @importFrom reshape2 melt
#' @importFrom stats as.formula glm binomial predict
#' @importFrom pROC auc roc
#' @importFrom grDevices pdf dev.off rainbow
#' @importFrom graphics text
#' @importFrom dplyr arrange
#' @importFrom utils write.table
#' @export
#'
#' @examples
#' library(MNet)
#'
ML_logistic <- function(object,
                        out_dir = "logistic/",
                        seed = NULL,
                        auc_cutoff = 0.8) {
  ## ML_logistic(object)
  dir.create(out_dir, recursive = TRUE)
  set.seed(NULL)
  
  test_set <- auc <- NULL
  object1 = as.data.frame(lapply(object[, -which(colnames(object) == "group")], as.numeric))
  object1$group <- object$group
  object <- object1
  parts = caret::createDataPartition(object$group, p = .8, list = F)
  train_data = object[parts, ]
  test_data = object[-parts, ]
  
  train_data$group <- as.factor(train_data$group)
  test_data$group <- as.factor(test_data$group)
  
  train_data_new <- train_data
  train_data_new$type <- "train"
  
  test_data_new <- test_data
  test_data_new$type <- "test"
  
  all_data  <- rbind(train_data_new, test_data_new)
  all_data_melt <- reshape2::melt(all_data, id = c("group", "type"))
  
  test1_result <- data.frame()
  
  meta <- setdiff(names(train_data), "group")
  
  for (meta_name in meta) {
    meta_name_raw <- meta_name
    
    myform <- stats::as.formula(paste('group ~ ', meta_name, sep = ""))
    glm_model <- stats::glm(
      myform,
      data = train_data,
      family = stats::binomial(link = "logit"),
      control = list(maxit = 200)
    )
    newdata <- data.frame(test_data[, meta_name])
    names(newdata) <- meta_name
    
    glm_pred_test1_out <- stats::predict(object = glm_model,
                                         newdata = newdata,
                                         type = "response")  #输出概率
    
    glm.auc1 <- pROC::auc(pROC::roc(test_data$group, glm_pred_test1_out))
    
    if (glm.auc1 > auc_cutoff) {
      grDevices::pdf(paste0(out_dir, "/", meta_name, ".pdf"))
      
      plot(
        pROC::roc(test_data$group, glm_pred_test1_out),
        col = grDevices::rainbow(10),
        main = paste(
          "ROC for Logistic Regression model in",
          meta_name_raw,
          "in test set"
        )
      )
      graphics::text(0.8,
                     0.2,
                     labels = paste('AUC=', round(glm.auc1, 3), sep = ''),
                     cex = 1.2)
      grDevices::dev.off()
    }
    test1 <- c(meta_name_raw, round(glm.auc1, 3))
    test1_result <- rbind(test1_result, test1)
  }
  
  names(test1_result) <- c("test_set", "auc")
  
  test1_result <- test1_result %>%
    dplyr::arrange(auc)
  
  test1_result$test_set <- factor(test1_result$test_set, levels = test1_result$test_set)
  
  p2 <- ggplot2::ggplot(test1_result, ggplot2::aes(x = test_set, y = as.numeric(auc))) +
    ggplot2::geom_bar(stat = "identity",
                      width = 0.5,
                      fill = "#6a855b") +
    ggplot2::theme_bw() +
    ggplot2::coord_flip(ylim = c(0.3, 1.02)) +
    ggplot2::theme(
      axis.text.x = ggplot2::element_text(angle = 45, hjust = 1),
      axis.ticks.y = ggplot2::element_blank(),
      panel.grid.major.x = ggplot2::element_blank(),
      panel.grid.minor.x = ggplot2::element_blank()
    ) +
    ggplot2::labs(x = NULL, y = "auc in test set")
  
  ggplot2::ggsave(paste0(out_dir, "/AUC.pdf"), p2)
  utils::write.table(
    test1_result,
    paste0(out_dir, "/AUC.txt"),
    quote = FALSE,
    sep = "\t",
    row.names = FALSE
  )
}
