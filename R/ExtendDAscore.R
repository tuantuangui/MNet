#' @importFrom magrittr %>%
#' @import vegan
#' @import Biobase
#' @import e1071
NULL

#' Calculate the extended differential abundance (EDA) score and show the EDA figure
#'
#' @param increase_gene the increased gene name
#' @param decrease_gene the decreased gene name
#' @param all_gene the all gene
#' @param increase_meta the increased metabolite that needed kegg id
#' @param decrease_gene the decreased metabolite that needed kegg id
#' @param all_gene the all metabolite that needed kegg id
#' @param sort_plot the method of pathway rank in the plot,Default rank by DA score.
#' if value is classification, then rank by pathway classification
#' @param min_measured_num the minimum measured members that be ploted in a pathway,
#' Default the value is 2.
#'
#' @return Calculate the extended differential abundance (EDA) score and show the EDA figure
#'
#' @examples
#' name <- c("C00022","C00024","C00031","B4GALT2","AGPAT3","FHIT")
#' ExtendDAscore_result <- ExtendDAscore(increase_gene="B4GALT2",decrease_gene="FHIT",all_gene=c("B4GALT2","AGPAT3","FHIT"),increase_meta="C00022",decrease_meta="C00024",all_meta=c("C00022","C00024","C00031"),min_measured_num = 0,sort_plot = "classification")
#' ExtendDAscore_result$result
#' ExtendDAscore_result$p
#'
#'
#' @export

ExtendDAscore <- function(increase_gene,decrease_gene,all_gene,
                          increase_meta,decrease_meta,all_meta,sort_plot=NA,
                          min_measured_num=2) {
  
  result_gene <- DAscore(increase_gene,decrease_gene,all_gene,out="gene")
  result_meta <- DAscore(increase_meta,decrease_meta,all_meta,out="metabolite")
  
  result <- rbind(result_gene$result,result_meta$result) %>%
    dplyr::filter(measured_members_num >= min_measured_num) %>%
    dplyr::select(pathway,da_score,`pathway classification`,measured_members_num) %>%
    dplyr::group_by(pathway,`pathway classification`) %>%
    dplyr::summarise(da_score_all=sum(da_score),measured_members_num_all=sum(measured_members_num)) %>%
    dplyr::arrange(da_score_all)
    
  
  result_filter <- result 
  
  
  if (is.na(sort_plot)) {
    result_filter$pathway <- factor(result_filter$pathway,levels=result_filter$pathway)
  }else if (sort_plot=="classification") {
    result_filter <- result_filter %>%
      dplyr::arrange(`pathway classification`)
    
    result_filter$pathway <- factor(result_filter$pathway,levels=result_filter$pathway)
  }
  
  p <- ggplot2::ggplot(result_filter)+
    ggplot2::geom_point(ggplot2::aes(x=pathway,y=da_score_all,size=log2(measured_members_num_all),color=`pathway classification`))+
    ggplot2::geom_pointrange(ggplot2::aes(x=pathway,y=da_score_all,ymin=0,ymax=da_score_all,color=`pathway classification`))+
    ggplot2::coord_flip()+
    ggplot2::ylab("EDA score")+
    ggplot2::xlab(NULL)+
    ggplot2::theme_bw()
  
  result_1 <- list(result=result,p=p)
  return(result_1)
}
  
