PathwayAnalysis1 <- function(metabolite_name) {

  aa_kegg <- MNet::name2keggid(metabolite_name)

  result <- aa_kegg %>%
    dplyr::filter(!is.na(kegg_id)) %>%
    tidyr::separate_rows(kegg_id)

  result_1 <- PathwayAnalysis(result$kegg_id,out="metabolite")

  result_temp <- result_1$output

  kegg_a <- all_kegg_id %>%
    dplyr::filter(source=="KEGG") %>%
    tidyr::separate_rows(ENTRY) %>%
    dplyr::arrange(ENTRY) %>%
    dplyr::distinct(ENTRY,.keep_all = TRUE)

  result_final <- result_temp %>%
    dplyr::rename("pathwayname"="name") %>%
    dplyr::mutate(members_Overlap_keggid=members_Overlap) %>%
    dplyr::mutate(members_Anno_keggid=members_Anno) %>%
    tidyr::separate_rows(members_Overlap,sep=", ") %>%
    dplyr::left_join(result,by=c("members_Overlap"="kegg_id")) %>%
    dplyr::group_by(pathwayname,nAnno,nOverlap,fc,zscore,pvalue,adjp,or,CIl,CIu,distance,namespace,members_Anno,members_Overlap_keggid,members_Anno_keggid) %>%
    dplyr::summarise(members_Overlap=paste(name,collapse=", ")) %>%
    tidyr::separate_rows(members_Anno,sep=", ") %>%
    dplyr::left_join(kegg_a,by=c("members_Anno"="ENTRY")) %>%
    dplyr::select(-source) %>%
    dplyr::group_by(pathwayname,nAnno,nOverlap,fc,zscore,pvalue,adjp,or,CIl,CIu,distance,namespace,members_Overlap,members_Overlap_keggid,members_Anno_keggid) %>%
    dplyr::summarise(members_Anno=paste(NAME,collapse=", "))
  return(result_final)

}
