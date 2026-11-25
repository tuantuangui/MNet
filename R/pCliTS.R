#' @title The clinical's time series analysis
#'
#' @param clinical A data frame with `time`, `group`, and at least one numeric clinical marker. Optional `low` and `high` columns add reference lines.
#' @param marker Marker column name. Defaults to the first column other than `time`, `group`, `low`, and `high`.
#'
#' @return A ggplot time-series figure
#'
#' @import ggplot2
#' @export
#'
#' @examples
#' time_series_ALT <- pCliTS(clinical_index, "ALT")
#' time_series_ALT
#'
pCliTS <- function(clinical, marker = NULL) {
  if (!is.data.frame(clinical)) {
    stop("`clinical` must be a data frame.", call. = FALSE)
  }
  if (!all(c("time", "group") %in% names(clinical))) {
    stop("`clinical` must contain columns named 'time' and 'group'.", call. = FALSE)
  }

  candidates <- setdiff(names(clinical), c("time", "group", "low", "high"))
  if (is.null(marker)) {
    if (!length(candidates)) {
      stop("`clinical` must contain at least one clinical marker column.", call. = FALSE)
    }
    marker <- candidates[1]
  }
  if (!is.character(marker) || length(marker) != 1L || is.na(marker) ||
      !marker %in% names(clinical) || marker %in% c("time", "group", "low", "high")) {
    stop("`marker` must name a clinical marker column in `clinical`.", call. = FALSE)
  }
  if (!is.numeric(clinical$time) || anyNA(clinical$time) ||
      any(!is.finite(clinical$time)) || length(unique(clinical$time)) < 2L) {
    stop("`time` must contain at least two distinct finite numeric values.", call. = FALSE)
  }
  if (anyNA(clinical$group) || !is.numeric(clinical[[marker]]) ||
      anyNA(clinical[[marker]]) || any(!is.finite(clinical[[marker]]))) {
    stop("`group` must be complete and the selected marker must contain finite numeric values.", call. = FALSE)
  }

  name_raw <- marker
  names(clinical)[names(clinical) == marker] <- "marker"
  p <- ggplot2::ggplot(clinical, ggplot2::aes(time, marker)) +
    ggplot2::geom_smooth(
      ggplot2::aes(group = group, fill = group, color = group),
      method = "loess",
      se = TRUE
    ) +
    ggplot2::theme_classic() +
    ggplot2::labs(y = paste0("the value of ", name_raw))

  if ("low" %in% names(clinical) && is.numeric(clinical$low)) {
    low_values <- unique(clinical$low[is.finite(clinical$low)])
    if (length(low_values)) {
      p <- p + ggplot2::geom_hline(yintercept = low_values, linetype = "dashed", color = "blue")
    }
  }
  if ("high" %in% names(clinical) && is.numeric(clinical$high)) {
    high_values <- unique(clinical$high[is.finite(clinical$high)])
    if (length(high_values)) {
      p <- p + ggplot2::geom_hline(yintercept = high_values, linetype = "dashed", color = "red")
    }
  }
  p
}
