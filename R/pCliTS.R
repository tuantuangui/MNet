#' The clinical's time series analysis
#'
#' @param clinical the clinical marker of different time, and need included "time","group",maker;
#' "high"and "low" are alternative.
#'
#' @return Figure
#' @export
#'
#' @examples
#' time_series_ALT <- pCliTS(clinical_index)
#'
pCliTS <- function(clinical,marker) {
  if (!"low" %in% names(clinical)) {
    clinical$low <- NULL
  }else if (!"high" %in% names(clinical)) {
    clinical$high <- NULL
  }

  group <- time <- NULL
  marker <- names(clinical)[3]
  name_raw <- names(clinical)[which(names(clinical)==marker)]
  names(clinical)[which(names(clinical)==marker)] <- "marker"
  p <- ggplot2::ggplot(clinical,ggplot2::aes(time, marker)) +
    ggplot2::geom_smooth(ggplot2::aes(group=group,fill=group,color=group),method = "loess",
                se = TRUE)+
    ggplot2::theme_classic()+
    ggplot2::labs(y=paste0("the value of ",name_raw))+
    ggplot2::geom_hline(yintercept=c(unique(clinical$low)), linetype = 'dashed',color="blue")+
    ggplot2::geom_hline(yintercept=c(unique(clinical$high)), linetype = 'dashed',color="red")
  return(p)
}

