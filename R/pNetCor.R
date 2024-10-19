#' @title The correlation network's extraction
#'
#' @param dat_meta the metabolite data, the row is the metabolite's KEGGID, and the column is the sample
#' @param dat_gene the gene expression data, the row is the gene symbol, and the column is the sample
#' @param cor_method specifies the type of correlations to compute. Spearman correlations are the Pearson linear correlations computed on the ranks of non-missing elements, using midranks for ties.
#' @param cor_threshold the cutoff of correlation coefficient
#' @param p_threshold the cutoff of correlation p value
#'
#' @return a figure and a data frame
#'
#' @importFrom magrittr %>%
#' @importFrom dplyr select filter arrange distinct mutate rename pull summarise group_by left_join inner_join cross_join
#' @importFrom tibble rownames_to_column column_to_rownames
#' @importFrom Hmisc rcorr
#' @importFrom reshape2 melt
#' @importFrom igraph graph_from_data_frame get.edgelist V degree
#' @export
#'
#' @examples
#' res <- pNetCor(meta_dat, gene_dat)
#' res
#'
pNetCor <- function(dat_meta,
                    dat_gene,
                    cor_method = "pearson",
                    cor_threshold = 0.9,
                    p_threshold = 0.01) {
  a1 <- gene_metabolite[, 1:2]
  a2 <- gene_metabolite[, 3:4]
  names(a1) = c("type", "name")
  names(a2) = c("type", "name")
  
  metabolic_gene <- rbind(a1, a2) %>%
    dplyr::filter(type == "gene") %>%
    dplyr::pull(name) %>%
    unique()
  
  meta_dat1 <- dat_meta %>%
    dplyr::mutate(type = "metabolite")
  gene_dat1 <- dat_gene %>%
    tibble::rownames_to_column(var = "name") %>%
    dplyr::filter(name %in% metabolic_gene) %>%
    tibble::column_to_rownames("name") %>%
    dplyr::mutate(type = "gene")
  gene_name <- rownames(gene_dat1)
  metabolite_name <- rownames(meta_dat1)
  
  dat_all <- rbind(meta_dat1, gene_dat1) %>%
    dplyr::select(-type) %>%
    t()
  
  print("Starting correlation calculation")
  print("If the data is large, it will take some minutes")
  dd <- Hmisc::rcorr(dat_all, type = cor_method)
  result_cor <- dd$r
  result_cor_melt <- reshape2::melt(result_cor) %>%
    dplyr::mutate(Var1 = as.character(Var1)) %>%
    dplyr::mutate(Var2 = as.character(Var2)) %>%
    dplyr::filter(abs(value) > cor_threshold) %>%
    dplyr::filter(Var1 != Var2) %>%
    dplyr::mutate(name1 = ifelse(Var1 > Var2, Var1, Var2)) %>%
    dplyr::mutate(name2 = ifelse(Var1 > Var2, Var2, Var1)) %>%
    dplyr::select(name1, name2, value) %>%
    dplyr::rename("cor_result" = "value") %>%
    unique()
  
  result_p <- dd$P
  result_p_melt <- reshape2::melt(result_p) %>%
    dplyr::mutate(Var1 = as.character(Var1)) %>%
    dplyr::mutate(Var2 = as.character(Var2)) %>%
    dplyr::filter(value < p_threshold) %>%
    dplyr::mutate(name1 = ifelse(Var1 > Var2, Var1, Var2)) %>%
    dplyr::mutate(name2 = ifelse(Var1 > Var2, Var2, Var1)) %>%
    dplyr::select(name1, name2, value) %>%
    dplyr::rename("p" = "value") %>%
    unique()
  
  result <- result_cor_melt %>%
    dplyr::inner_join(result_p_melt, by = c("name1", "name2")) %>%
    dplyr::mutate(type1 = ifelse(
      name1 %in% gene_name,
      "gene",
      ifelse(name1 %in% metabolite_name, "metabolite", "other")
    )) %>%
    dplyr::mutate(type2 = ifelse(
      name2 %in% gene_name,
      "gene",
      ifelse(name2 %in% metabolite_name, "metabolite", "other")
    ))
  
  
  relation <- result %>%
    dplyr::select(name1, name2)
  
  node1 <- result %>%
    dplyr::select(name1, type1) %>%
    dplyr::rename("name" = "name1", "type" = "type1")
  node2 <- result %>%
    dplyr::select(name2, type2) %>%
    dplyr::rename("name" = "name2", "type" = "type2")
  
  nodes <- rbind(node1, node2) %>%
    unique()
  
  network <- igraph::graph_from_data_frame(d = relation,
                                           vertices = nodes,
                                           directed = F)
  
  edge_g <- data.frame(igraph::get.edgelist(network))
  
  name <- data.frame(name = igraph::V(network)$name) %>%
    dplyr::left_join(nodes, by = "name")
  
  name_meta <- name %>%
    dplyr::filter(type == "metabolite") %>%
    dplyr::mutate(colors = "blue")
  
  name_gene <- name %>%
    dplyr::filter(type == "gene") %>%
    dplyr::mutate(colors = "red")
  
  name_all <- rbind(name_meta, name_gene)
  name <- name %>%
    dplyr::left_join(name_all, by = "name") %>%
    dplyr::select(name, colors, type.x) %>%
    dplyr::rename(type = type.x)
  
  shape1 = c("square", "circle")
  my_shape <- shape1[as.numeric(as.factor(name$type))]
  
  #计算每个节点的数量
  deg <- igraph::degree(network, mode = "all")
  
  p <- plot(
    network,
    vertex.color = name$colors,
    vertex.shape = my_shape,
    vertex.size = 9,
    vertex.label.cex = 0.5
  )
  h <- list(result = result, p = p)
  return(h)
}
