#' The time series analysis
#'
#' @param mydata the data that needed to be ranked by the time
#' @param out_dir the result's directory
#' @param range the metabolites's class's range,default is from 4 to 12
#'
#' @return test
#' @export
#'
#' @examples
#' TSMfuzz(mydata,out_dir="./",range=c(4,12))
TSMfuzz <- function(mydata,out_dir="time_series_mfuzz/",range=c(4,12)) {
  
  library(dplyr)
  require(Biobase)
  require(e1071)
  dir.create(out_dir,recursive = TRUE)

  mydata <- mydata %>%
    as.matrix()

  eset <- methods::new("ExpressionSet",exprs = mydata)

  tmp <- Mfuzz::filter.std(eset,min.std=0)
  ## 标准化
  gene.s <- Mfuzz::standardise(tmp)

  for (i in seq(range[1],range[2])) {
    ## 聚类个数
    c <- i
    ## 计算最佳的m值
    m <- Mfuzz::mestimate(gene.s)
    ## 聚类
    cl <- Mfuzz::mfuzz(gene.s, c = c, m = m)
    ## 查看每个聚类群中各自包含的代谢物数量
    cl$size
    ## 查看每类代谢物ID
    cl$cluster[cl$cluster == 1]

    grDevices::pdf(paste0(out_dir,"/mfuzz_",i,".pdf"),width=25,height=8)
    if (i < 6) {
      p1 <- Mfuzz::mfuzz.plot2(gene.s,cl,new.window = FALSE,mfrow=c(1,i),x11=FALSE,col="red",Xwidth=2,Xheight=2,ylab="value changes",
        colo="fancy",centre.col="black",centre=TRUE)

    }else if (i >5 && i<11) {
      p1 <- Mfuzz::mfuzz.plot2(gene.s,cl,new.window = FALSE,mfrow=c(2,5),x11=FALSE,col="red",Xwidth=2,Xheight=2,ylab="value changes",
          colo="fancy",centre.col="black",centre=TRUE)
    }else if (i >10 && i <16) {
      p1 <- Mfuzz::mfuzz.plot2(gene.s,cl,new.window = FALSE,mfrow=c(3,5),x11=FALSE,col="red",Xwidth=2,Xheight=2,ylab="value changes",
          colo="fancy",centre.col="black",centre=TRUE)
    }else if (i>15) {
      p1 <- Mfuzz::mfuzz.plot2(gene.s,cl,new.window = FALSE,mfrow=c(4,5),x11=FALSE,col="red",Xwidth=2,Xheight=2,ylab="value changes",
          colo="fancy",centre.col="black",centre=TRUE)
    }
    base::print(p1)
    grDevices::dev.off()

    metabolites_cluster <- cl$cluster
    metabolites_cluster_result <- cbind(mydata[names(metabolites_cluster),],metabolites_cluster)
    utils::write.table(metabolites_cluster_result,paste0(out_dir,"/metabolites_cluster_",i,".txt"),quote=FALSE,sep="\t")


    data_standard <- gene.s@assayData$exprs
    data_standard_cluster <- cbind(data_standard[names(metabolites_cluster), ], metabolites_cluster)
    #head(data_standard_cluster)
    utils::write.table(data_standard_cluster, paste0(out_dir,"/data_standard_cluster_",i,".txt"), sep = '\t',quote = FALSE)
  }
}

