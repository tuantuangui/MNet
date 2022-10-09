#' get the gene and the enzyme in the pathway
#'
#' @param pathwayid the pathway kegg id
#'
#' @return test
#' @export
#'
#' @examples
#' result <- pathwayinfo("hsa00630")
pathwayinfo <- function(pathwayid) {

  GENE <- V2 <- tt <- A <- enzyme <- pathid <- pathname <- NULL

  infos=KEGGREST::keggGet(pathwayid)
  gene_info =matrix(infos[[1]]$GENE,ncol =2,byrow =T)

  pathwayname <- infos[[1]]$NAME

  gene_info_en <- gene_info %>%
    as.data.frame() %>%
    tidyr::separate(V2,sep=";",c("symbol","tt")) %>%
    tidyr::separate(tt,sep="EC:",c(NA,"A")) %>%
    tidyr::separate(A,sep="]","enzyme") %>%
    tidyr::separate_rows(enzyme,sep=" ") %>%
    dplyr::mutate(pathid=pathwayid) %>%
    dplyr::mutate(pathname=pathwayname) %>%
    dplyr::rename("geneid"="V1")

  compound_info <- infos[[1]]$COMPOUND %>%
    as.data.frame() %>%
    tibble::rownames_to_column(var="keggid") %>%
    dplyr::rename("compound_name"=".")

  result <- list(gene_info=gene_info_en,compound_info=compound_info)
  return(result)
}
