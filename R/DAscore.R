#' @importFrom magrittr %>%
#' @import vegan
#' @import Biobase
#' @import e1071
NULL

#' Calculate the differential abundance (DA) score and show the DA figure
#'
#' @param increase_members the increased members that needed kegg id
#' @param decrease_members the decreased members that needed kegg id
#' @param all_members the all members that kegg id
#' @param sort_plot the method of pathway rank in the plot,Default rank by DA score.
#' if value is classification, then rank by pathway classification
#' @param min_measured_num the minimum measured members that be ploted in a pathway,
#' Default the value is 2.
#' @param out the analysis type,default "extended", other choice is "gene" or "metabolite"
#'
#' @return Calculate the differential abundance (DA) score and show the DA figure
#'
#' @examples
#' name <- c("C00022","C00024","C00031","B4GALT2","AGPAT3","FHIT")
#' DAscore_result <- DAscore(c(name[1],name[4]),name[2],name,min_measured_num = 0,sort_plot = "classification")
#' DAscore_result$result
#' DAscore_result$p
#'
#'
#' @export

DAscore <- function(increase_members,decrease_members,all_members,sort_plot=NA,
                    min_measured_num=2,out="extended") {
  name <- kegg_pathwayname <- pathway_type <- measured_members_num <- type <- `pathway classification` <- NULL

  if (out=="extended") {
    pathway_data <- PathwayExtendData
  }else if (out == "gene") {
    pathway_data <- PathwayExtendData %>%
      dplyr::filter(type=="gene")
  }else if (out == "metabolite") {
    pathway_data <- PathwayExtendData %>%
      dplyr::filter(type=="metabolite")
  }

  pathway_all <- pathway_data %>%
    dplyr::filter(name %in% c(increase_members,decrease_members)) %>%
    dplyr::pull(kegg_pathwayname) %>%
    unique()

  DA_score_result <- c()
  all_members_num <- c()
  increase_member_result <- c()
  decrease_member_result <- c()
  measure_member_result <- c()
  
  
  for (pathway in pathway_all) {
    increase_members_num <- pathway_data %>%
      dplyr::filter(name %in% increase_members) %>%
      dplyr::filter(kegg_pathwayname==pathway) %>%
      nrow()
    increase_members_pathway <- pathway_data %>%
      dplyr::filter(name %in% increase_members) %>%
      dplyr::filter(kegg_pathwayname==pathway) %>%
      dplyr::pull(name) %>%
      paste(collapse=";")
    
    decrease_members_num <- pathway_data %>%
      dplyr::filter(name %in% decrease_members) %>%
      dplyr::filter(kegg_pathwayname==pathway) %>%
      nrow()
    decrease_members_pathway <- pathway_data %>%
      dplyr::filter(name %in% decrease_members) %>%
      dplyr::filter(kegg_pathwayname==pathway) %>%
      dplyr::pull(name) %>%
      paste(collapse=";")
    
    measure_members_num <- pathway_data %>%
      dplyr::filter(kegg_pathwayname==pathway) %>%
      dplyr::filter(name %in% all_members) %>%
      nrow()
    measure_members_pathway <- pathway_data %>%
      dplyr::filter(kegg_pathwayname==pathway) %>%
      dplyr::filter(name %in% all_members) %>%
      dplyr::pull(name) %>%
      paste(collapse=";")

    da_score <- (increase_members_num-decrease_members_num)/measure_members_num
    DA_score_result <- c(DA_score_result,da_score)
    all_members_num <- c(all_members_num,measure_members_num)
    increase_member_result <- c(increase_member_result,increase_members_pathway)
    decrease_member_result <- c(decrease_member_result,decrease_members_pathway)
    measure_member_result <- c(measure_member_result,measure_members_pathway)
    
  }
  result <- data.frame(pathway=pathway_all,da_score=DA_score_result,increase_members_num=increase_members_num,
                       decrease_members_num=decrease_members_num,
                       measured_members_num=all_members_num,increase_member_result=increase_member_result,
                       decrease_member_result=decrease_member_result,measure_member_result=measure_member_result) %>%
    dplyr::left_join(pathway_data,by=c("pathway"="kegg_pathwayname")) %>%
    dplyr::select(-c("name","type")) %>%
    unique() %>%
    dplyr::arrange(da_score) %>%
    dplyr::rename("pathway classification"="kegg_category") %>%
    tibble::as_tibble()


    result_filter <- result %>%
      dplyr::filter(measured_members_num>=min_measured_num)


  if (is.na(sort_plot)) {
    result_filter$pathway <- factor(result_filter$pathway,levels=result_filter$pathway)
  }else if (sort_plot=="classification") {
    result_filter <- result_filter %>%
      dplyr::arrange(`pathway classification`)

    result_filter$pathway <- factor(result_filter$pathway,levels=result_filter$pathway)
  }

  p <- ggplot2::ggplot(result_filter)+
    ggplot2::geom_point(ggplot2::aes(x=pathway,y=da_score,size=log2(measured_members_num),color=`pathway classification`))+
    ggplot2::geom_pointrange(ggplot2::aes(x=pathway,y=da_score,ymin=0,ymax=da_score,color=`pathway classification`))+
    ggplot2::coord_flip()+
    ggplot2::ylab("DA score")+
    ggplot2::xlab(NULL)+
    ggplot2::theme_bw()

  result_1 <- list(result=result,p=p)
  return(result_1)
}
