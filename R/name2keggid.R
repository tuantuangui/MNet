#' @title Change the compound name to kegg id
#'
#' @description Change the compound name to kegg id
#'
#' @param compound_name the compound name needed to change
#' @return test
#' 
#' @importFrom magrittr %>%
#' @importFrom dplyr filter select mutate left_join rename pull
#' @export
#'
#' @examples
#' compound_name <- c("2-Hydroxybutyric acid","1-Methyladenosine","tt","2-Aminooctanoic acid")
#' name2keggid(compound_name)
#'
name2keggid <- function(compound_name) {
  kegg <- all_kegg_id %>%
    dplyr::filter(.data$source == "KEGG") %>%
    dplyr::select(-.data$source) %>%
    dplyr::mutate(name_new = toupper(.data$NAME))
  
  compound <- all_kegg_id %>%
    dplyr::filter(.data$source == "compound")  %>%
    dplyr::select(-.data$source) %>%
    dplyr::mutate(name_new = toupper(.data$NAME))
  
  synonyms <- all_kegg_id %>%
    dplyr::filter(.data$source == "synonyms")  %>%
    dplyr::select(-.data$source) %>%
    dplyr::mutate(name_new = toupper(.data$NAME))
  
  all_metabolites <- data.frame(name = compound_name) %>%
    as.data.frame() %>%
    dplyr::mutate(name_new = toupper(.data$name)) %>%
    dplyr::left_join(kegg, by = "name_new") %>%
    dplyr::rename(KEGG_ENTRY = .data$ENTRY) %>%
    dplyr::left_join(compound, by = "name_new") %>%
    dplyr::rename(Compound_ENTRY = .data$ENTRY) %>%
    dplyr::left_join(synonyms, by = "name_new") %>%
    dplyr::rename(Synonyms_ENTRY = .data$ENTRY) %>%
    dplyr::select(-.data$name_new, -.data$NAME.x, -.data$NAME.y, -.data$NAME) %>%
    dplyr::mutate(kegg_id = ifelse(
      !is.na(.data$KEGG_ENTRY),
      .data$KEGG_ENTRY,
      ifelse(!is.na(.data$Compound_ENTRY), .data$Compound_ENTRY, .data$Synonyms_ENTRY)
    )) %>%
    dplyr::select(-.data$KEGG_ENTRY, -.data$Compound_ENTRY, -.data$Synonyms_ENTRY)
  
  name_keggid <- all_metabolites %>%
    dplyr::filter(!is.na(.data$kegg_id))
  
  name_na <- all_metabolites %>%
    dplyr::filter(is.na(.data$kegg_id)) %>%
    dplyr::pull(.data$name)
  
  if (length(name_na) == 0) {
    result <- name_keggid
  } else {
    name_na_2refmet <- name2refmet(name_na) %>%
      dplyr::select(.data$Input_name, .data$Refmet_name) %>%
      dplyr::rename(name = .data$Input_name)
    
    refmet_keggid <- data.frame(name = name_na_2refmet$Refmet_name) %>%
      as.data.frame() %>%
      dplyr::mutate(name_new = toupper(.data$name)) %>%
      dplyr::left_join(kegg, by = "name_new") %>%
      dplyr::rename(KEGG_ENTRY = .data$ENTRY) %>%
      dplyr::left_join(compound, by = "name_new") %>%
      dplyr::rename(Compound_ENTRY = .data$ENTRY) %>%
      dplyr::left_join(synonyms, by = "name_new") %>%
      dplyr::rename(Synonyms_ENTRY = .data$ENTRY) %>%
      dplyr::select(-.data$name_new, -.data$NAME.x, -.data$NAME.y, -.data$NAME) %>%
      dplyr::mutate(kegg_id = ifelse(
        !is.na(.data$KEGG_ENTRY),
        .data$KEGG_ENTRY,
        ifelse(!is.na(.data$Compound_ENTRY), .data$Compound_ENTRY, .data$Synonyms_ENTRY)
      )) %>%
      dplyr::select(-.data$KEGG_ENTRY, -.data$Compound_ENTRY, -.data$Synonyms_ENTRY) %>%
      dplyr::rename(Refmet_name = .data$name) %>%
      dplyr::left_join(name_na_2refmet, by = "Refmet_name") %>%
      dplyr::select(.data$name, .data$kegg_id)
    
    result <- rbind(name_keggid, refmet_keggid)
  }
  
  result <- result %>%
    dplyr::rename("Name" = .data$name) %>%
    dplyr::rename("KEGG_id" = .data$kegg_id)
  
  return(result)
}
