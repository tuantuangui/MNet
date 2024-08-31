#' the visualization of ESEA in a pathway
#'
#' @param pathway_name the pathway name for plot
#' @param Ranks_all the Named vector of compound-level and (or) gene-level stats. Names should be KEGG ID and(or) gene-level
#' @param out The pathway type for gene or metabolite,or extended pathway included genes and metabolites,default is "Extended",alternative is "metabolite" and "gene"
#' @param gseaParam GSEA parameter value, all compound-level and(or) gene-level stats are raised to the power of 'gseaParam' before calculation of GSEA enrichment scores.
#' @param minSize Minimal size of a compound and(or) gene set to test. All pathways below the threshold are excluded.
#' @param ticksSize width of vertical line corresponding to a compound or gene(default: 0.2)
#'
#' @return visualization for the pathway's ESEA
#' @export
#'
#' @examples
#' library(ggplot2)
#' library(dplyr)
#' result <- pESEA("Butanoate metabolism",sim.cpd.data,out="metabolite")
pESEA <- function(pathway_name, Ranks_all, out="Extended", gseaParam = 0.5, minSize=5, ticksSize = 0.2) {

  Ranks_all <- sort(Ranks_all)
 
  if (out=="Extended") {
    Pathways=Pathways_all
  } else if (out=="gene") {
    Pathways=Pathways_gene
  } else if (out=="metabolite") {
    Pathways=Pathways_metabolite
  }
  fgseaRes_all <- fgsea::fgsea(Pathways, Ranks_all,minSize = minSize,nPermSimple=20000,gseaParam=0.5)
  
  pval <- fgseaRes_all %>% 
    dplyr::filter(pathway == pathway_name) %>% 
    dplyr::pull(pval) %>%
    round(3)
  nes <- fgseaRes_all %>% 
    dplyr::filter(pathway == pathway_name) %>% 
    dplyr::pull(NES) %>%
    round(3)
  
  pathway <- Pathways[[pathway_name]]
  
  stats <- Ranks_all
  rnk <- rank(-stats)
  ord <- order(rnk)
  statsAdj <- stats[ord]
  statsAdj <- sign(statsAdj) * (abs(statsAdj)^gseaParam)
  statsAdj <- statsAdj/max(abs(statsAdj))
  pathway <- unname(as.vector(na.omit(match(pathway, names(statsAdj)))))
  pathway <- sort(pathway)
  gseaRes <- fgsea::calcGseaStat(statsAdj, selectedStats = pathway, 
                          returnAllExtremes = TRUE)
  bottoms <- gseaRes$bottoms
  tops <- gseaRes$tops
  n <- length(statsAdj)
  xs <- as.vector(rbind(pathway - 1, pathway))
  ys <- as.vector(rbind(bottoms, tops))
  toPlot <- data.frame(x = c(0, xs, n + 1), y = c(0, ys, 0))
  diff <- (max(tops) - min(bottoms))/8
  x = y = NULL
  g1 <- ggplot2::ggplot(toPlot, aes(x = x, y = y)) +
    ggplot2::geom_point(color = "green", size = 0.1) +  
    ggplot2::geom_hline(yintercept = 0, 
               colour = "gray") + geom_line(color = "green") +
    ggplot2::geom_line(color = "green") + theme_bw() + 
    ggplot2::theme(panel.grid.minor = ggplot2::element_blank(),
          axis.text.x=ggplot2::element_blank(),axis.ticks.x=ggplot2::element_blank()) +
    ggplot2::labs(x = NULL, y = "enrichment score",title=)+
    ggplot2::scale_x_continuous(expand = c(0, 0),limits = c(0,length(statsAdj)+1))+
    ggplot2::theme(plot.margin = unit(c(5,5,0,5), "mm"))
  
  g2 <- ggplot2::ggplot(toPlot, aes(x = x, y = y))+
    ggplot2::geom_segment(data = data.frame(x = pathway), 
                 mapping = aes(x = x, 
                               y = -1, xend = x, yend = 1),
                 size = ticksSize,color="red") +
    ggplot2::scale_x_continuous(expand = c(0, 0),limits = c(0,length(statsAdj)+1))+theme_bw()+
    ggplot2::theme(panel.grid = element_blank(),
          axis.text.x=element_blank(),axis.ticks.x=element_blank(),
          axis.text.y=element_blank(),axis.ticks.y=element_blank())+
    ggplot2::labs(x=NULL,y=NULL)+
    ggplot2::theme(plot.margin = unit(c(0,5,0,5), "mm"))
  
  dat <- data.frame(name=1:length(statsAdj),value=statsAdj)
  
  g3 <- ggplot2::ggplot(dat,aes(name,value))+
    ggplot2::geom_bar(stat="identity",fill="gray")+
    ggplot2::theme_bw()+
    ggplot2::theme(panel.grid = element_blank())+
    ggplot2::labs(x=NULL)+
    ggplot2::scale_x_continuous(expand = c(0, 0),limits=c(0,length(statsAdj)+1))+
    ggplot2::theme(plot.margin = unit(c(0,5,5,5), "mm"))
  
  # return(a=list(statsAdj=statsAdj,g1=g1,g2=g2,g3=g3))
  
  p1 <- cowplot::plot_grid(plotlist = list(g1,g2,g3),nrow=3,
                           rel_heights = c(1,0.2,0.5),scale=1,
                           align ="v",labels=paste0(pathway_name," pval=",pval,";NES=",nes),label_size = 8)
  return(p1)
}

  


