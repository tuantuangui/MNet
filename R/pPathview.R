
#' the pathview of differential metabolites
#'
#' @param cpd.data character vector,the metabolites' value, log2(fold change)
#' @param gene.data default is NULL, the gene expression data, log2(fold change)
#' @param outdir the output directory
#'
#' @return test
#' @export
#'
#' @examples
#' kegg_id <- c("C02494","C03665","C01546","C05984","C14088","C00587")
#' value <- c(-0.3824620,0.1823628,-1.1681486,0.5164899,1.6449798,-0.7340652)
#' names(value) <- kegg_id
#' cpd.data <- value
#' pPathview(cpd.data,outdir="test")

pPathview <- function(cpd.data,gene.data=NULL,outdir="./") {

  utils::data("bods", package = "pathview")

  kegg_id <- names(cpd.data)
  pathway_id <- unique(keggid2pathway(kegg_id)$V2)

  for (pathway_id_1 in pathway_id) {
   if (is.null(gene.data)){
    pathview::pathview(gene.data=gene.data,
                     cpd.data=cpd.data,
                     pathway.id=pathway_id_1,
		     out.suffix="pathview.metabolite")
   }else {
    pathview::pathview(gene.data=gene.data,
                     cpd.data=cpd.data,
                     pathway.id=pathway_id_1,
                     out.suffix="pathview.gene.metabolite")
  }
  }
  dir.create(outdir,recursive =TRUE)
  filenames1 <- dir(getwd(), pattern = ".png", full.names = TRUE, ignore.case = TRUE)
  filesstrings::file.move(filenames1,outdir,overwrite = TRUE)

  filenames2 <- dir(getwd(), pattern = ".xml", full.names = TRUE, ignore.case = TRUE)
  filesstrings::file.move(filenames2,outdir,overwrite = TRUE)
}


