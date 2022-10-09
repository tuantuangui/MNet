
#' Plot the PCA figure
#'
#' @param mydata the data needed to pca, the raw is the metabolites, and the column is the sample
#' @param group the group
#'
#' @return test
#' @export
#'
#' @examples
#' result <- pPCA(mydata,group)
#' result$p1
#' result$p2
#' result$p3
pPCA <- function(mydata,group) {

  PC1 <- PC2 <- label <- NULL
  filter_out <- c()
  for (i in seq(1,nrow(mydata))) {
    nn=unique(as.numeric(mydata[i,]))
    if (length(nn)==1) {
      filter_out <- c(filter_out,rownames(mydata)[i])
    }
  }

  if (length(filter_out)>0) {
    mydata <- mydata[-which(rownames(mydata) %in% filter_out),]
  }

  pca <- stats::prcomp(t(mydata), center = TRUE, scale. = TRUE)
  variance = pca$sdev^2/sum(pca$sdev^2)
  pca.data = data.frame(pca$x,group=group,label=rownames(pca$x))

  p1 <- ggplot2::ggplot(pca.data,ggplot2::aes(PC1,PC2,color=group))+
    ggplot2::geom_point()+
    ggplot2::theme_bw()+
    ggplot2::theme(panel.grid.major = ggplot2::element_blank(),panel.grid.minor = ggplot2::element_blank())+
    ggplot2::labs(x=paste0("PC1 (",signif(variance[1]*100,3),"%)"),
                  y=paste0("PC2 (",signif(variance[2]*100,3),"%)"))

  p2 <- ggplot2::ggplot(pca.data,ggplot2::aes(PC1,PC2,color=group))+
    ggplot2::geom_point()+
    ggplot2::stat_ellipse( linetype = 2, size = 0.5)+
    ggplot2::theme_bw()+
    ggplot2::theme(panel.grid.major = ggplot2::element_blank(),panel.grid.minor = ggplot2::element_blank())+
    ggplot2::labs(x=paste0("PC1 (",signif(variance[1]*100,3),"%)"),
         y=paste0("PC2 (",signif(variance[2]*100,3),"%)"))

  p3 <- ggplot2::ggplot(pca.data,ggplot2::aes(PC1,PC2,color=group))+
    ggplot2::geom_point()+
    ggplot2::stat_ellipse( linetype = 2, size = 0.5)+
    ggplot2::geom_text(ggplot2::aes(label=label),size=3)+
    #scale_color_manual(values=c("#000000","red"))+
    ggplot2::theme_bw()+
    ggplot2::theme(panel.grid.major = ggplot2::element_blank(),panel.grid.minor = ggplot2::element_blank())+
    ggplot2::labs(x=paste0("PC1 (",signif(variance[1]*100,3),"%)"),
         y=paste0("PC2 (",signif(variance[2]*100,3),"%)"))

  result <- list(p1=p1,p2=p2,p3=p3)
  return(result)
}

