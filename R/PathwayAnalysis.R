#' KEGG pathway analysis
#'
#' the KEGG pathway analysis which includes the extended pathway analysis of gene and metabolites
#'
#' @param name The genes' or the metabolites' names which to analysis pathway
#' @param out The pathway type for gene or metabolite,or extended pathway included genes and metabolites,default is "extended",alternative is "metabolite" and "gene"
#' @param p_cutoff p_cutoff used to declare the significant terms. By default, it is set to 0.05
#' @param noverlap_cutoff noverlap_cutoff used to declare the number of overlap. By default, it is set to 0
#' @param test the test statistic used. It can be "fisher" for using fisher's exact test, "hypergeo" for using hypergeometric test, or "binomial" for using binomial test. Fisher's exact test is to test the independence between gene group (genes belonging to a group or not) and gene annotation (genes annotated by a term or not), and thus compare sampling to the left part of background (after sampling without replacement). Hypergeometric test is to sample at random (without replacement) from the background containing annotated and non-annotated genes, and thus compare sampling to background. Unlike hypergeometric test, binomial test is to sample at random (with replacement) from the background with the constant probability. In terms of the ease of finding the significance, they are in order: hypergeometric test > fisher's exact test > binomial test. In other words, in terms of the calculated p-value, hypergeometric test < fisher's exact test < binomial test
#'
#'
#' @return result
#' @export
#'
#' @examples
#' name <- c("C15973","C16254","MDH1")
#' result <- PathwayAnalysis(name,out="Extended",p_cutoff=0.05,noverlap_cutoff=0,test="hypergeo")
#' name <- "C15973"
#' result <- PathwayAnalysis(name,out="metabolite",p_cutoff=0.05,noverlap_cutoff=0,test="hypergeo")
#' name <- "MDH1"
#' result <- PathwayAnalysis(name,out="gene",p_cutoff=0.05,noverlap_cutoff=0,test="hypergeo")
PathwayAnalysis <- function(name,out="Extended",p_cutoff=0.05,noverlap_cutoff=0,test = c("hypergeo","fisher","binomial")) {
  if (out=="Extended") {
      PathwayExtendData <- PathwayExtendData %>%
        dplyr::select(name,kegg_pathwayname,kegg_category,type)
      result <- xgr(name,PathwayExtendData,p_cutoff=p_cutoff,noverlap_cutoff= noverlap_cutoff,test = test)
  }else if (out=="gene") {
    PathwayExtendData <- PathwayExtendData %>%
      dplyr::filter(type=="gene") %>%
      dplyr::select(name,kegg_pathwayname,kegg_category,type)
    result <- xgr(name,PathwayExtendData,p_cutoff=p_cutoff,noverlap_cutoff=noverlap_cutoff,test = test)
  }else if (out=="metabolite") {
    PathwayExtendData <- PathwayExtendData %>%
      dplyr::filter(type=="metabolite") %>%
      dplyr::select(name,kegg_pathwayname,kegg_category,type)
    result <- xgr(name,PathwayExtendData,p_cutoff=p_cutoff,noverlap_cutoff=noverlap_cutoff,test = test)
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
  dplyr::rename("Pathway_Category"="kegg_category") %>%
  unique()

  result_1 <- result$output %>%
    dplyr::filter(pvalue < p_cutoff) %>%
    dplyr::arrange(pvalue) %>%
    dplyr::left_join(kegg_pathway_uniq,by=c("name"="PATHWAY"))

  result_1$name <- factor(result_1$name,levels = rev(result_1$name))
  result_1$Pathway_Category <- factor(result_1$Pathway_Category,levels=unique(kegg_pathway_uniq$Pathway_Category))

  p1 <- ggplot(result_1,aes(name,-log10(pvalue)))+
    geom_bar(stat="identity",aes(fill=Pathway_Category))+
    scale_fill_manual(values=RColorBrewer::brewer.pal(11, "Set3"),
                      breaks=unique(kegg_pathway_uniq$Pathway_Category))+
    coord_flip()+
    theme_bw()+
    labs(x=NULL)
  result$p_barplot <- p1
  return(result)
}


