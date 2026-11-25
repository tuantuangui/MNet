#' @title Differential Metabolite analysis by limma
#'
#' @param object object A dataframe-like data object containing raw metabolite intensity values, with rows corresponding to metabolites, and the columns corresponding to the samples
#' @param group the data's group
#'
#' @return A dataframe with limma's statistics; p-value columns are named `p-value` and `p-adjust`
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
  object <- as.matrix(object)
  if (!is.numeric(object) || nrow(object) < 1L || ncol(object) < 2L ||
      is.null(colnames(object)) || anyDuplicated(colnames(object))) {
    stop("`object` must be a numeric matrix with named sample columns.", call. = FALSE)
  }
  if (length(group) != ncol(object) || anyNA(group)) {
    stop("`group` must contain one non-missing label for each sample column.", call. = FALSE)
  }
  group <- tolower(as.character(group))
  if (!setequal(unique(group), c("normal", "tumor"))) {
    stop("`group` must contain exactly the labels 'normal' and 'tumor'.", call. = FALSE)
  }
  meta.data <- data.frame(Sample = colnames(object))
  meta.data$patient <- meta.data$Sample
  meta.data$Type <- factor(group, levels = c("normal", "tumor"))
  
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
  names(deg_sig_list)[names(deg_sig_list) == "P.Value"] <- "p-value"
  names(deg_sig_list)[names(deg_sig_list) == "adj.P.Val"] <- "p-adjust"
  deg <- deg_sig_list[!is.na(deg_sig_list[["p-adjust"]]), , drop = FALSE]
  deg$logP <- -log10(deg[["p-adjust"]])
  
  deg$name <- rownames(deg)
  return(tibble::as_tibble(deg))
  
}
