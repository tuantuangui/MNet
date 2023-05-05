
#' Change the compound name to kegg id
#'
#' Change the compound name to kegg id
#'
#' @param compound_name the compound name needed to change
#' @return test
#' @export
#'
#' @examples
#' compound_name <- c("2-Hydroxybutyric acid","1-Methyladenosine","tt","2-Aminooctanoic acid")
#' name2keggid(compound_name)
#'
name2keggid <- function(compound_name) {
  NAME <- name <- KEGG_ENTRY <- Compound_ENTRY <- Synonyms_ENTRY <- kegg_id <- NULL
  kegg <- all_kegg_id %>%
    dplyr::filter(source=="KEGG") %>%
    dplyr::select(-source) %>%
    dplyr::mutate(name_new=toupper(NAME))

  compound <- all_kegg_id %>%
    dplyr::filter(source=="compound")  %>%
    dplyr::select(-source) %>%
    dplyr::mutate(name_new=toupper(NAME))

  synonyms <- all_kegg_id %>%
    dplyr::filter(source=="synonyms")  %>%
    dplyr::select(-source) %>%
    dplyr::mutate(name_new=toupper(NAME))

  all_metabolites <- data.frame(name=compound_name) %>%
    as.data.frame() %>%
    dplyr::mutate(name_new=toupper(name)) %>%
    dplyr::left_join(kegg,by="name_new") %>%
    dplyr::rename(KEGG_ENTRY=ENTRY) %>%
    dplyr::left_join(compound,by="name_new") %>%
    dplyr::rename(Compound_ENTRY=ENTRY) %>%
    dplyr::left_join(synonyms,by="name_new") %>%
    dplyr::rename(Synonyms_ENTRY=ENTRY) %>%
    dplyr::select(-name_new,-NAME.x,-NAME.y,-NAME) %>%
    dplyr::mutate(kegg_id=ifelse(!is.na(KEGG_ENTRY),KEGG_ENTRY,
                                 ifelse(!is.na(Compound_ENTRY),Compound_ENTRY,Synonyms_ENTRY))) %>%
    dplyr::select(-KEGG_ENTRY,-Compound_ENTRY,-Synonyms_ENTRY)

  #含有kegg id的对应关系
  name_keggid <- all_metabolites %>%
    dplyr::filter(!is.na(kegg_id))

  #提取出没有kegg的compound name
  name_na <- all_metabolites %>%
    dplyr::filter(is.na(kegg_id)) %>%
    dplyr::pull(name)

  if (length(name_na)==0) {
    result <- name_keggid
  } else {
    #对这些compound name 转化为refmet name
    name_na_2refmet <- name2refmet(name_na) %>%
      dplyr::select(`Input name`,refmet_name) %>%
      dplyr::rename(name=`Input name`)

    ##对refmet转化为keggid
    refmet_keggid <- data.frame(name=name_na_2refmet$refmet_name) %>%
      as.data.frame() %>%
      dplyr::mutate(name_new=toupper(name)) %>%
      dplyr::left_join(kegg,by="name_new") %>%
      dplyr::rename(KEGG_ENTRY=ENTRY) %>%
      dplyr::left_join(compound,by="name_new") %>%
      dplyr::rename(Compound_ENTRY=ENTRY) %>%
      dplyr::left_join(synonyms,by="name_new") %>%
      dplyr::rename(Synonyms_ENTRY=ENTRY) %>%
      dplyr::select(-name_new,-NAME.x,-NAME.y,-NAME) %>%
      dplyr::mutate(kegg_id=ifelse(!is.na(KEGG_ENTRY),KEGG_ENTRY,
                                   ifelse(!is.na(Compound_ENTRY),Compound_ENTRY,Synonyms_ENTRY))) %>%
      dplyr::select(-KEGG_ENTRY,-Compound_ENTRY,-Synonyms_ENTRY) %>%
      dplyr::rename(refmet_name=name) %>%
      dplyr::left_join(name_na_2refmet,by="refmet_name") %>%
      dplyr::select(name,kegg_id)

    #print("jj")
    result <- rbind(name_keggid,refmet_keggid)
  }
  return(result)

}
