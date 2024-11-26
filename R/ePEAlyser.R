#' @title KEGG pathway analysis
#'
#' @param name The genes' or the metabolites' names which to analysis pathway
#' @param out The pathway type for gene or metabolite,or extended pathway included genes and metabolites,default is "extended",alternative is "metabolite" and "gene"
#' @param p_cutoff p_cutoff used to declare the significant terms. By default, it is set to 0.05
#' @param noverlap_cutoff noverlap_cutoff used to declare the number of overlap. By default, it is set to 0
#' @param test the test statistic used. It can be "fisher" for using fisher's exact test, "hypergeo" for using hypergeometric test, or "binomial" for using binomial test. Fisher's exact test is to test the independence between gene group (genes belonging to a group or not) and gene annotation (genes annotated by a term or not), and thus compare sampling to the left part of background (after sampling without replacement). Hypergeometric test is to sample at random (without replacement) from the background containing annotated and non-annotated genes, and thus compare sampling to background. Unlike hypergeometric test, binomial test is to sample at random (with replacement) from the background with the constant probability. In terms of the ease of finding the significance, they are in order: hypergeometric test > fisher's exact test > binomial test. In other words, in terms of the calculated p-value, hypergeometric test < fisher's exact test < binomial test
#'
#' @return test
#' 
#' @importFrom magrittr %>%
#' @importFrom dplyr select filter arrange distinct mutate rename pull summarise group_by left_join inner_join cross_join
#' @importFrom tidyr separate_rows
#' @export
#'
#' @examples
#' name <- c("C15973","C16254","MDH1")
#' result <- ePEAlyser(name,out="Extended",p_cutoff=0.05,noverlap_cutoff=0,test="hypergeo")
#' result
#' 
#' name <- "C15973"
#' result <- ePEAlyser(name,out="metabolite",p_cutoff=0.05,noverlap_cutoff=0,test="hypergeo")
#' result
#' 
#' name <- "MDH1"
#' result <- ePEAlyser(name,out="gene",p_cutoff=0.05,noverlap_cutoff=0,test="hypergeo")
#' result
#'
ePEAlyser <- function(name,
                            out = "Extended",
                            p_cutoff = 0.05,
                            noverlap_cutoff = 0,
                            test = c("hypergeo", "fisher", "binomial")) {
  if (out == "Extended") {
    PathwayExtendData <- PathwayExtendData %>%
      dplyr::select(.data$name, .data$kegg_pathwayname, .data$kegg_category, .data$type)
    result <- xgr(
      name,
      PathwayExtendData,
      p_cutoff = p_cutoff,
      noverlap_cutoff = noverlap_cutoff,
      test = test
    )
  } else if (out == "gene") {
    PathwayExtendData <- PathwayExtendData %>%
      dplyr::filter(.data$type == "gene") %>%
      dplyr::select(.data$name, .data$kegg_pathwayname, .data$kegg_category, .data$type)
    result <- xgr(
      name,
      PathwayExtendData,
      p_cutoff = p_cutoff,
      noverlap_cutoff = noverlap_cutoff,
      test = test
    )
  } else if (out == "metabolite") {
    PathwayExtendData <- PathwayExtendData %>%
      dplyr::filter(.data$type == "metabolite") %>%
      dplyr::select(.data$name, .data$kegg_pathwayname, .data$kegg_category, .data$type)
    result <- xgr(
      name,
      PathwayExtendData,
      p_cutoff = p_cutoff,
      noverlap_cutoff = noverlap_cutoff,
      test = test
    )
  }
  
  result_temp <- result$output
  
  kegg_a <- all_kegg_id %>%
    dplyr::filter(.data$source == "KEGG") %>%
    tidyr::separate_rows(.data$ENTRY) %>%
    dplyr::arrange(.data$ENTRY) %>%
    dplyr::distinct(.data$ENTRY, .keep_all = TRUE)
  
  result_final <- result_temp %>%
    dplyr::mutate(members_Overlap_keggid = .data$members_Overlap) %>%
    dplyr::mutate(members_Anno_keggid = .data$members_Anno) %>%
    tidyr::separate_rows(.data$members_Overlap, sep = ", ") %>%
    dplyr::left_join(kegg_a, by = c("members_Overlap" = "ENTRY")) %>%
    dplyr::mutate(NAME = ifelse(is.na(.data$NAME), .data$members_Overlap, .data$NAME)) %>%
    dplyr::select(-.data$source) %>%
    dplyr::group_by(
      .data$name,
      .data$nAnno,
      .data$nOverlap,
      .data$fc,
      .data$zscore,
      .data$pvalue,
      .data$adjp,
      .data$or,
      .data$CIl,
      .data$CIu,
      .data$distance,
      .data$namespace,
      .data$members_Anno,
      .data$members_Overlap_keggid,
      .data$members_Anno_keggid
    ) %>%
    dplyr::summarise(members_Overlap = paste(.data$NAME, collapse = ", ")) %>%
    tidyr::separate_rows(.data$members_Anno, sep = ", ") %>%
    dplyr::left_join(kegg_a, by = c("members_Anno" = "ENTRY")) %>%
    dplyr::mutate(NAME = ifelse(is.na(.data$NAME), .data$members_Anno, .data$NAME)) %>%
    dplyr::select(-.data$source) %>%
    dplyr::group_by(
      .data$name,
      .data$nAnno,
      .data$nOverlap,
      .data$fc,
      .data$zscore,
      .data$pvalue,
      .data$adjp,
      .data$or,
      .data$CIl,
      .data$CIu,
      .data$distance,
      .data$namespace,
      .data$members_Overlap,
      .data$members_Overlap_keggid,
      .data$members_Anno_keggid
    ) %>%
    dplyr::summarise(members_Anno = paste(.data$NAME, collapse = ", "))
  
  result$output <- result_final
  
  kegg_pathway_uniq <- PathwayExtendData %>%
    dplyr::select(.data$kegg_pathwayname, .data$kegg_category) %>%
    dplyr::rename("PATHWAY" = "kegg_pathwayname") %>%
    dplyr::rename("pathway_type" = "kegg_category") %>%
    unique()
  
  result_1 <- result$output %>%
    dplyr::filter(.data$pvalue < p_cutoff) %>%
    dplyr::left_join(kegg_pathway_uniq, by = c("name" = "PATHWAY")) %>%
    dplyr::arrange(.data$pvalue)
  
  pathway_hh <- unique(result_1$pathway_type)
  
  result_1 <- result_1 %>%
    dplyr::arrange(match(.data$pathway_type, pathway_hh))
  
  result_1$name <- factor(result_1$name, levels = rev(result_1$name))
  result_1$pathway_type <- factor(result_1$pathway_type,
                                  levels = unique(kegg_pathway_uniq$pathway_type))
  
  colp <- c("Amino acid metabolism" ="#1B9E77",
            "Carbohydrate metabolism"="#D95F02",
            "Glycan biosynthesis and metabolism"="#1F78B4",
            "Metabolism of cofactors and vitamins"="#7570B3",
            "Metabolism of terpenoids and polyketides"="#BC80BD",
            "Metabolism of other amino acids"="#8DD3C7",
            "Energy metabolism"="#E7298A",
            "Lipid metabolism"="#66A61E",
            "Nucleotide metabolism"="#E6AB02",
            "Biosynthesis of other secondary metabolites"="#A6761D",
            "Xenobiotics biodegradation and metabolism"="#666666")
  
  p1 <- ggplot(result_1, aes(.data$name, -log10(.data$pvalue))) +
    geom_bar(stat = "identity", aes(fill = .data$pathway_type)) +
    scale_fill_manual(
      values = colp,
      name = "Pathway Category",
      breaks = unique(kegg_pathway_uniq$pathway_type)
    ) +
    coord_flip() +
    theme_bw() +
    labs(x = NULL)
  result$p_barplot <- p1
  return(result)
}
