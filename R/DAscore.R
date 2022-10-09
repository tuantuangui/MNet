#' @importFrom magrittr %>%
#' @import vegan
#' @import Biobase
#' @import e1071
NULL

#' Calculate the differential abundance (DA) score and show the DA figure
#'
#' @param increase_metabolites the increased metabolites  that needed kegg id
#' @param decrease_metabolites the decreased metabolites that needed kegg id
#' @param all_metabolites the all metabolites that kegg id
#' @param sort_plot the method of pathway rank in the plot,Default rank by DA score.
#' if value is classification, then rank by pathway classification
#' @param min_measured_num the minimum measured metabolites that be ploted in a pathway,
#' Default the value is 2.
#'
#' @return Calculate the differential abundance (DA) score and show the DA figure
#'
#' @examples
#' name <- c("C00022","C00024","C00031")
#' test <- DAscore(name[1],name[2],name,min_measured_num = 0,sort_plot = "classification")
#' test$result
#' test$p
#'
#'
#' @export

DAscore <- function(increase_metabolites,decrease_metabolites,all_metabolites,sort_plot=NA,
                    min_measured_num=2) {
  library(dplyr)
  ENTRY <- PATHWAY <- pathway_type <- measured_metabolites_num <- NAME <- `pathway classification` <- NULL
  pathway_all <- kegg_pathway %>%
    dplyr::filter(ENTRY %in% c(increase_metabolites,decrease_metabolites)) %>%
    dplyr::pull(PATHWAY) %>%
    unique()

  DA_score_result <- c()
  all_metabolites_num <- c()

  for (pathway in pathway_all) {
    increase_metabolites_num <- kegg_pathway %>%
      dplyr::filter(ENTRY %in% increase_metabolites) %>%
      dplyr::filter(PATHWAY==pathway) %>%
      nrow()
    decrease_metabolites_num <- kegg_pathway %>%
      dplyr::filter(ENTRY %in% decrease_metabolites) %>%
      dplyr::filter(PATHWAY==pathway) %>%
      nrow()
    measure_metabolites_num <- kegg_pathway %>%
      dplyr::filter(PATHWAY==pathway) %>%
      dplyr::filter(ENTRY %in% all_metabolites) %>%
      nrow()

    da_score <- (increase_metabolites_num-decrease_metabolites_num)/measure_metabolites_num
    DA_score_result <- c(DA_score_result,da_score)
    all_metabolites_num <- c(all_metabolites_num,measure_metabolites_num)

  }
  result <- data.frame(pathway=pathway_all,da_score=DA_score_result,measured_metabolites_num=all_metabolites_num) %>%
    dplyr::left_join(kegg_pathway,by=c("pathway"="PATHWAY")) %>%
    dplyr::select(-c("ENTRY","NAME")) %>%
    unique() %>%
    dplyr::arrange(da_score) %>%
    dplyr::rename("pathway classification"="pathway_type")


    result_filter <- result %>%
      dplyr::filter(measured_metabolites_num>=min_measured_num)


  if (is.na(sort_plot)) {
    result_filter$pathway <- factor(result_filter$pathway,levels=result_filter$pathway)
  }else if (sort_plot=="classification") {
    result_filter <- result_filter %>%
      dplyr::arrange(`pathway classification`)

    result_filter$pathway <- factor(result_filter$pathway,levels=result_filter$pathway)
  }

  p <- ggplot2::ggplot(result_filter)+
    ggplot2::geom_point(ggplot2::aes(x=pathway,y=da_score,size=log2(measured_metabolites_num),color=`pathway classification`))+
    ggplot2::geom_pointrange(ggplot2::aes(x=pathway,y=da_score,ymin=0,ymax=da_score,color=`pathway classification`))+
    ggplot2::coord_flip()+
    ggplot2::ylab("DA score")+
    ggplot2::xlab(NULL)+
    ggplot2::theme_bw()

  result_1 <- list(result=result,p=p)
  return(result_1)
}
