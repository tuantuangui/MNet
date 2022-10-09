
#' Plot the correlation of clinical or gene expression data with metabolites data
#'
#' @param other_data all the clincial data, or the gene expression data
#' @param metabolite_data all the metabolite data,the metabolite's sample order needed to be same with clinical data or the gene expression data
#' @param other_marker the filtered clinical marker, or the gene expression marker
#' @param metabolite_marker the filtered metabolite marker
#' @param method the correlation method
#'
#' @return test
#' @export
#'
#' @examples
#' result <- pCorCliMet(clinical,mydata,"CRP","1-Methyladenosine")
pCorCliMet <- function(other_data,metabolite_data,other_marker,metabolite_marker,method="kendall") {
    metabolite_data_filter <- metabolite_data[which(rownames(metabolite_data)==metabolite_marker),]
    other_data_filter <- other_data[which(rownames(other_data)==other_marker),]

    dat <- as.data.frame(cbind(as.numeric(metabolite_data_filter),
                               as.numeric(other_data_filter)))
    colnames(dat) <- c("metabolite","clinical")

    #if (identical(unique(dat$metabolite),unique(dat$clinical))) {
    if (length(unique(dat$metabolite))>1 && length(unique(dat$clinical))>1) {
        cor_temp <- stats::cor.test(dat$metabolite,dat$clinical,method=method)
        cor_p <- cor_temp$p.value
        cor_cor <- cor_temp$estimate
    }else {
        cor_p <- 1
        cor_cor <- 0
    }
 
    cor_result <- data.frame(metabolite=metabolite_marker,other_marker=other_marker,cor=cor_cor,p=cor_p)

    p <- ggpubr::ggscatter(dat, x = "metabolite", y = "clinical",
                           add = "reg.line", conf.int = TRUE,
                           cor.coef = TRUE, cor.method = method,
                           xlab =paste0("the value of ",metabolite_marker), ylab = paste0("the value of ",other_marker))
    result <- list(cor_result=cor_result,p=p)
    return(result)
}
