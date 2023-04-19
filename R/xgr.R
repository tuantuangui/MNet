#' Plot the figure using XGR
#'
#' @param metabolites_keggid the metabolites's keggid
#' @param database the database used
#' @param p_cutoff p_cutoff used to declare the significant terms. By default, it is set to 0.05
#' @param noverlap_cutoff noverlap_cutoff used to declare the number of overlap. By default, it is set to 0
#' @param test the test statistic used. It can be "fisher" for using fisher's exact test, "hypergeo" for using hypergeometric test, or "binomial" for using binomial test. Fisher's exact test is to test the independence between gene group (genes belonging to a group or not) and gene annotation (genes annotated by a term or not), and thus compare sampling to the left part of background (after sampling without replacement). Hypergeometric test is to sample at random (without replacement) from the background containing annotated and non-annotated genes, and thus compare sampling to background. Unlike hypergeometric test, binomial test is to sample at random (with replacement) from the background with the constant probability. In terms of the ease of finding the significance, they are in order: hypergeometric test > fisher's exact test > binomial test. In other words, in terms of the calculated p-value, hypergeometric test < fisher's exact test < binomial test
#'
#' @return test
#' @export
#' @import ggplot2
#' @examples
#' library(dplyr)
#' kegg_pathway_filter <- kegg_pathway %>%
#' dplyr::filter(!is.na(pathway_type)) %>%
#'   dplyr::select(PATHWAY,type)
#'
#' kegg_id_need <- c("C05984","C02494")
#' xgr_result <- xgr(kegg_id_need,kegg_pathway_filter,p_cutoff=1.1,noverlap_cutoff=0)
#' xgr_result$output
#' xgr_result$gp
xgr <- function(metabolites_keggid,database,p_cutoff=0.05,noverlap_cutoff=0,test = c("hypergeo","fisher","binomial")) {

  nOverlap <- NULL

  test <- match.arg(test)
  eTerm <- MNet::xEnricherYours(metabolites_keggid,database, min.overlap=0, test=test,size.range=c(1,2000))

  # output
  output <- eTerm %>%
    MNet::xEnrichViewer(details=TRUE,top_num=100) %>%
    dplyr::filter(nOverlap > noverlap_cutoff) %>%
    dplyr::filter(pvalue < p_cutoff) %>%
    tibble::as_tibble()

  # plot
#  gp <- XGR::xEnrichLadder(eTerm,top_num=nrow(output))

  dat <- output %>%
  tidyr::separate_rows(members_Overlap) %>%
  dplyr::left_join(database,by=c("members_Overlap"="name")) %>%
  dplyr::select(name,members_Overlap,type)

  Data1 <- data.frame(Var1=rep(unique(dat$members_Overlap),time=length(unique(dat$name))),
                      Var2=rep(unique(dat$name),each=length(unique(dat$members_Overlap))))

  p1 <- ggplot(dat,aes(x=members_Overlap,y=name))+
    geom_point(aes(color=type),size=10)+
    geom_tile(data=Data1,aes(x=Var1,y=Var2),fill=NA,color="black",size=0.3)+
    scale_y_discrete(position = "right")+
    scale_x_discrete(position="top")+
    theme(panel.background = element_rect(fill="white",color=NA),
          panel.grid = element_blank(),axis.ticks = element_blank(),
          legend.position = "none")+
    labs(x=NULL,y=NULL) 

  result <- list(gp=p1,output=output)
  class(result) <- "eLadder"
  return(result)
}
