#' @title Differential Metabolite analysis by limma
#'
#' @param object object A dataframe-like data object containing raw metabolite intensity values, with rows corresponding to metabolites, and the columns corresponding to the samples
#' @param group the data's group
#'
#' @return A dataframe is same with limma's result
#' 
#' @importFrom stats model.matrix
#' @importFrom stringr str_replace_all fixed
#' @importFrom tibble as_tibble
#' @importFrom limma lmFit makeContrasts contrasts.fit eBayes topTable
#' @export
#'
#' @examples
#' result <- mlimma(meta_dat, group)
#' result
#'
mlimma <- function(object, group) {
  meta.data <- data.frame(Sample = colnames(object))
  meta.data$patient <- meta.data$Sample
  meta.data$Type <- group
  
  ############### Limma fpkm : coding genes
  pdata.gene <- meta.data
  pdata.gene$contrast <- pdata.gene$Type
  design <- stats::model.matrix( ~ 0 + as.factor(contrast), data = pdata.gene)
  colnames(design) <- stringr::str_replace_all(colnames(design),
                                               stringr::fixed("as.factor(contrast)"),
                                               "")
  fit <- limma::lmFit(object, design)
  contrast <- limma::makeContrasts(P_N = tumor - normal, levels = design)
  fits <- limma::contrasts.fit(fit, contrast)
  ebFit <- limma::eBayes(fits)
  deg_sig_list <- limma::topTable(ebFit,
                                  coef = 1,
                                  adjust.method = 'fdr',
                                  number = Inf)
  deg <- deg_sig_list[which(!is.na(deg_sig_list$adj.P.Val)), ]
  deg$logP <- -log10(deg$adj.P.Val)
  
  deg$name <- rownames(deg)
  return(tibble::as_tibble(deg))
  
}
