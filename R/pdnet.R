#' The important network of the metabolite and the gene expression
#'
#' @param metabolite_data the row is the metabolite's kegg id, and the column is the sample
#' @param gene_data the row is the gene symbol, and the column is the sample
#' @param diff_info the differential genes and metabolites information
#' @param cor_method the correlation method
#' @param cor_threshold the correlation threshold 
#' @param nsize the desired number of nodes constrained to the resulting subgraph
#'
#' @return a figure
#' @export
#'
#' @examples
#' load("/Users/guituantuan/Desktop/R_packages/MNet/R/test.data")
#' pdf("test.pdf")
#' pdnet(metabolite_data,gene_data,diff_info,cor_method="kendall",cor_threshold=0,nsize=10)
#' dev.off()


pdnet <- function(metabolite_data,gene_data,diff_info,cor_method="kendall",cor_threshold=0,nsize=10) {

  keggId <- gene <- logFC <- type <- cor_result <- NULL
#  gene_metabolite_1 <- data.table::fread("/Users/guituantuan/Desktop/projects/database/gene-metabolite/gene-metabolite_BiGG_graphite_uniq.txt") %>%
#    as.data.frame() %>%
#    dplyr::select(-"subsystems") %>%
#    unique()
  gene_metabolite_filter1 <- gene_metabolite_1 %>%
    dplyr::filter(keggId %in% rownames(metabolite_data)) %>%
    dplyr::filter(gene %in% rownames(metabolite_data))
  gene_metabolite_filter2 <- gene_metabolite_1 %>%
    dplyr::filter(keggId %in% rownames(metabolite_data)) %>%
    dplyr::filter(gene %in% rownames(gene_data))
  
  gene_metabolite_filter <- rbind(gene_metabolite_filter1,gene_metabolite_filter2)
  
  hh2 <- apply(gene_metabolite_filter2,1,function(x){pCorCliMet(gene_data,metabolite_data,x[4],x[2],method=cor_method)$cor_result})
  cor_result2 <- data.frame(matrix(unlist(hh2),nrow=nrow(gene_metabolite_filter2),byrow=T))
  names(cor_result2) <- c("metabolite","other_marker","cor_result","pvalue")
  if(nrow(gene_metabolite_filter1)>0) {

    hh1 <- apply(gene_metabolite_filter1,1,function(x){pCorCliMet(metabolite_data,metabolite_data,x[4],x[2],method=cor_method)$cor_result})
    cor_result1 <- data.frame(matrix(unlist(hh1),nrow=nrow(gene_metabolite_filter1),byrow=T))
    names(cor_result1) <- c("metabolite","other_marker","cor_result","pvalue")
    cor_result <- rbind(cor_result1,cor_result2)
  } else {
    cor_result <- cor_result1
  }
  cor_result$cor_result[which(is.na(cor_result$cor_result))] <- 0
  cor_result$cor_result <- as.numeric(cor_result$cor_result)
  
  cor_result <- cor_result %>%
    dplyr::left_join(gene_metabolite_filter,by=c("metabolite"="keggId","other_marker"="gene")) %>%
    unique()
  
  #nodes <- rbind(data.frame(name=unique(cor_result$metabolite),type="metabolite"),
  #               data.frame(name=unique(cor_result$other_marker),type="gene"))
  
  name_1 <- gene_metabolite_filter[,1:2]
  name_2 <- gene_metabolite_filter[,3:4]
  names(name_2) <- names(name_1)
  name_all <- rbind(name_1,name_2) %>%
    unique() %>%
    dplyr::rename("type"="src_type","name"="keggId")
  
  nodes <- data.frame(name=unique(c(cor_result$metabolite,cor_result$other_marker))) %>%
    dplyr::left_join(name_all,by="name")
  
  cor_result_filter <- cor_result %>%
    dplyr::filter(abs(cor_result) >= cor_threshold)
  network <- igraph::graph_from_data_frame(d=cor_result_filter,vertices=nodes, directed=F)
  cor_all <- 100*igraph::E(network)$cor_result**2
  substystem_all <- igraph::E(network)$pathway_type
  edge1 <- cbind(data.frame(igraph::get.edgelist(network)),cor_all,substystem_all)
  
  p <- diff_info$P.Value
  names(p) <- diff_info$name
  
  g <- dnet::dNetPipeline(network,pval=p,nsize=nsize)
  
  name <- data.frame(name=igraph::V(g)$name) %>%
    dplyr::left_join(nodes,by="name") %>%
    dplyr::left_join(diff_info,by="name") %>%
    dplyr::mutate(logFC=round(logFC,2))
  
  name_meta <- name %>%
    dplyr::filter(type=="metabolite")
  meta_limits=as.numeric(sprintf("%.1f", max(max(name_meta$logFC),abs(min(name_meta$logFC)))))+0.1
  meta_color <- node.color(limit=meta_limits,name_meta$logFC,low="blue", mid="gray", high="yellow")
  name_meta$colors <- meta_color
  
  name_gene <- name %>%
    dplyr::filter(type=="gene")
  gene_limits=as.numeric(sprintf("%.1f", max(max(name_gene$logFC),abs(min(name_gene$logFC)))))+0.1
  
  
  gene_color <- node.color(limit=gene_limits,name_gene$logFC)
  name_gene$colors <- gene_color
  
  name_all <- rbind(name_meta,name_gene)
  name <- name %>%
    dplyr::left_join(name_all,by="name") %>%
    dplyr::select(c("name","colors","type.x")) %>%
    dplyr::rename("type"="type.x")
  
  shape1=c("square","circle")
  my_shape <- shape1[as.numeric(as.factor(name$type))]
  
  #计算每个节点的数量
  deg <- igraph::degree(g, mode="all")
  
  edge_g <- data.frame(igraph::get.edgelist(g))
  edge_g1 <- unique(edge_g) %>%
    dplyr::left_join(edge1,by=c("X1","X2"))
  
  edge_color <- grDevices::rainbow(length(unique(edge_g1$substystem_all)))
  edge_color_1 <- edge_color[as.numeric(as.factor(edge_g1$substystem_all))]
  edge_g1$colors <- edge_color_1
  
  #  pdf("~/Desktop/test_2.pdf",width=15,height=15)
  
 # pdf("~/Desktop/test_1.pdf",width=8,height=8)
  plot(g,vertex.color=name$colors,vertex.shape=my_shape,vertex.size=2*deg**0.5,
       vertex.label.cex=0.7,edge.width=0.3*edge_g1$cor_all,edge.color=edge_g1$colors)
  #legend(x=-0.5, y=-0.5,legend=unique(edge_g1$substystem_all),pch=21,
  graphics::legend("topleft",legend=unique(edge_g1$substystem_all),pch="-",col=unique(edge_g1$color),
         pt.cex=.6,cex=.4,
         pt.bg=unique(edge_g1$color))
  off.sets=col.key(limit=gene_limits,bins=10,cex=0.7,graph.size = c(1,1),off.sets=c(x=0,y=0))
  off.sets=col.key(limit=meta_limits,bins=10,cex=0.7,low="blue", mid="gray", high="yellow",
                   off.sets=c(x=0,y=0),graph.size = c(1,0.9))
  
#  dev.off()
  
  node_color <- rbind(name_gene,name_meta)
  
  node_result <- data.frame(name=igraph::V(g)$name) %>%
    dplyr::left_join(node_color,by="name")
  edge_result <- cbind(data.frame(igraph::get.edgelist(g)),data.frame(cor=igraph::get.edge.attribute(g)$cor_result),
                       data.frame(pathway_type=igraph::get.edge.attribute(g)$pathway_type))
  result=list(node_result=node_result,edge_result=edge_result)
  return(result)
}
