#' @title Plot the volcano figure
#'
#' @param mydata the result of `DM()`, containing `Name`, `Fold_change`, and `p-adjust_t`
#' @param foldchange_threshold the fold change, default is 1.5,1/1.5
#' @param p_threshold the p value cutoff, default is 0.05
#'
#' @return test
#' 
#' @importFrom magrittr %>%
#' @importFrom dplyr select filter arrange distinct mutate rename pull summarise group_by left_join inner_join cross_join
#' @import ggplot2
#' @export
#'
#' @examples
#' diff_result <- DM(2**meta_dat,group)
#' p_volcano <- pVolcano(diff_result,foldchange_threshold=1.5)
#' p_volcano
#'
pVolcano <- function(mydata,
                     foldchange_threshold = 1.5,
                     p_threshold = 0.05) {
  mydata <- .mnet_standardize_p_columns(mydata)
  if (!"p-adjust_t" %in% names(mydata)) {
    stop("`mydata` must contain a `p-adjust_t` column.", call. = FALSE)
  }
  Condition <- Name <- Fold_change <- label <- NULL

  mydata$Condition <- ifelse(
    mydata$Fold_change >= foldchange_threshold &
      mydata[["p-adjust_t"]] < p_threshold,
    "Up",
    ifelse(
      mydata$Fold_change <= 1 / foldchange_threshold &
        mydata[["p-adjust_t"]] < p_threshold,
      "Down",
      "Not Sig"
    )
  )
  
  mydata <- mydata %>%
    dplyr::mutate(label = ifelse(Condition == "Not Sig", "", Name))
  print(foldchange_threshold)
  p <- ggplot2::ggplot(mydata, ggplot2::aes(log2(Fold_change), -log2(.data[["p-adjust_t"]]))) +
    ggplot2::geom_point(ggplot2::aes(color = Condition),
                        size = 2,
                        alpha = 0.7) +
    ggplot2::geom_vline(
      xintercept = c(-log2(foldchange_threshold), log2(foldchange_threshold)),
      linetype = 'dashed',
      color = "gray"
    ) +
    ggplot2::geom_hline(
      yintercept = -log2(p_threshold),
      linetype = 'dashed',
      color = "gray"
    ) +
    ggrepel::geom_text_repel(ggplot2::aes(label = label), size = 1) +
    ggplot2::scale_color_manual(values = c(
      "Up" = "red",
      "Not Sig" = "gray",
      "Down" = "blue"
    )) +
    ggplot2::theme_bw() +
    ggplot2::theme(
      panel.grid.major = ggplot2::element_blank(),
      panel.grid.minor = ggplot2::element_blank()
    ) +
    ggplot2::labs(x = "log2(Fold Change)", y = "-log2(p-adjust)")
  return(p)
}
