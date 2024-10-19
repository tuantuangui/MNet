#' @title The subnetwork's extraction
#'
#' @param diff_metabolite the differential metabolite information, the name 's kegg id
#' @param diff_gene the differential genes information
#' @param nsize the desired number of nodes constrained to the resulting subgraph
#'
#' @return a figure
#' 
#' @importFrom magrittr %>%
#' @importFrom dplyr select filter arrange distinct mutate rename pull summarise group_by left_join inner_join cross_join
#' @importFrom igraph graph_from_data_frame get.edgelist V degree
#' @importFrom dnet dNetPipeline
#' @export
#'
#' @examples
#' library(dplyr)
#' 
#' names(diff_meta)[4]  <- "p_value"
#' diff_metabolite <- diff_meta %>%
#'   dplyr::filter(adj.P.Val < 0.01) %>%
#'   dplyr::filter(abs(logFC)>1)
#'   
#' names(diff_gene)[4] <- "p_value"
#' diff_gene1 <- diff_gene %>%
#'   dplyr::filter(adj.P.Val < 0.01) %>%
#'   dplyr::filter(abs(logFC)>1)
#'   
#' res <- pdnet(diff_meta,diff_gene,nsize=100)
#' res
#' 
#' res <- pdnet(diff_metabolite[,8],diff_gene1[1:500,8])
#' res
#'

pdnet <- function(diff_metabolite, diff_gene, nsize = 10) {
  keggId <- gene <- logFC <- type <- cor_result <- NULL
  gene_metabolite_1 <- gene_metabolite %>%
    as.data.frame() %>%
    unique()
  gene_metabolite_filter1 <- gene_metabolite_1 %>%
    dplyr::filter(keggId %in% diff_metabolite$name) %>%
    dplyr::filter(gene %in% diff_metabolite$name)
  gene_metabolite_filter2 <- gene_metabolite_1 %>%
    dplyr::filter(keggId %in% diff_metabolite$name) %>%
    dplyr::filter(gene %in% diff_gene$name)
  
  gene_metabolite_filter <- rbind(gene_metabolite_filter1, gene_metabolite_filter2)
  
  name_1 <- gene_metabolite_filter[, 1:2]
  name_2 <- gene_metabolite_filter[, 3:4]
  names(name_2) <- names(name_1)
  name_all <- rbind(name_1, name_2) %>%
    unique() %>%
    dplyr::rename(type = src_type, name = keggId)
  
  diff_info <- rbind(diff_metabolite, diff_gene)
  
  if ("p_value" %in% names(diff_info)) {
    nodes <- name_all %>%
      dplyr::select(name, type)
    
    relation <- gene_metabolite_filter %>%
      dplyr::select(keggId, gene)
    network <- igraph::graph_from_data_frame(d = relation,
                                             vertices = nodes,
                                             directed = F)
    
    p <- diff_info %>% dplyr::pull(p_value)
    names(p) <- diff_info %>% dplyr::pull(name)
    
    g <- dnet::dNetPipeline(network, pval = p, nsize = nsize)
    
    edge_g <- data.frame(igraph::get.edgelist(g))
    
    name <- data.frame(name = igraph::V(g)$name) %>%
      dplyr::left_join(nodes, by = "name") %>%
      dplyr::left_join(diff_info, by = "name")
    
    if ("logFC" %in% names(diff_info)) {
      name <- name %>%
        dplyr::mutate(logFC = round(logFC, 2))
      
      name_meta <- name %>%
        dplyr::filter(type == "metabolite")
      meta_limits = as.numeric(sprintf("%.1f", max(max(
        name_meta$logFC
      ), abs(
        min(name_meta$logFC)
      )))) + 0.1
      meta_color <- node.color(
        limit = meta_limits,
        name_meta$logFC,
        low = "blue",
        mid = "gray",
        high = "yellow"
      )
      name_meta$colors <- meta_color
      
      name_gene <- name %>%
        dplyr::filter(type == "gene")
      gene_limits = as.numeric(sprintf("%.1f", max(max(
        name_gene$logFC
      ), abs(
        min(name_gene$logFC)
      )))) + 0.1
      
      gene_color <- node.color(limit = gene_limits, name_gene$logFC)
      name_gene$colors <- gene_color
    } else {
      name_meta <- name %>%
        dplyr::filter(type == "metabolite") %>%
        dplyr::mutate(colors = "blue")
      
      name_gene <- name %>%
        dplyr::filter(type == "gene") %>%
        dplyr::mutate(colors = "red")
    }
    name_all <- rbind(name_meta, name_gene)
    name <- name %>%
      dplyr::left_join(name_all, by = "name") %>%
      dplyr::select(name, colors, type.x) %>%
      dplyr::rename(type = type.x)
    
    shape1 = c("square", "circle")
    my_shape <- shape1[as.numeric(as.factor(name$type))]
    
    #计算每个节点的数量
    deg <- igraph::degree(g, mode = "all")
    
    plot(
      g,
      vertex.color = name$colors,
      vertex.shape = my_shape,
      vertex.size = 9,
      vertex.label.cex = 0.5
    )
    
    if ("logFC" %in% names(diff_info)) {
      off.sets = col.key(
        limit = gene_limits,
        bins = 10,
        cex = 0.5,
        graph.size = c(1, 1),
        off.sets = c(x = 0, y = 0)
      )
      off.sets = col.key(
        limit = meta_limits,
        bins = 10,
        cex = 0.5,
        low = "blue",
        mid = "gray",
        high = "yellow",
        off.sets = c(x = 0, y = 0),
        graph.size = c(1, 0.9)
      )
    }
    node_color <- rbind(name_gene, name_meta)
    
    node_result <- data.frame(name = igraph::V(g)$name) %>%
      dplyr::left_join(node_color, by = "name")
    
    result <- list(node_result = node_result, edge_result = edge_g)
    return(result)
  } else {
    nodes <- name_all %>%
      dplyr::select(name, type) %>%
      dplyr::mutate(color = ifelse(type == "metabolite", "red", "blue")) %>%
      dplyr::mutate(shape1 = ifelse(type == "metabolite", "circle", "square"))
    
    relation <- gene_metabolite_filter %>%
      dplyr::select(keggId, gene)
    network <- igraph::graph_from_data_frame(d = relation,
                                             vertices = nodes,
                                             directed = F)
    
    name <- data.frame(name = igraph::V(network)$name) %>%
      dplyr::left_join(nodes, by = "name")
    
    deg <- igraph::degree(network, mode = "all")
    
    plot(
      network,
      vertex.color = name$color,
      vertex.shape = name$shape1,
      vertex.size = 9,
      vertex.label.cex = 0.5
    )
    edge_g <- data.frame(igraph::get.edgelist(network))
    return(edge_g)
  }
}
