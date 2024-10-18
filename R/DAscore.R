#' @title Differential abundance (DA) score
#' @description Calculate the differential abundance (DA) score and visualization the DA score
#'
#' @param increase_members the increased gene symbols and (or) metabolites' kegg id
#' @param decrease_members the decreased gene symbols and (or) metabolites' kegg id
#' @param all_members the all measured gene symbols and (or) metabolites' kegg id
#' @param sort_plot the method of pathway rank in the plot,Default rank by DA score. if value is category, then rank by pathway category
#' @param min_measured_num the minimum measured members that be ploted in a pathway, Default the value is 2.
#' @param out the analysis type,default "metabolite", alternative is "gene" and "Extended"
#'
#' @return Calculate the differential abundance (DA) score and visualization of the DA score
#' 
#' @importFrom utils data
#' @importFrom dplyr %>% filter pull left_join select arrange rename
#' @importFrom tibble as_tibble
#' @import ggplot2
#' @importFrom RColorBrewer brewer.pal
#' @export
#'
#' @examples
#' name <- c("C00022","C00024","C00031","B4GALT2","AGPAT3","FHIT")
#' DAscore_result <- DAscore(c(name[1], name[4]),
#'                           name[2], name, min_measured_num = 0,
#'                           sort_plot = "category")
#' 
#' DAscore_result$result
#' DAscore_result$p
#'
DAscore <- function(increase_members,
                    decrease_members,
                    all_members,
                    sort_plot = NA,
                    min_measured_num = 2,
                    out = "metabolite") {
  utils::data("PathwayExtendData")
  
  name <- kegg_pathwayname <- pathway_type <- measured_members_num <- type <- `Pathway Category` <- NULL
  
  if (out == "gene") {
    pathway_data <- PathwayExtendData %>%
      dplyr::filter(type == "gene")
  } else if (out == "metabolite") {
    pathway_data <- PathwayExtendData %>%
      dplyr::filter(type == "metabolite")
  } else if (out == "Extended") {
    pathway_data <- PathwayExtendData
  }
  
  pathway_all <- pathway_data %>%
    dplyr::filter(name %in% c(increase_members, decrease_members)) %>%
    dplyr::pull(kegg_pathwayname) %>%
    unique()
  
  if (length(pathway_all) == 0) {
    return(NA)
  } else {
    DA_score_result <- c()
    all_members_num <- c()
    increase_member_result <- c()
    decrease_member_result <- c()
    measure_member_result <- c()
    
    increase_members_num_result <- c()
    decrease_members_num_result <- c()
    
    for (pathway in pathway_all) {
      if (length(increase_members) > 0) {
        increase_members_num <- pathway_data %>%
          dplyr::filter(name %in% increase_members) %>%
          dplyr::filter(kegg_pathwayname == pathway) %>%
          nrow()
        increase_members_pathway <- pathway_data %>%
          dplyr::filter(name %in% increase_members) %>%
          dplyr::filter(kegg_pathwayname == pathway) %>%
          dplyr::pull(name) %>%
          paste(collapse = ";")
      } else {
        increase_members_num = 0
      }
      
      if (length(decrease_members) > 0) {
        decrease_members_num <- pathway_data %>%
          dplyr::filter(name %in% decrease_members) %>%
          dplyr::filter(kegg_pathwayname == pathway) %>%
          nrow()
        decrease_members_pathway <- pathway_data %>%
          dplyr::filter(name %in% decrease_members) %>%
          dplyr::filter(kegg_pathwayname == pathway) %>%
          dplyr::pull(name) %>%
          paste(collapse = ";")
      } else {
        decrease_members_num = 0
      }
      
      measure_members_num <- pathway_data %>%
        dplyr::filter(kegg_pathwayname == pathway) %>%
        dplyr::filter(name %in% all_members) %>%
        nrow()
      measure_members_pathway <- pathway_data %>%
        dplyr::filter(kegg_pathwayname == pathway) %>%
        dplyr::filter(name %in% all_members) %>%
        dplyr::pull(name) %>%
        paste(collapse = ";")
      
      da_score <- (increase_members_num - decrease_members_num) / measure_members_num
      DA_score_result <- c(DA_score_result, da_score)
      all_members_num <- c(all_members_num, measure_members_num)
      if (length(increase_members) > 0) {
        increase_member_result <- c(increase_member_result, increase_members_pathway)
      } else{
        #        increase_member_result <- increase_member_result
        increase_member_result <- NA
      }
      
      if (length(decrease_members) > 0) {
        decrease_member_result <- c(decrease_member_result, decrease_members_pathway)
      } else {
        #        decrease_member_result <- decrease_member_result
        decrease_member_result <- NA
      }
      measure_member_result <- c(measure_member_result, measure_members_pathway)
      
      increase_members_num_result <- c(increase_members_num_result, increase_members_num)
      decrease_members_num_result <- c(decrease_members_num_result, decrease_members_num)
    }
    result <- data.frame(
      pathway = pathway_all,
      da_score = DA_score_result,
      increase_members_num = increase_members_num_result,
      decrease_members_num = decrease_members_num_result,
      measured_members_num = all_members_num,
      increase_member_result = increase_member_result,
      decrease_member_result = decrease_member_result,
      measure_member_result = measure_member_result
    ) %>%
      dplyr::left_join(pathway_data, by = c("pathway" = "kegg_pathwayname")) %>%
      dplyr::select(-name, -type) %>%
      unique() %>%
      dplyr::arrange(da_score) %>%
      dplyr::rename(`Pathway Category` = "kegg_category") %>%
      tibble::as_tibble()
    
    
    result_filter <- result %>%
      dplyr::filter(measured_members_num >= min_measured_num)
    
    
    if (is.na(sort_plot)) {
      result_filter$pathway <- factor(result_filter$pathway, levels = result_filter$pathway)
    } else if (sort_plot == "category") {
      result_filter <- result_filter %>%
        dplyr::arrange(`Pathway Category`)
      
      result_filter$pathway <- factor(result_filter$pathway, levels = result_filter$pathway)
    }
    
    p <- ggplot2::ggplot(result_filter) +
      ggplot2::geom_point(ggplot2::aes(
        x = pathway,
        y = da_score,
        size = log2(measured_members_num),
        color = `Pathway Category`
      )) +
      ggplot2::geom_pointrange(
        ggplot2::aes(
          x = pathway,
          y = da_score,
          ymin = 0,
          ymax = da_score,
          color = `Pathway Category`
        )
      ) +
      scale_color_manual(
        values = RColorBrewer::brewer.pal(11, "Set3"),
        name = "Pathway Category",
        breaks = unique(pathway_data$kegg_category)
      ) +
      ggplot2::coord_flip() +
      #      ggplot2::ylab("DA score")+
      ggplot2::xlab(NULL) +
      ggplot2::theme_bw()
    
    if (out == "Extended") {
      p <- p + ggplot2::ylab("EDA score")
    } else {
      p <- p + ggplot2::ylab("DA score")
    }
    
    DA_score <- Increase_members_num <- Decrease_members_num <- Measured_members_num <- Increase_member_result <- Decrease_member_result <- Measure_member_result <- KEGG_pathwayid <- NULL
    
    
    result <- result %>%
      as.data.frame() %>%
      dplyr::rename("Pathway" = "pathway") %>%
      dplyr::rename("DA_score" = "da_score") %>%
      dplyr::rename("Increase_members_num" = "increase_members_num") %>%
      dplyr::rename("Decrease_members_num" = "decrease_members_num") %>%
      dplyr::rename("Measured_members_num" = "measured_members_num") %>%
      dplyr::rename("Increase_member_result" = "increase_member_result") %>%
      dplyr::rename("Decrease_member_result" = "decrease_member_result") %>%
      dplyr::rename("Measure_member_result" = "measure_member_result") %>%
      dplyr::rename("KEGG_pathwayid" = "kegg_pathwayid") %>%
      tibble::as_tibble()
    result_1 <- list(result = result, p = p)
    return(result_1)
  }
}
