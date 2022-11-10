
#' The correlation between metabolites and gene expression in a pathway
#'
#' @param metadata the metabolites data, the row is the metabolites, and the column is the sample
#' @param genedata the gene expression data, the row is the gene, and the column is the sample
#' @param pathwayid the interested pathway id
#'
#' @return test
#' @export
#'
#' @examples
#' library(dplyr)
#' metadata <- readRDS("/Users/guituantuan/Desktop/projects/RNA-seq/ALL/result_v0612/11_key_metabolites/metabolites_data_A.rds") %>%
#' as.data.frame()
#' metadata <- metadata[1:10,]
#' metadata[1,1] <- "Glutamic acid"
#'
#' result_keggid <- name2keggid(metadata$label) %>%
#'   tidyr::separate_rows(kegg_id,sep=";") %>%
#'   dplyr::filter(!is.na(kegg_id)) %>%
#'   dplyr::left_join(metadata,by=c("name"="label"))
#'
#' metadata <- result_keggid %>%
#'   dplyr::select(-name) %>%
#'   tibble::column_to_rownames(kegg_id)
#'
#' genedata <- readRDS("/Users/guituantuan/Desktop/projects/RNA-seq/ALL/result_v0612/11_key_metabolites/20220612_RNA_ALL_VST_coding_filter.rds") %>%
#'   as.data.frame() %>%
#'   tibble::column_to_rownames(gene_id)
#'
#' result <- MetaGeneCor(metadata,genedata,"hsa00630")
MetaGeneCor <- function(metadata,genedata,pathwayid) {

  symbol <- keggid <- NULL

  result <- pathwayinfo(pathwayid)
  gene_filter <- result$gene_info %>%
    dplyr::filter(symbol %in% rownames(genedata))

  metabolite_filter <- result$compound_info %>%
    dplyr::filter(keggid %in% rownames(metadata))

  cor_result <- data.frame()
  for (a in unique(metabolite_filter$keggid)) {
    for (b in unique(gene_filter$symbol)) {
      cor_result_temp <- pCorCliMet(genedata,metadata,b,a)

      cor_result_1 <- cor_result_temp$cor_result %>%
        dplyr::mutate(hsa=pathwayid) %>%
        dplyr::left_join(metabolite_filter,by=c("metabolite"="keggid")) %>%
        dplyr::left_join(gene_filter,by=c("other_marker"="symbol"))

      cor_result <- rbind(cor_result,cor_result_1)

    }
  }
  cor_result <- cor_result %>%
    dplyr::select(compound_name,enzyme,hsa,pathname,other_marker,geneid,metabolite,cor,p)
  return(cor_result)
}
