#' @title Visualization of the z-score plot
#'
#' @param object A dataframe-like data object containing raw metabolite intensity values, with rows corresponding to metabolites, and the columns corresponding to the samples
#' @param group the sample's group information
#' @param tumor_color the color of the tumor group
#' @param normal_color the color of the normal group
#' @param shape_size the size of the point shape
#' @param ysize the size of the y-axis text
#'
#' @return Visualization of the z-score plot
#' 
#' @importFrom magrittr %>%
#' @importFrom dplyr select filter arrange distinct mutate rename pull summarise group_by left_join inner_join cross_join
#' @importFrom tibble rownames_to_column
#' @importFrom reshape2 melt
#' @import ggplot2
#' @export
#'
#' @examples
#' library(dplyr)
#'
#' diff_result <- DM(2**meta_dat,group)
#' # filter the differential metabolites by default fold change >1.5 or < 1/1.5 ,fdr < 0.05 and VIP>1
#' diff_result_filter <- diff_result %>%
#'   dplyr::filter(Fold_change >1.3 | Fold_change < 1/1.3) %>%
#'   dplyr::filter(Padj_wilcox<0.1) %>%
#'   dplyr::filter(VIP>0.8)
#' meta_dat_diff <- meta_dat[rownames(meta_dat) %in% diff_result_filter$Name,]
#'
#' p_zscore <- pZscore(meta_dat_diff,group)
#' p_zscore
#'
pZscore <- function(object,
                    group,
                    tumor_color = "#d53e4f",
                    normal_color = "#7FC8A9",
                    shape_size = 3,
                    ysize = 5) {
  label <- value <- ave <- NULL
  clinical <- data.frame(sample = names(object), group = group)
  
  object_norm <- myscale(object) %>%
    tibble::rownames_to_column(var = "label")
  
  object_melt <- reshape2::melt(object_norm, id = "label")
  
  
  object_melt_group <- object_melt %>%
    dplyr::left_join(clinical, by = c("variable" = "sample"))
  
  object_melt_sort <- object_melt_group %>%
    dplyr::filter(group == "tumor") %>%
    dplyr::group_by(label) %>%
    dplyr::summarise(ave = mean(value)) %>%
    dplyr::arrange(ave)
  
  object_melt_group$label <- factor(object_melt_group$label, levels = object_melt_sort$label)
  
  p <- ggplot2::ggplot(object_melt_group, ggplot2::aes(label, value, color =
                                                         group)) +
    ggplot2::geom_point(shape = "|", size = shape_size) +
    ggplot2::scale_color_manual(values = c(normal_color, tumor_color)) +
    ggplot2::labs(y = "z-score") +
    ggplot2::coord_flip() +
    ggplot2::geom_hline(yintercept = 0, linetype = 'dashed') +
    ggplot2::theme_bw() +
    labs(x = NULL, y = NULL) +
    ggplot2::theme(
      panel.grid.major = ggplot2::element_blank(),
      panel.grid.minor = ggplot2::element_blank(),
      axis.text.y = ggplot2::element_text(hjust = 1, size = ysize)
    )
  
  return(p)
  
}
