

p_pathway_graphite <- function(fexpr,classes,out_file_prefix,width=15,height=18) {

  ## Pathway Analysis
  kpaths <- graphite::pathways("hsapiens", "kegg")

  rpaths <- graphite::convertIdentifiers(kpaths, "SYMBOL")

#  head(edges(rpaths[[1]], "mixed"))

  filter_pathways <- function(pathways, expr, min_edge_num) {
    node_names <- rownames(expr)
    pred <- function(p) {
      ns <- graph::nodes(p, "mixed")
      if (length(ns) == 0) {
        return(FALSE)
      }
      frac <- length(grep("^KEGGCOMP:", ns)) / length(ns)
      if (frac < 0.3) {
        return(FALSE)
      }
      es <- igraph::edges(p, "mixed")
      mask <- (paste(es$src_type, es$src, sep = ":") %in% node_names) &
        (paste(es$dest_type, es$dest, sep = ":") %in% node_names)
      sum(mask) >= min_edge_num
    }
    Filter(pred, pathways)
  }

  fpaths <- filter_pathways(rpaths, fexpr, 10)

  #We use the helper function runClipper to start our analysis. Note that we explicitly require metabolites from the pathways.
  out <- graphite::runClipper(fpaths, as.matrix(fexpr), classes, "mean", "mixed",
                    maxNodes = 150,seed=42)
 # names(out$results)
  #We use an helper function to visualize the results.
  plot_altered_path <- function(result, pathways, node_scale = 2) {
    title <- names(result)
    pathway <- pathways[[title]]
    graph <- graphite::pathwayGraph(pathway, which = "mixed")
    labels <- sapply(graph::nodes(graph), function(n) {
      n2 <- sub("^KEGGCOMP:", "", n)
      if (n != n2) {
        n2
      } else {
        AnnotationDbi::mapIds(org.Hs.eg.db, sub("^SYMBOL:", "", n), "SYMBOL", "SYMBOL",
               multiVas = "first")
      }
    })
    names(labels) <- graph::nodes(graph)
    altered <- unlist(strsplit(result[[1]][1, "pathGenes"], "[,;]"))
    selected <- graph::nodes(graph) %in% altered
    node_colors <- ifelse(selected, "red", "black")
    names(node_colors) <- graph::nodes(graph)
    base <- 0.75
    heights <- ifelse(selected, base * node_scale, base)
    names(heights) <- graph::nodes(graph)
    widths <- ifelse(selected, base * node_scale, base)
    names(widths) <- graph::nodes(graph)
    base <- 14
    fontsizes <- ifelse(selected, base * node_scale, base)
    names(fontsizes) <- graph::nodes(graph)
    between_altered <- function(edge_names, altered) {
      sapply(edge_names, function(edge_name) {
        nodes <- unlist(strsplit(edge_name, "~", fixed = TRUE))
        all(nodes %in% altered)
      })
    }
    edge_colors <- ifelse(between_altered(graph::edgeNames(graph), altered),
                          "red", "black")
    plot(graph,
         attrs = list(edge = list(arrowsize = 0.5)),
         nodeAttrs = list(label = labels, color = node_colors, width = widths,
                          height = heights, fontsize = fontsizes),
         edgeAttrs = list(color = edge_colors),
         recipEdges = "combined", main = title)
  }

  selection <- names(out$results)

  #pdf("test_lineage.pdf",width=15,height=28)
  #par(mfrow = c(length(selection), 1))
  for (idx in seq_along(out$results)) {
    res <- out$results[idx]
    if (names(res) %in% selection) {
      grDevices::pdf(paste(out_file_prefix,gsub(" ","_",names(res)),".pdf"),width=width,height = height)
      plot_altered_path(res, fpaths)
      grDevices::dev.off()
    }
  }
}
