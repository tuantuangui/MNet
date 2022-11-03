
#' The correlation plot of clinical and metabolite using mantel test
#'
#' @param clinical_data the clinical data that row is the sample, and the column is the clinical biomarker
#' @param metabolite_data the metabolite data that row is the sample, and the column is the metabolites biomarker
#'
#' @return test
#' @export
#'
#' @examples
#' mydata1 <- t(mydata)
#' clinical_data <- as.data.frame(t(clinical))
#' metabolite_data <- as.data.frame(mydata1)
#' p <- pCorCliMetMantel(clinical_data,metabolite_data)
pCorCliMetMantel <- function(clinical_data,metabolite_data) {

  r <- `p.value` <- NULL

  tt <- as.list(seq(1,ncol(clinical_data)))

  for (i in seq(1,length(tt))){
    names(tt)[i]=names(clinical_data)[i]
  }
  mantel <- ggcor::mantel_test(clinical_data, metabolite_data,
                               spec.select = tt) %>%
    dplyr::mutate(r = cut(r, breaks = c(-Inf, -0.5,-0.25,0,0.25, 0.5, Inf),
                   labels = c("r<-0.5","-0.5<=r<-0.25","-0.25<=r<0","0<=r<0.25", "0.25<=r<0.5", "r>=0.5"),
                   right = FALSE),
           p.value = cut(p.value, breaks = c(-Inf, 0.001, 0.01, 0.05, Inf),
                         labels = c("<0.001", "0.001-0.01", "0.01-0.05", ">=0.05"),
                         right = FALSE)) %>%
    dplyr::filter(! r %in% c("-0.25<=r<0","0<=r<0.25")) %>%
    dplyr::mutate(r_value =ifelse(r=="r<-0.5","#0000FF",
                                  ifelse(r=="-0.5<=r<-0.25","#6666FF",
                                         ifelse(r=="0.25<=r<0.5","#FF6565","#FF0000"))))

  p1 <- ggcor::quickcor(metabolite_data,cluster = TRUE,cor.test=TRUE,type = "upper") +
    ggcor::geom_square(inherit.aes = TRUE) +
    ggcor::anno_link(mantel, mapping = ggplot2::aes(color = r, size = p.value),label.size =8)+
    #  scale_color_gradient2(midpoint = 0, low = "#446596", mid = "white",high = "#E55154")+
    ggplot2::scale_color_manual(values = c(unique(mantel$r_value))) +
    ggplot2::scale_size_manual(values = c(2.5,2,1.25,1))+  #线段size
    ggplot2::scale_fill_gradient2(midpoint = 0, low = "#446596", mid = "white",high = "#E55154", space = "Lab" )+ #热图颜色
    ggplot2::theme(axis.text.x = ggplot2::element_text(size=5),axis.text.y = ggplot2::element_text(size=5))

  p2 <- p1+ggplot2::guides(size=ggplot2::guide_legend(direction = "vertical",title="Mantel's r",override.aes=list(colour="grey35"),order=2),
                  colour=ggplot2::guide_legend(direction = "vertical",title="Mantel's p",override.aes = list(size=3),order=1),
                  fill=ggplot2::guide_colorbar(direction = "vertical",title="Pearson's r", order=3))
  return(p2)
}
