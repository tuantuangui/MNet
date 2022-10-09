#' Plot the volcano figure
#'
#' @param mydata the result of function "differential_metabolites",have column "name","fold_change",
#' "fdr_wilcox"
#' @param foldchange_threshold the fold change, default is 1.5,1/1.5
#'
#' @return test
#' @export
#'
#' @examples
#' result <- DM(mydata,group)
#' p <- pVolcano(result)

pVolcano <- function(mydata,foldchange_threshold=1.5) {
    library(dplyr)

  Condition <- name <- fold_change <- fdr_wilcox <- label <- NULL

  mydata$Condition = ifelse(mydata$fold_change>=foldchange_threshold & mydata$fdr_wilcox< 0.05,"up",
                            ifelse(mydata$fold_change<=1/foldchange_threshold & mydata$fdr_wilcox < 0.05,"down","normal"))

  mydata <- mydata %>%
    dplyr::mutate(label=ifelse(Condition=="normal","",name))

  p <- ggplot2::ggplot(mydata,ggplot2::aes(log2(fold_change),-log2(fdr_wilcox)))+
    ggplot2::geom_point(ggplot2::aes(color=Condition),size=2,alpha=0.7)+
    ggplot2::geom_vline(xintercept=c(-log2(foldchange_threshold),log2(foldchange_threshold)), linetype = 'dashed',color="gray")+
    ggplot2::geom_hline(yintercept = -log2(0.05),linetype='dashed',color="gray")+
    ggrepel::geom_text_repel(ggplot2::aes(label=label),size=1)+
    ggplot2::scale_color_manual(values=c("up"="red","normal"="gray","down"="blue"))+
    ggplot2::theme_bw()+
    ggplot2::theme(panel.grid.major = ggplot2::element_blank(),panel.grid.minor = ggplot2::element_blank())+
    ggplot2::labs(x="log2(Fold Change)",y="-log2(FDR)")
  return(p)
}


