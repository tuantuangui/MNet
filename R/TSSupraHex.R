#' The time series analysis using supraHex
#'
#' @param mydata the data that needed to be ranked by the time
#' @param newdata the data that use the model
#' @param out_dir the result's directory
#' @param rect.grid the
#'
#' @return test
#' @export
#'
#' @examples
#' library(dplyr)
#' TSSupraHex(mydata,out_dir="time_series_supraHex/")
TSSupraHex <- function(mydata,newdata=NULL,out_dir="time_series_supraHex/",rect.grid=c(1,5)) {
    dir.create(out_dir,recursive = TRUE)
    dat <- myscale(mydata)

    sMap <- supraHex::sPipeline(dat,shape="sheet",xdim=6,ydim=12)

    grDevices::pdf(paste0(out_dir,"/time_series_superhex.pdf"),width=14,height = 5)
    supraHex::visHexMulComp(sMap, colormap="darkblue-blue-white-red-darkred",rect.grid=rect.grid,
              title.xy = c(0.45, 1),newpage = FALSE)
    grDevices::dev.off()

    supraHex::sWriteData(sMap, dat, filename=paste0(out_dir,"/Output_time_superhex.txt"))
    sBase <- supraHex::sDmatCluster(sMap)

    grDevices::pdf(paste0(out_dir,"/time_superhex_model.pdf"),width=5,height = 5)
    supraHex::visDmatCluster(sMap, sBase,colormap = c("rainbow", "jet", "bwr", "gbr", "wyr", "br", "yr", "wb"),newpage = FALSE)
    grDevices::dev.off()

    supraHex::sWriteData(sMap, dat, sBase, filename=paste0(out_dir,"/Output_time_superhex_result.txt"))

    ## new data
    # newdata
    if (!is.null(newdata)) {
        sOverlay <- supraHex::sMapOverlay(sMap=sMap, data=dat, additional=newdata)

        ## the figure
        grDevices::pdf(paste0(out_dir,"/time_superhex_newdata.pdf"),width=5,height = 5)
        supraHex::visHexMulComp(sOverlay,rect.grid=rect.grid)
        grDevices::dev.off()
    }
}
