#' the limma analysis for metabolism or transcriptome
#'
#' @param dat the data to be analyzed, the column is the sample name, and row is the gene name or compound name
#' @param group the data's group
#'
#' @return test
#' @export
#'
#' @examples
#' result <- mlimma(mydata,group)
mlimma <- function(dat,group) {

  meta.data <- data.frame(Sample = colnames(dat))
  meta.data$patient <- meta.data$Sample
  meta.data$Type <- group
  
  ############### Limma fpkm : coding genes
  pdata.gene <- meta.data
  pdata.gene$contrast <- pdata.gene$Type
  design <- stats::model.matrix(~ 0 + as.factor(contrast), data = pdata.gene)
  colnames(design) <- stringr::str_replace_all(colnames(design), stringr::fixed("as.factor(contrast)"), "")
  fit <- limma::lmFit(dat, design)
  contrast <- limma::makeContrasts(P_N = tumor - normal, levels = design)
  fits <- limma::contrasts.fit(fit, contrast)
  ebFit <- limma::eBayes(fits)
  deg_sig_list <- limma::topTable(ebFit, coef = 1, adjust.method = 'fdr', number = Inf)
  deg <- deg_sig_list[which(!is.na(deg_sig_list$adj.P.Val)), ]
  deg$logP <- -log10(deg$adj.P.Val)
  
  deg$name <- rownames(deg)
  return(deg)

}
