#' the KEGG pathway analysis which includes the extended pathway analysis of gene and metabolites
#'
#' @param name The genes' or the metabolites' names which to analysis pathway
#' @param out The pathway type for gene or metabolite,or extended pathway included genes and metabolites,default is extended pathway
#' @param p_cutoff p_cutoff used to declare the significant terms. By default, it is set to 0.05
#'
#' @return test
#' @export
#'
#' @examples
#' name <- c("C15973","C16254","MDH1")
#' result <- PathwayAnalysis(name,out="Extended",p_cutoff=0.05)
#' name <- "C15973"
#' result <- PathwayAnalysis(name,out="metabolite",p_cutoff=0.05)
#' name <- "MDH1"
#' result <- PathwayAnalysis(name,out="gene",p_cutoff=0.05)
PathwayAnalysis <- function(name,out="Extended",p_cutoff=0.05) {
  if (out=="Extended") {
      PathwayExtendData <- PathwayExtendData %>%
        dplyr::select(name,kegg_pathwayname,kegg_category)
      result <- xgr(name,PathwayExtendData,p_cutoff=p_cutoff)
  }else if (out=="gene") {
    PathwayExtendData <- PathwayExtendData %>%
      dplyr::filter(type=="gene") %>%
      dplyr::select(name,kegg_pathwayname,kegg_category)
    result <- xgr(name,PathwayExtendData,p_cutoff=p_cutoff)
  }else if (out=="metabolite") {
    PathwayExtendData <- PathwayExtendData %>%
      dplyr::filter(type=="metabolite") %>%
      dplyr::select(name,kegg_pathwayname,kegg_category)
    result <- xgr(name,PathwayExtendData,p_cutoff=p_cutoff)
  }
  
  result_temp <- result$output

  kegg_a <- all_kegg_id %>%
    dplyr::filter(source=="KEGG") %>%
    tidyr::separate_rows(ENTRY) %>%
    dplyr::arrange(ENTRY) %>%
    dplyr::distinct(ENTRY,.keep_all = TRUE)

  result_final <- result_temp %>%
    dplyr::mutate(members_Overlap_keggid=members_Overlap) %>%
    dplyr::mutate(members_Anno_keggid=members_Anno) %>%
    tidyr::separate_rows(members_Overlap,sep=", ") %>%
    dplyr::left_join(kegg_a,by=c("members_Overlap"="ENTRY")) %>%
    dplyr::mutate(NAME=ifelse(is.na(NAME),members_Overlap,NAME)) %>%
    dplyr::select(-source) %>%
    dplyr::group_by(name,nAnno,nOverlap,fc,zscore,pvalue,adjp,or,CIl,CIu,distance,namespace,members_Anno,members_Overlap_keggid,members_Anno_keggid) %>%
    dplyr::summarise(members_Overlap=paste(NAME,collapse=", ")) %>%
    tidyr::separate_rows(members_Anno,sep=", ") %>%
    dplyr::left_join(kegg_a,by=c("members_Anno"="ENTRY")) %>%
    dplyr::mutate(NAME=ifelse(is.na(NAME),members_Anno,NAME)) %>%
    dplyr::select(-source) %>%
    dplyr::group_by(name,nAnno,nOverlap,fc,zscore,pvalue,adjp,or,CIl,CIu,distance,namespace,members_Overlap,members_Overlap_keggid,members_Anno_keggid) %>%
    dplyr::summarise(members_Anno=paste(NAME,collapse=", "))

  result$output <- result_final

  kegg_pathway_uniq <- PathwayExtendData %>%
  dplyr::select(kegg_pathwayname,kegg_category) %>%
  dplyr::rename("PATHWAY"="kegg_pathwayname") %>%
  dplyr::rename("pathway_type"="kegg_category") %>%
  unique()

  result_1 <- result$output %>%
    dplyr::filter(pvalue < p_cutoff) %>%
    dplyr::arrange(pvalue) %>%
    dplyr::left_join(kegg_pathway_uniq,by=c("name"="PATHWAY"))

  result_1$name <- factor(result_1$name,levels = rev(result_1$name))
  result_1$pathway_type <- factor(result_1$pathway_type,levels=unique(kegg_pathway_uniq$pathway_type))

  p1 <- ggplot(result_1,aes(name,-log10(pvalue)))+
    geom_bar(stat="identity",aes(fill=pathway_type))+
    scale_fill_manual(values=brewer.pal(11, "Set3"),
                      breaks=unique(kegg_pathway_uniq$pathway_type))+
    coord_flip()+
    theme_bw()+
    labs(x=NULL)
  result$p_barplot <- p1
  return(result)
}


