.mnet_standardize_p_columns <- function(data) {
  if (!is.data.frame(data)) {
    stop("`data` must be a data frame.", call. = FALSE)
  }

  aliases <- list(
    "p-value" = c("pvalue", "pval"),
    "p-adjust" = c("padjust", "padj", "adjp", "adjpval", "adjpvalue", "fdr",
                   "adjustedp", "adjustedpval", "adjustedpvalue"),
    "p-value_t" = c("pvaluet", "pvalt"),
    "p-adjust_t" = c("padjustt", "padjt", "adjpt", "adjpvalt", "fdrt"),
    "p-value_wilcox" = c("pvaluewilcox", "pvalwilcox"),
    "p-adjust_wilcox" = c("padjustwilcox", "padjwilcox", "adjpwilcox",
                          "adjpvalwilcox", "fdrwilcox")
  )
  keys <- tolower(gsub("[^[:alnum:]]", "", names(data)))

  for (canonical in names(aliases)) {
    canonical_key <- tolower(gsub("[^[:alnum:]]", "", canonical))
    candidates <- which(keys %in% c(canonical_key, aliases[[canonical]]))
    if (!length(candidates)) next

    if (length(candidates) > 1L) {
      reference <- data[[candidates[1L]]]
      duplicates_match <- vapply(candidates[-1L], function(i) {
        identical(reference, data[[i]])
      }, logical(1))
      if (!all(duplicates_match)) {
        stop(sprintf(
          "Ambiguous columns for `%s`; found multiple columns with different values.",
          canonical
        ), call. = FALSE)
      }
      data <- data[, -candidates[-1L], drop = FALSE]
      keys <- keys[-candidates[-1L]]
      candidates <- candidates[1L]
    }

    names(data)[candidates] <- canonical
    keys[candidates] <- canonical_key
  }

  data
}
