#' Function to view enrichment results
#'
#' \code{xEnrichViewer} is supposed to view results of enrichment analysis.
#'
#' @param eTerm an object of class "eTerm"
#' @param top_num the number of the top terms (sorted according to 'sortBy' below) will be viewed
#' @param sortBy which statistic will be used for sorting. Use "p-adjust" for adjusted p values or "p-value" for nominal p values; legacy values "adjp", "fdr", and "pvalue" remain accepted. Other values are "zscore", "fc", "nAnno", "nOverlap", "or", and "none".
#' @param decreasing logical to indicate whether to sort in a decreasing order. If it is null, it would be true for "zscore", "nAnno" or "nOverlap"; otherwise it would be false
#' @param details logical to indicate whether the detailed information of gene sets (terms) is also viewed. By default, it sets to false for no inclusion
#' @return
#' a data frame with following components:
#' \itemize{
#'  \item{\code{id}: term ID; as rownames}
#'  \item{\code{name}: term name}
#'  \item{\code{nAnno}: number in members annotated by a term}
#'  \item{\code{nOverlap}: number in overlaps}
#'  \item{\code{fc}: enrichment fold changes}
#'  \item{\code{zscore}: enrichment z-score}
#'  \item{\code{p-value}: nominal p value}
#'  \item{\code{p-adjust}: adjusted p value (FDR) in the returned table; the internal enrichment result still stores this value as \code{adjp}}
#'  \item{\code{or}: a vector containing odds ratio}
#'  \item{\code{CIl}: a vector containing lower bound confidence interval for the odds ratio}
#'  \item{\code{CIu}: a vector containing upper bound confidence interval for the odds ratio}
#'  \item{\code{distance}: term distance or other information; optional, it is only appended when "details" is true}
#'  \item{\code{members_Overlap}: members (represented as Gene Symbols) in overlaps; optional, it is only appended when "details" is true}
#'  \item{\code{members_Anno}: members (represented as Gene Symbols) in annotations; optional, it is only appended when "details" is true}
#' }
#' @note none
#' @importFrom methods is
#' @export
#' @seealso \code{\link{xEnrichViewer}}
#' @include xEnrichViewer.r
#' @examples
#' RData.location <- "http://galahad.well.ox.ac.uk/bigdata"
#' \dontrun{
#' xEnrichViewer(eTerm)
#' }

xEnrichViewer <- function(eTerm,
                          top_num = 10,
                          sortBy = c("p-adjust",
                                     "p-value",
                                     "adjp",
                                     "fdr",
                                     "pvalue",
                                     "zscore",
                                     "fc",
                                     "nAnno",
                                     "nOverlap",
                                     "or",
                                     "none"),
                          decreasing = NULL,
                          details = FALSE)
{
  sortBy <- match.arg(sortBy)
  sortBy <- switch(sortBy,
                   `p-adjust` = "adjp",
                   `p-value` = "pvalue",
                   fdr = "adjp",
                   sortBy)
  
  if (is.null(eTerm)) {
    warning("There is no enrichment in the 'eTerm' object.", call. = FALSE)
    return(NULL)
  }
  
  if (methods::is(eTerm, "data.frame")) {
    warning("The function applies to a 'data.frame' object.", call. = FALSE)
    
    if (is.null(top_num)) {
      top_num <- nrow(eTerm)
    }
    tab <- eTerm
    
  } else if (methods::is(eTerm, "eTerm")) {
    if (is.null(top_num)) {
      top_num <- length(eTerm$term_info$id)
    }
    if (dim(eTerm$term_info)[1] == 1) {
      tab <- data.frame(
        name         = as.character(eTerm$term_info$name),
        nAnno        = as.numeric(sapply(eTerm$annotation, length)),
        nOverlap     = as.numeric(sapply(eTerm$overlap, length)),
        fc         	= as.numeric(eTerm$fc),
        zscore       = as.numeric(eTerm$zscore),
        pvalue       = as.numeric(eTerm$pvalue),
        adjp         = as.numeric(eTerm$adjp),
        or         	= as.numeric(eTerm$or),
        CIl         	= as.numeric(eTerm$CIl),
        CIu         	= as.numeric(eTerm$CIu),
        distance     = eTerm$term_info$distance,
        namespace    = eTerm$term_info$namespace,
        members_Overlap = sapply(eTerm$overlap, function(x)
          paste(sort(x), collapse = ', ')),
        members_Anno = sapply(eTerm$annotation, function(x)
          paste(sort(x), collapse = ', ')),
        stringsAsFactors = FALSE
      )
    } else{
      tab <- data.frame(
        name         = as.character(eTerm$term_info$name),
        nAnno        = as.numeric(sapply(eTerm$annotation, length)),
        nOverlap     = as.numeric(sapply(eTerm$overlap, length)),
        fc         	= as.numeric(eTerm$fc),
        zscore       = as.numeric(eTerm$zscore),
        pvalue       = as.numeric(eTerm$pvalue),
        adjp         = as.numeric(eTerm$adjp),
        or         	= as.numeric(eTerm$or),
        CIl         	= as.numeric(eTerm$CIl),
        CIu         	= as.numeric(eTerm$CIu),
        distance     = eTerm$term_info$distance,
        namespace    = eTerm$term_info$namespace,
        members_Overlap = sapply(eTerm$overlap, function(x)
          paste(sort(x), collapse = ', ')),
        members_Anno = sapply(eTerm$annotation, function(x)
          paste(sort(x), collapse = ', ')),
        stringsAsFactors = FALSE
      )
    }
    
    rownames(tab) <- eTerm$term_info$id
  }

  tab <- .mnet_standardize_p_columns(tab)

  available <- nrow(tab)
  if (is.null(top_num)) {
    top_num <- available
  }
  if (!is.numeric(top_num) || length(top_num) != 1L || is.na(top_num) ||
      !is.finite(top_num) || top_num < 0) {
    stop("`top_num` must be NULL or one non-negative finite number.", call. = FALSE)
  }
  top_num <- as.integer(min(top_num, available))
  
  if (details == TRUE) {
    res <- tab[, c(1:14)]
  } else{
    res <- tab[, c(1:10)]
  }
  
  if (is.null(decreasing)) {
    if (sortBy == "zscore" |
        sortBy == "nAnno" | sortBy == "nOverlap" | sortBy == "or") {
      decreasing <- TRUE
    } else{
      decreasing <- FALSE
    }
  }
  
  pvalue <- adjp <- zscore <- fc <- or <- nAnno <- nOverlap <- NULL
  
  switch(
    sortBy,
    fdr = {
      res <- res[order(res[["p-adjust"]], -res[["zscore"]])[seq_len(top_num)], , drop = FALSE]
    },
    adjp = {
      res <- res[order(res[["p-adjust"]], -res[["zscore"]])[seq_len(top_num)], , drop = FALSE]
    },
    pvalue = {
      res <- res[order(res[["p-value"]], -res[["zscore"]])[seq_len(top_num)], , drop = FALSE]
    },
    zscore = {
      res <- res[order(-res[["zscore"]], res[["p-adjust"]])[seq_len(top_num)], , drop = FALSE]
    },
    fc = {
      res <- res[order(-res[["fc"]], res[["p-adjust"]])[seq_len(top_num)], , drop = FALSE]
    },
    or = {
      res <- res[order(-res[["or"]], res[["p-adjust"]])[seq_len(top_num)], , drop = FALSE]
    },
    nAnno = {
      res <- res[order(-res[["nAnno"]], res[["p-adjust"]], -res[["zscore"]])[seq_len(top_num)], , drop = FALSE]
    },
    nOverlap = {
      res <- res[order(-res[["nOverlap"]], res[["p-adjust"]], -res[["zscore"]])[seq_len(top_num)], , drop = FALSE]
    },
    none = {
      res <- res[order(rownames(res), decreasing = decreasing)[seq_len(top_num)], , drop = FALSE]
    }
  )
  
  if (sortBy == 'none') {
    suppressWarnings(flag <- all(!is.na(as.numeric(rownames(
      res
    )))))
    if (flag) {
      res <- res[order(as.numeric(rownames(res)), decreasing = decreasing)[seq_len(top_num)], , drop = FALSE]
    }
  }
  
  res <- .mnet_standardize_p_columns(res)
  res
}
