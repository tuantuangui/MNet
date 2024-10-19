#' @title seek the metabolits' pathway
#'
#' @param name the metabolites' name
#'
#' @return test
#' 
#' @importFrom magrittr %>%
#' @importFrom dplyr filter pull distinct inner_join rename mutate select
#' @importFrom tidyr separate_rows separate
#' @importFrom tibble as_tibble
#' @export
#'
#' @examples
#' name <- c("2-Hydroxybutyric acid","1-Methyladenosine","tt")
#' result_all <- name2pathway(name)
#'
#' result <- result_all$name2pathway
#' pathway <- result_all$pathway
#' pathway
#' kegg_name <- result_all$kegg_name
#' kegg_name
#'
name2pathway <- function(name) {
  Kegg_id <- kegg_id <- Pathway_category <- pathway_type <- NAME <- ENTRY <- NULL

  name_kegg_temp <- name2keggid(name) %>%
    dplyr::distinct(Name, .keep_all = TRUE)
  
  name_kegg_print <- name_kegg_temp %>%
    tidyr::separate_rows(KEGG_id, sep = ";")
  
  name_kegg_correspondence <- name_kegg_temp %>%
    tidyr::separate_rows(KEGG_id, sep = ";") %>%
    dplyr::filter(!is.na(KEGG_id))
  
  kegg_id_need <- name_kegg_correspondence %>%
    dplyr::pull(KEGG_id)
  
  kegg_pathway_filter <- kegg_pathway %>%
    dplyr::filter(!is.na(pathway_type)) %>%
    dplyr::select(ENTRY, PATHWAY, pathway_type)
  
  name_pathway <- name_kegg_correspondence %>%
    dplyr::inner_join(kegg_pathway_filter, by = c("KEGG_id" = "ENTRY"))
  pathwayid <- pathway2pathwayid(name_pathway$PATHWAY)
  
  name_pathway <- name_pathway %>%
    dplyr::inner_join(pathwayid, by = "PATHWAY") %>%
    dplyr::rename("Pathway" = "PATHWAY") %>%
    dplyr::rename("Pathway_category" = "pathway_type") %>%
    dplyr::rename("Pathway_id" = "pathwayid") %>%
    tibble::as_tibble()
  
  db <- kegg_pathway_filter %>%
    dplyr::rename("name" = "ENTRY") %>%
    dplyr::mutate(type = "metabolite")
  xgr_result <- xgr(kegg_id_need,
                    db,
                    p_cutoff = 1.1,
                    noverlap_cutoff = 0)
  result <- xgr_result$output
  
  kegg2refmet <- function(keggid) {
    kegg_name <- kegg_pathway %>%
      tidyr::separate(NAME, sep = ";///", "name") %>%
      dplyr::select(ENTRY, name) %>%
      unique()
    keggid_split <- strsplit(keggid, split = ", ")[[1]]
    result_temp <- c()
    for (i in seq(1, length(keggid_split))) {
      if (keggid_split[i] %in% name_kegg_correspondence$kegg_id) {
        result_1 <- name_kegg_correspondence %>%
          dplyr::filter(kegg_id == keggid_split[i]) %>%
          dplyr::pull(name)
      } else {
        result_1 <- kegg_name %>%
          dplyr::filter(ENTRY == keggid_split[i]) %>%
          dplyr::pull(name)
      }
      result_temp <- c(result_temp, result_1)
    }
    result <- paste(result_temp, collapse = ";")
    return(result)
  }
  
  members_Overlap_name <- c()
  for (i in seq(1, length(result$members_Overlap))) {
    temp <- kegg2refmet(result$members_Overlap[i])
    members_Overlap_name <- c(members_Overlap_name, temp)
  }
  result$members_Overlap_name <- members_Overlap_name
  
  members_Anno_name <- c()
  for (i in seq(1, length(result$members_Anno))) {
    temp <- kegg2refmet(result$members_Anno[i])
    members_Anno_name <- c(members_Anno_name, temp)
  }
  result$members_Anno_name <- members_Anno_name
  
  result_print <- list(name2pathway = name_pathway,
                       pathway = result,
                       kegg_id = name_kegg_print)
  return(result_print)
  
}
