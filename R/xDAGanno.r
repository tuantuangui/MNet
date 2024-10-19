xDAGanno <- function(g,
                      annotation,
                      path.mode = c("all_paths", "shortest_paths", "all_shortest_paths"),
                      true.path.rule = TRUE,
                      verbose = TRUE)
{
  path.mode <- match.arg(path.mode)
  
  ig <- g
  if (!is(ig, "igraph")) {
    stop("The function must apply to the 'igraph' object.\n")
  }
  
  if (is(annotation, "GS")) {
    originAnnos <- annotation$gs
  } else if (is(annotation, "list")) {
    originAnnos <- annotation
  } else if (is(annotation, "dgCMatrix")) {
    D <- annotation
    originAnnos <- sapply(1:ncol(D), function(j) {
      names(which(D[, j] != 0))
    })
    names(originAnnos) <- colnames(annotation)
  } else{
    stop("The input annotation must be either 'GS' or 'list' or 'dgCMatrix' object.\n")
  }
  
  ## check nodes in annotation
  if (is.list(originAnnos)) {
    originNodes <- names(originAnnos)
    
    ind <- match(originNodes, V(ig)$name)
    nodes_mapped <- originNodes[!is.na(ind)]
    if (length(nodes_mapped) == 0) {
      stop(
        "The input annotation data do not contain terms matched to the nodes/terms in the input graph.\n"
      )
    }
  }
  
  ## generate a subgraph of a direct acyclic graph (DAG) induced by terms from input annotations
  dag <- dnet::dDAGinduce(ig, originNodes, path.mode = path.mode)
  allNodes <- V(dag)$name
  
  ## create a new (empty) hash environment
  ## node2domain.HoH: 1st key (node/term), 2nd key (domain), value (origin/inherit)
  node2domain.HoH <- new.env(hash = TRUE, parent = emptyenv())
  
  ## assigin original annotations to "node2domain.HoH"
  lapply(allNodes, function(node) {
    e <- new.env(hash = TRUE, parent = emptyenv())
    if (node %in% originNodes) {
      sapply(originAnnos[[node]], function(x) {
        assign(as.character(x), "o", envir = e)
      })
    }
    assign(node, e, envir = node2domain.HoH)
  })
  
  ## whether true-path rule will be applied
  if (true.path.rule) {
    ## get the levels list
    level2node <- dnet::dDAGlevel(dag, level.mode = "longest_path", return.mode =
                                    "level2node")
    ## build a hash environment from the named list "level2node"
    ## level2node.Hash: key (level), value (a list of nodes/terms)
    level2node.Hash <- list2env(level2node)
    nLevels <- length(level2node)
    for (i in nLevels:1) {
      currNodes <- get(as.character(i), envir = level2node.Hash, mode = 'character')
      
      ## get the incoming neighbors (excluding self) that are reachable (i.e. nodes from i-1 level)
      adjNodesList <- lapply(currNodes, function(node) {
        neighs.in <- igraph::neighborhood(dag,
                                          order = 1,
                                          nodes = node,
                                          mode = "in")
        setdiff(V(dag)[unlist(neighs.in)]$name, node)
      })
      names(adjNodesList) <- currNodes
      
      ## push the domains from level i to level i - 1
      lapply(currNodes, function(node) {
        ## get the domains from this node
        domainsID <- ls(get(node, envir = node2domain.HoH, mode = 'environment'))
        
        ## assigin inherit annotations to "node2domain.HoH"
        lapply(adjNodesList[[node]], function(adjNode) {
          adjEnv <- get(adjNode, envir = node2domain.HoH, mode = 'environment')
          sapply(domainsID, function(domainID) {
            assign(domainID, "i", envir = adjEnv)
          })
        })
      })
      
      if (verbose) {
        message(
          sprintf(
            "\tAt level %d, there are %d nodes, and %d incoming neighbors.",
            i,
            length(currNodes),
            length(unique(unlist(
              adjNodesList
            )))
          ),
          appendLF = TRUE
        )
      }
      
    }
  }
  
  node2domains <- as.list(node2domain.HoH)[allNodes]
  domain_annotation <- lapply(node2domains, function(node) {
    #unlist(as.list(node))
    #names(unlist(as.list(node)))
    vec <- unlist(as.list(node))
    res <- names(vec)
    names(res) <- vec
    res
  })
  
  ## append 'anno' attributes to the graph
  V(dag)$anno <- domain_annotation
  
  ## append 'IC' attributes to the graph
  counts <- sapply(V(dag)$anno, length)
  IC <- -1 * log10(counts / max(counts))
  ### force those 'Inf' to be 'zero'
  if (1) {
    IC[is.infinite(IC)] <- 0
  }
  V(dag)$IC <- IC
  
  return(dag)
}
