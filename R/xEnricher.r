#' Function to conduct enrichment analysis given the input data and the ontology and its annotation
#'
#' \code{xEnricher} is supposed to conduct enrichment analysis given the input data and the ontology direct acyclic graph (DAG) and its annotation. It returns an object of class "eTerm". Enrichment analysis is based on either Fisher's exact test or Hypergeometric test. The test can respect the hierarchy of the ontology.
#'
#' @param data an input vector containing a list of genes or SNPs of interest
#' @param annotation the vertices/nodes for which annotation data are provided. It can be a sparse Matrix of class "dgCMatrix" (with variants/genes as rows and terms as columns), or a list of nodes/terms each containing annotation data, or an object of class 'GS' (basically a list for each node/term with annotation data)
#' @param g an object of class "igraph" to represent DAG. It must have node/vertice attributes: "name" (i.e. "Term ID"), "term_id" (i.e. "Term ID"), "term_name" (i.e "Term Name") and "term_distance" (i.e. Term Distance: the distance to the root; always 0 for the root itself)
#' @param background a background vector. It contains a list of genes or SNPs as the test background. If NULL, by default all annotatable are used as background
#' @param size.range the minimum and maximum size of members of each term in consideration. By default, it sets to a minimum of 10 but no more than 2000
#' @param min.overlap the minimum number of overlaps. Only those terms with members that overlap with input data at least min.overlap (3 by default) will be processed
#' @param which.distance which terms with the distance away from the ontology root (if any) is used to restrict terms in consideration. By default, it sets to 'NULL' to consider all distances
#' @param test the test statistic used. It can be "fisher" for using fisher's exact test, "hypergeo" for using hypergeometric test, or "binomial" for using binomial test. Fisher's exact test is to test the independence between gene group (genes belonging to a group or not) and gene annotation (genes annotated by a term or not), and thus compare sampling to the left part of background (after sampling without replacement). Hypergeometric test is to sample at random (without replacement) from the background containing annotated and non-annotated genes, and thus compare sampling to background. Unlike hypergeometric test, binomial test is to sample at random (with replacement) from the background with the constant probability. In terms of the ease of finding the significance, they are in order: hypergeometric test > fisher's exact test > binomial test. In other words, in terms of the calculated p-value, hypergeometric test < fisher's exact test < binomial test
#' @param background.annotatable.only logical to indicate whether the background is further restricted to the annotatable. By default, it is NULL: if ontology.algorithm is not 'none', it is always TRUE; otherwise, it depends on the background (if not provided, it will be TRUE; otherwise FALSE). Surely, it can be explicitly stated
#' @param p.tail the tail used to calculate p-values. It can be either "two-tails" for the significance based on two-tails (ie both over- and under-overrepresentation)  or "one-tail" (by default) for the significance based on one tail (ie only over-representation)
#' @param p.adjust.method the method used to adjust p-values. It can be one of "BH", "BY", "bonferroni", "holm", "hochberg" and "hommel". The first two methods "BH" (widely used) and "BY" control the false discovery rate (FDR: the expected proportion of false discoveries amongst the rejected hypotheses); the last four methods "bonferroni", "holm", "hochberg" and "hommel" are designed to give strong control of the family-wise error rate (FWER). Notes: FDR is a less stringent condition than FWER
#' @param ontology.algorithm the algorithm used to account for the hierarchy of the ontology. It can be one of "none", "pc", "elim" and "lea". For details, please see 'Note' below
#' @param elim.pvalue the parameter only used when "ontology.algorithm" is "elim". It is used to control how to declare a signficantly enriched term (and subsequently all genes in this term are eliminated from all its ancestors)
#' @param lea.depth the parameter only used when "ontology.algorithm" is "lea". It is used to control how many maximum depth is used to consider the children of a term (and subsequently all genes in these children term are eliminated from the use for the recalculation of the signifance at this term)
#' @param path.mode the mode of paths induced by vertices/nodes with input annotation data. It can be "all_paths" for all possible paths to the root, "shortest_paths" for only one path to the root (for each node in query), "all_shortest_paths" for all shortest paths to the root (i.e. for each node, find all shortest paths with the equal lengths)
#' @param true.path.rule logical to indicate whether the true-path rule should be applied to propagate annotations. By default, it sets to true
#' @param verbose logical to indicate whether the messages will be displayed in the screen. By default, it sets to true for display
#' @return 
#' an object of class "eTerm", a list with following components:
#' \itemize{
#'  \item{\code{term_info}: a matrix of nTerm X 4 containing snp/gene set information, where nTerm is the number of terms, and the 4 columns are "id" (i.e. "Term ID"), "name" (i.e. "Term Name"), "namespace" and "distance"}
#'  \item{\code{annotation}: a list of terms containing annotations, each term storing its annotations. Always, terms are identified by "id"}
#'  \item{\code{g}: an igraph object to represent DAG}
#'  \item{\code{data}: a vector containing input data in consideration. It is not always the same as the input data as only those mappable are retained}
#'  \item{\code{background}: a vector containing the background data. It is not always the same as the input data as only those mappable are retained}
#'  \item{\code{overlap}: a list of overlapped snp/gene sets, each storing snps/genes overlapped between a snp/gene set and the given input data (i.e. the snps/genes of interest). Always, gene sets are identified by "id"}
#'  \item{\code{fc}: a vector containing fold changes}
#'  \item{\code{zscore}: a vector containing z-scores}
#'  \item{\code{pvalue}: a vector containing p-values}
#'  \item{\code{adjp}: a vector containing adjusted p-values. It is the p value but after being adjusted for multiple comparisons}
#'  \item{\code{or}: a vector containing odds ratio}
#'  \item{\code{CIl}: a vector containing lower bound confidence interval for the odds ratio}
#'  \item{\code{CIu}: a vector containing upper bound confidence interval for the odds ratio}
#'  \item{\code{cross}: a matrix of nTerm X nTerm, with an on-diagnal cell for the overlapped-members observed in an individaul term, and off-diagnal cell for the overlapped-members shared between two terms}
#'  \item{\code{call}: the call that produced this result}
#' }
#' @note The interpretation of the algorithms used to account for the hierarchy of the ontology is:
#' \itemize{
#' \item{"none": does not consider the ontology hierarchy at all.}
#' \item{"lea": estimates the significance of a term in terms of the significance of its children at the maximum depth (e.g. 2). Precisely, once snps/genes are already annotated to any children terms with a more signficance than itself, then all these snps/genes are eliminated from the use for the recalculation of the signifance at that term. The final p-values takes the maximum of the original p-value and the recalculated p-value.}
#' \item{"elim": estimates the significance of a term in terms of the significance of its all children. Precisely, once snps/genes are already annotated to a signficantly enriched term under the cutoff of e.g. pvalue<1e-2, all these snps/genes are eliminated from the ancestors of that term).}
#' \item{"pc": requires the significance of a term not only using the whole snps/genes as background but also using snps/genes annotated to all its direct parents/ancestors as background. The final p-value takes the maximum of both p-values in these two calculations.}
#' \item{"Notes": the order of the number of significant terms is: "none" > "lea" > "elim" > "pc".}
#' }
#' @export
#' @import igraph
#' @seealso \code{\link{xDAGanno}}
#' @include xEnricher.r
#' @examples
#' RData.location <- "http://galahad.well.ox.ac.uk/bigdata"
#' \dontrun{
#' # 1) SNP-based enrichment analysis using GWAS Catalog traits (mapped to EF)
#' # 1a) ig.EF (an object of class "igraph" storing as a directed graph)
#' g <- xRDataLoader('ig.EF')
#'
#' # 1b) load GWAS SNPs annotated by EF (an object of class "dgCMatrix" storing a spare matrix)
#' anno <- xRDataLoader(RData='GWAS2EF')
#'
#' # 1c) optionally, provide the test background (if not provided, all annotatable SNPs)
#' background <- rownames(anno)
#' 
#' # 1d) provide the input SNPs of interest (eg 'EFO:0002690' for 'systemic lupus erythematosus')
#' ind <- which(colnames(anno)=='EFO:0002690')
#' data <- rownames(anno)[anno[,ind]==1]
#' data
#' 
#' # 1e) perform enrichment analysis
#' eTerm <- xEnricher(data=data, annotation=anno, background=background, g=g, path.mode=c("all_paths"))
#' 
#' # 1f) view enrichment results for the top significant terms
#' xEnrichViewer(eTerm)
#'
#' # 1f') save enrichment results to the file called 'EF_enrichments.txt'
#' res <- xEnrichViewer(eTerm, top_num=length(eTerm$adjp), sortBy="adjp", details=TRUE)
#' output <- data.frame(term=rownames(res), res)
#' utils::write.table(output, file="EF_enrichments.txt", sep="\t", row.names=FALSE)
#'
#' # 1g) barplot of significant enrichment results
#' bp <- xEnrichBarplot(eTerm, top_num="auto", displayBy="adjp")
#' print(bp)
#'
#' # 1h) visualise the top 10 significant terms in the ontology hierarchy
#' # color-code terms according to the adjust p-values (taking the form of 10-based negative logarithm)
#' xEnrichDAGplot(eTerm, top_num=10, displayBy="adjp", node.info=c("full_term_name"))
#' # color-code terms according to the z-scores
#' xEnrichDAGplot(eTerm, top_num=10, displayBy="zscore", node.info=c("full_term_name"))
#' }

xEnricher <- function(data, annotation, g, background=NULL, size.range=c(10,2000), min.overlap=5, which.distance=NULL, test=c("fisher","hypergeo","binomial"), background.annotatable.only=NULL, p.tail=c("one-tail","two-tails"), p.adjust.method=c("BH", "BY", "bonferroni", "holm", "hochberg", "hommel"), ontology.algorithm=c("none","pc","elim","lea"), elim.pvalue=1e-2, lea.depth=2, path.mode=c("all_paths","shortest_paths","all_shortest_paths"), true.path.rule=TRUE, verbose=TRUE)
{

    ####################################################################################
    
    ## match.arg matches arg against a table of candidate values as specified by choices, where NULL means to take the first one
    test <- match.arg(test)
    p.tail <- match.arg(p.tail)
    p.adjust.method <- match.arg(p.adjust.method)
    ontology.algorithm <- match.arg(ontology.algorithm)
    path.mode <- match.arg(path.mode)
    p.tail <- match.arg(p.tail)
    
    if (is.vector(data)){
        data <- unique(data)
    }else{
        warnings("The input data must be a vector.\n")
        return(NULL)
    }
    
    if(is(annotation,"GS")){
        originAnnos <- annotation$gs
    }else if(is(annotation,"list")){
        originAnnos <- annotation
    }else if(is(annotation,"dgCMatrix")){
		D <- annotation
		originAnnos <- sapply(1:ncol(D), function(j){
			names(which(D[,j]!=0))
		})
		names(originAnnos) <- colnames(annotation)
    }else{
    	warnings("The input annotation must be either 'GS' or 'list' or 'dgCMatrix' object.\n")
    	return(NULL)
    }
    annotation <- originAnnos

    ig <- g
    if (!is(ig,"igraph")){
        warnings("The function must apply to the 'igraph' object.\n")
        return(NULL)
    }else{
		
		if(verbose){
			now <- Sys.time()
			message(sprintf("First, generate a subgraph induced (via '%s' mode) by the annotation data (%s) ...", path.mode, as.character(now)), appendLF=TRUE)
		}
    	
    	# obtain the induced subgraph according to the input annotation data based on shortest paths (i.e. the most concise subgraph induced)
		subg <- xDAGanno(g=ig, annotation=annotation, path.mode=path.mode, true.path.rule=true.path.rule, verbose=verbose)

    	gs <- V(subg)$anno
    	names(gs) <- V(subg)$name
    	
    	gs.distance <- V(subg)$term_distance
    	names(gs.distance) <- V(subg)$name
	
	}
	
    ## take into account the given background
    if(1){
        ########################
        if (is.vector(background)){
            background <- base::unique(background)
            background <- background[!is.null(background)]
            background <- background[!is.na(background)]
        }
        if(length(background)>0){
        	if(1){
				## background should be: customised background plus input data of interest
				background <- base::union(background, data)
        	}
            ###########################################
            gs <- lapply(gs, function(x){
            	ind <- match(x, background)
            	x[!is.na(ind)]
            })
        }
        ########################
    }
    
    ###############################
    
    ## filter based on "which.distance"
    if(!is.null(which.distance) & sum(is.na(gs.distance))==0){
        distance_filtered <- lapply(which.distance, function(x) {
            names(gs)[(gs.distance==as.integer(x))]
        })
        distance_filtered <- unlist(distance_filtered)
    }else{
        distance_filtered <- names(gs)
    }
    ind.distance <- match(distance_filtered, names(gs))
    
    ## filter based on "size.range"
    gs.length <- sapply(gs, length)
    ind.length <- which(gs.length >= size.range[1] & gs.length <= size.range[2])
    
    ## do filtering
    ind <- intersect(ind.distance, ind.length)
    gs <- gs[ind]
    
    if(length(gs)==0){
        warnings("There are no terms being used.\n")
        return(NULL)
    }

    ##############################################################################################
    ## Fisher's exact test: testing the independence between gene group (genes belonging to a group or not) and gene annotation (genes annotated by a term or not); thus compare sampling to the left part of background (after sampling without replacement)
    doFisherTest <- function(genes.group, genes.term, genes.universe){
        genes.hit <- intersect(genes.group, genes.term)
        # num of success in sampling
        X <- length(genes.hit)
        # num of sampling
        K <- length(genes.group)
        # num of success in background
        M <- length(genes.term)
        # num in background
        N <- length(genes.universe)
        ## Prepare a two-dimensional contingency table: #success in sampling, #success in background, #failure in sampling, and #failure in left part
        cTab <- matrix(c(X, K-X, M-X, N-M-K+X), nrow=2, dimnames=list(c("anno", "notAnno"), c("group", "notGroup")))
        
        if(0){
			p.value <- ifelse(all(cTab==0), 1, stats::fisher.test(cTab, alternative="greater")$p.value)
        }else{
			if(all(cTab==0)){
				p.value <- 1
			}else{
				if(p.tail=='one-tail'){
					p.value <- stats::fisher.test(cTab, alternative="greater")$p.value
				}else{
					if(X>=K*M/N){
						p.value <- stats::fisher.test(cTab, alternative="greater")$p.value
					}else{
						p.value <- stats::fisher.test(cTab, alternative="less")$p.value
					}
				}
			}
        }
        
        return(p.value)
    }

    ## Hypergeometric test: sampling at random from the background containing annotated and non-annotated genes (without replacement); thus compare sampling to background
    doHypergeoTest <- function(genes.group, genes.term, genes.universe, p.tail){
        genes.hit <- intersect(genes.group, genes.term)
        # num of success in sampling
        X <- length(genes.hit)
        # num of sampling
        K <- length(genes.group)
        # num of success in background
        M <- length(genes.term)
        # num in background
        N <- length(genes.universe)
    
        x <- X
        m <- M
        n <- N-M # num of failure in background
        k <- K
    	#########################
    	if(m==0 || k==0){
    		p.value <- 1
    	}else{
    		if(p.tail=='one-tail'){
    			p.value <- stats::phyper(x,m,n,k, lower.tail=FALSE, log.p=FALSE)
    		}else{
    			if(X>=K*M/N){
    				p.value <- stats::phyper(x,m,n,k, lower.tail=FALSE, log.p=FALSE)
    			}else{
    				p.value <- stats::phyper(x,m,n,k, lower.tail=TRUE, log.p=FALSE)
    			}
    		}
    	}
    	#########################
        #p.value <- ifelse(m==0 || k==0, 1, stats::phyper(x,m,n,k, lower.tail=lower.tail, log.p=FALSE))
        
        
        return(p.value)
    }
    
    
    ## Binomial test: sampling at random from the background with the constant probability of having annotated genes (with replacement)
    doBinomialTest <- function(genes.group, genes.term, genes.universe, p.tail){
        genes.hit <- intersect(genes.group, genes.term)
        # num of success in sampling
        X <- length(genes.hit)
        # num of sampling
        K <- length(genes.group)
        # num of success in background
        M <- length(genes.term)
        # num in background
        N <- length(genes.universe)
    	
    	#########################
    	if(K==0 || M==0 || N==0){
    		p.value <- 1
    	}else{
    		if(p.tail=='one-tail'){
    			p.value <- stats::pbinom(X,K,M/N, lower.tail=FALSE, log.p=FALSE)
    		}else{
    			if(X>=K*M/N){
    				p.value <- stats::pbinom(X,K,M/N, lower.tail=FALSE, log.p=FALSE)
    			}else{
    				p.value <- stats::pbinom(X,K,M/N, lower.tail=TRUE, log.p=FALSE)
    			}
    		}
    	}
    	#########################
        #p.value <- ifelse(K==0 || M==0 || N==0, 1, stats::pbinom(X,K,M/N, lower.tail=FALSE, log.p=FALSE))
        
        return(p.value)
    }
    
    
    ##  Z-score from hypergeometric distribution
    zscoreHyper <- function(genes.group, genes.term, genes.universe){
        genes.hit <- intersect(genes.group, genes.term)
        # num of success in sampling
        X <- length(genes.hit)
        # num of sampling
        K <- length(genes.group)
        # num of success in background
        M <- length(genes.term)
        # num in background
        N <- length(genes.universe)
        
        ## calculate z-score
        if(1){
            ## Z-score based on theoretical calculation
            x.exp <- K*M/N
            var.exp <- K*M/N*(N-M)/N*(N-K)/(N-1)
            if(is.na(var.exp)){
            	z <- NA
            }else{
				if(var.exp!=0){
					suppressWarnings(z <- (X-x.exp)/sqrt(var.exp))
				}else{
					z <- NA
				}
			}
            
        }else{
            ## Z-score equivalents for deviates from hypergeometric distribution
            x <- X
            m <- M
            n <- N-M # num of failure in background
            k <- K
            
            suppressWarnings(d <- stats::dhyper(x,m,n,k,log=TRUE)-log(2))
            suppressWarnings(pupper <- stats::phyper(x,m,n,k,lower.tail=FALSE,log.p=TRUE))
            suppressWarnings(plower <- stats::phyper(x-1,m,n,k,lower.tail=TRUE,log.p=TRUE))
            d[is.na(d)] <- -Inf
            pupper[is.na(pupper)] <- -Inf
            plower[is.na(plower)] <- -Inf

            # Add half point probability to upper tail probability preserving log-accuracy
            a <- pupper
            b <- d-pupper
            a[b>0] <- d[b>0]
            b <- -abs(b)
            pmidupper <- a+log1p(exp(b))
            pmidupper[is.infinite(a)] <- a[is.infinite(a)]

            # Similarly for lower tail probability preserving log-accuracy
            a <- plower
            b <- d-plower
            a[b>0] <- d[b>0]
            b <- -abs(b)
            pmidlower <- a+log1p(exp(b))
            pmidlower[is.infinite(a)] <- a[is.infinite(a)]

            up <- pmidupper<pmidlower
            if(any(up)) z <- stats::qnorm(pmidupper,lower.tail=FALSE,log.p=TRUE)
            if(any(!up)) z <- stats::qnorm(pmidlower,lower.tail=TRUE,log.p=TRUE)
        }
        
        return(z)
    }
    
    ## fold change calculated from hypergeometric distribution
    fcHyper <- function(genes.group, genes.term, genes.universe){
        genes.hit <- intersect(genes.group, genes.term)
        # num of success in sampling
        X <- length(genes.hit)
        # num of sampling
        K <- length(genes.group)
        # num of success in background
        M <- length(genes.term)
        # num in background
        N <- length(genes.universe)
        
        x.exp <- K*M/N
        fc <- X/x.exp

        return(fc)
    }
    
    ## odds ratio calculated from Fisher's exact test
    ### OR is a measure of association between a risk factor and a disease outcome. The OR represents the odds that the disease outcome will occur given the risk factor, compared to the odds of the outcome occurring in the absence of that risk factor. Used to determine whether a factor is risky for the outcome, and to compare the magnitude of various risk factors for that outcome.
    ### The 95% confidence interval (CI) is used to estimate the precision of the OR; the higher CI is the lower the precision is. Does not report a statistical significance
    ### Confounding: a confounding variable influences/explains a non-casual association between a factor and the outcome. A confounding variable is causally associated with the outcome, and non-causally or causally associated with the disease, but is not an intermediate variable in the causal pathway between exposure and outcome. Stratification and multiple regression techniques are two methods used to address confounding, and produce adjusted ORs.
    orFisher <- function(genes.group, genes.term, genes.universe){
        genes.hit <- intersect(genes.group, genes.term)
        # num of success in sampling
        X <- length(genes.hit)
        # num of sampling
        K <- length(genes.group)
        # num of success in background
        M <- length(genes.term)
        # num in background
        N <- length(genes.universe)
        ## Prepare a two-dimensional contingency table: #success in sampling, #success in background, #failure in sampling, and #failure in left part
        cTab <- matrix(c(X, K-X, M-X, N-M-K+X), nrow=2, dimnames=list(c("anno", "notAnno"), c("group", "notGroup")))
        res <- stats::fisher.test(cTab)
        
        return(c(as.vector(res$estimate), as.vector(res$conf.int)))
    }
    ##############################################################################################

    if(verbose){
    	now <- Sys.time()
        message(sprintf("Next, prepare enrichment analysis (%s) ...", as.character(now)), appendLF=TRUE)
    }
    
    #############################
    if(ontology.algorithm!="none"){
    	background.annotatable.only <- TRUE
    }else{
    	if(is.null(background.annotatable.only)){
    		if(length(background)==0){
    			background.annotatable.only <- TRUE
    		}else{
    			background.annotatable.only <- FALSE
    		}
    	}
    }
    ## now background.annotatable.only can be T or F only
    #############################
        
    terms <- names(gs)
    if(background.annotatable.only){
    	genes.universe <- unique(unlist(gs[terms]))
    }else{
    	genes.universe <- background
    }
    genes.group <- intersect(genes.universe, data)

    if(length(genes.group)==0){
        #stop("There is no gene being used.\n")
        warnings("There is no gene being used.\n")
        return(NULL)
    }else{
		if(verbose){
			now <- Sys.time()
			message(sprintf("\tThere are %d genes/SNPs of interest tested against %d genes/SNPs as the background (annotatable only? %s) (%s)", length(genes.group), length(genes.universe), background.annotatable.only, as.character(now)), appendLF=TRUE)
		}
    }

    ## generate a subgraph of a direct acyclic graph (DAG) induced by terms
    subg <- dnet::dDAGinduce(g=subg, nodes_query=terms, path.mode=path.mode)
	set_info <- data.frame(id=V(subg)$term_id, name=V(subg)$term_name, distance=V(subg)$term_distance, namespace=V(subg)$term_namespace, row.names=V(subg)$name, stringsAsFactors=FALSE)
    
    if(ontology.algorithm=="none"){
    
        if(verbose){
            now <- Sys.time()
            message(sprintf("Third, perform enrichment analysis using '%s' test (%s) ...", test, as.character(now)), appendLF=TRUE)
            if(is.null(which.distance)){
                message(sprintf("\tThere are %d terms being used, each restricted within [%s] annotations", length(terms), paste(size.range,collapse=",")), appendLF=TRUE)
            }else{
                message(sprintf("\tThere are %d terms being used, each restricted within [%s] annotations and [%s] distance", length(terms), paste(size.range,collapse=","), paste(which.distance,collapse=",")), appendLF=TRUE)
            }
        }
    
        pvals <- sapply(terms, function(term){
            genes.term <- unique(unlist(gs[term]))
            p.value <- switch(test,
                fisher =  doFisherTest(genes.group, genes.term, genes.universe),
                hypergeo = doHypergeoTest(genes.group, genes.term, genes.universe, p.tail=p.tail),
                binomial = doBinomialTest(genes.group, genes.term, genes.universe, p.tail=p.tail)
            )
        })
        
        zscores <- sapply(terms, function(term){
            genes.term <- unique(unlist(gs[term]))
            zscoreHyper(genes.group, genes.term, genes.universe)
        })
        
        fcs <- sapply(terms, function(term){
            genes.term <- unique(unlist(gs[term]))
            fcHyper(genes.group, genes.term, genes.universe)
        })
        
        ls_or <- lapply(terms, function(term){
            genes.term <- unique(unlist(gs[term]))
            orFisher(genes.group, genes.term, genes.universe)
        })
        df_or <- do.call(rbind, ls_or)
        ors <- df_or[,1]
        CIl <- df_or[,2]
        CIu <- df_or[,3]        
        
    }else if(ontology.algorithm=="pc" || ontology.algorithm=="elim" || ontology.algorithm=="lea"){

        if(verbose){
            now <- Sys.time()
            message(sprintf("Third, perform enrichment analysis based on '%s' test, and also using '%s' algorithm to respect ontology structure (%s) ...", test, ontology.algorithm, as.character(now)), appendLF=TRUE)
        }
        
        #########
        
        if(verbose){
            message(sprintf("\tThere are %d terms being used", length(V(subg))), appendLF=TRUE)
        }
        
        level2node <- dnet::dDAGlevel(subg, level.mode="longest_path", return.mode="level2node")
        
        ## build a hash environment from the named list "level2node"
        ## level2node.Hash: key (level), value (a list of nodes/terms)
        level2node.Hash <- list2env(level2node)
        ## ls(level2node.Hash)
        nLevels <- length(level2node)
        
        ## create a new (empty) hash environment
        ## node2pval.Hash: key (node), value (pvalue)
        node2pval.Hash <- new.env(hash=TRUE, parent=emptyenv())        
        ## node2zscore.Hash: key (node), value (zscore)
        node2zscore.Hash <- new.env(hash=TRUE, parent=emptyenv())   
        ## node2fc.Hash: key (node), value (fc)
        node2fc.Hash <- new.env(hash=TRUE, parent=emptyenv())    
        
        ## node2or.Hash: key (node), value (or)
        node2or.Hash <- new.env(hash=TRUE, parent=emptyenv())
        ## node2CIl.Hash: key (node), value (CIl)
        node2CIl.Hash <- new.env(hash=TRUE, parent=emptyenv())
        ## node2CIu.Hash: key (node), value (CIu)
        node2CIu.Hash <- new.env(hash=TRUE, parent=emptyenv())
                        
        if(ontology.algorithm=="pc"){
        
            for(i in nLevels:2) {
                currNodes <- get(as.character(i), envir=level2node.Hash, mode="character")
    
                for(currNode in currNodes){
                    genes.term <- unique(unlist(gs[currNode]))
                
                    ## do test based on the whole genes as background
                    pvalue_whole <- switch(test,
                        fisher =  doFisherTest(genes.group, genes.term, genes.universe),
                        hypergeo = doHypergeoTest(genes.group, genes.term, genes.universe, p.tail=p.tail),
                        binomial = doBinomialTest(genes.group, genes.term, genes.universe, p.tail=p.tail)
                    )
                    zscore_whole <- zscoreHyper(genes.group, genes.term, genes.universe)
                    fc_whole <- fcHyper(genes.group, genes.term, genes.universe)
                    
                    vec_whole <- orFisher(genes.group, genes.term, genes.universe)
                    or_whole <- vec_whole[1]
                    CIl_whole <- vec_whole[2]
                    CIu_whole <- vec_whole[3]
            
                    ## get the incoming neighbors/parents (including self) that are reachable
                    neighs.in <- igraph::neighborhood(subg, order=1, nodes=currNode, mode="in")
                    adjNodes <- setdiff(V(subg)[unlist(neighs.in)]$name, currNode)
                
                    ## genes annotated in parents are as background
                    genes.parent <- unique(unlist(gs[adjNodes]))
        
                    ## make sure genes in group (genes in term) are also in parents
                    genes.group.parent <- intersect(genes.group, genes.parent)
                    genes.term.parent <- intersect(genes.term, genes.parent)

                    ## do test based on the genes in parents as background
                    pvalue_relative <- switch(test,
                        fisher =  doFisherTest(genes.group.parent, genes.term.parent, genes.parent),
                        hypergeo = doHypergeoTest(genes.group.parent, genes.term.parent, genes.parent, p.tail=p.tail),
                        binomial = doBinomialTest(genes.group.parent, genes.term.parent, genes.parent, p.tail=p.tail)
                    )
                    zscore_relative <- zscoreHyper(genes.group.parent, genes.term.parent, genes.parent)
                    fc_relative <- fcHyper(genes.group.parent, genes.term.parent, genes.parent)
                
                    vec_relative <- orFisher(genes.group.parent, genes.term.parent, genes.parent)
                    or_relative <- vec_relative[1]
                    CIl_relative <- vec_relative[2]
                    CIu_relative <- vec_relative[3]
                
                    ## take the maximum value of pvalue_whole and pvalue_relative
                    pvalue <- max(pvalue_whole, pvalue_relative)
                    ## store the result (the p-value)
                    assign(currNode, pvalue, envir=node2pval.Hash)
                    
                    ## zscore
                    zscore <- ifelse(pvalue_whole>pvalue_relative, zscore_whole, zscore_relative)
                    ## store the result (the z-score)
                    assign(currNode, zscore, envir=node2zscore.Hash)
                    
                    ## fc
                    fc <- ifelse(pvalue_whole>pvalue_relative, fc_whole, fc_relative)
                    ## store the result (the fc)
                    assign(currNode, fc, envir=node2fc.Hash)
                    
                    ## or
                    or <- ifelse(pvalue_whole>pvalue_relative, or_whole, or_relative)
                    ## store the result (the or)
                    assign(currNode, or, envir=node2or.Hash)
                    ## CIl
                    CIl <- ifelse(pvalue_whole>pvalue_relative, CIl_whole, CIl_relative)
                    ## stCIle the result (the CIl)
                    assign(currNode, CIl, envir=node2CIl.Hash)
                    ## CIu
                    CIu <- ifelse(pvalue_whole>pvalue_relative, CIu_whole, CIu_relative)
                    ## stCIue the result (the CIu)
                    assign(currNode, CIu, envir=node2CIu.Hash)                    
                    
                }
                
                if(verbose){
                    message(sprintf("\tAt level %d, there are %d nodes/terms", i, length(currNodes), appendLF=TRUE))
                }
            }
            
            ## the root always has p-value=1 and z-score=0
            root <- dnet::dDAGroot(subg)
            assign(root, 1, envir=node2pval.Hash)
            assign(root, 0, envir=node2zscore.Hash)
        
        }else if(ontology.algorithm=="elim"){
        
            ## sigNode2pval.Hash: key (node called significant), value (pvalue)
            sigNode2pval.Hash <- new.env(hash=TRUE, parent=emptyenv())
            ## ancNode2gene.Hash: key (node at ancestor), value (genes to be eliminated)
            ancNode2gene.Hash <- new.env(hash=TRUE, parent=emptyenv())
            
            if(is.null(elim.pvalue) || is.na(elim.pvalue) || elim.pvalue>1 || elim.pvalue<0){
                elim.pvalue <- 1e-2
            }
            pval.cutoff <- elim.pvalue

            #pval.cutoff <- 1e-2 / length(V(subg))
            
            for(i in nLevels:1) {
                currNodes <- get(as.character(i), envir=level2node.Hash, mode="character")
                currAnno <- gs[currNodes]
    
                ## update "ancNode2gene.Hash" for each node/term
                for(currNode in currNodes){
                    genes.term <- unique(unlist(gs[currNode]))
        
                    ## remove the genes (if any already marked) from annotations by the current node/term
                    if(exists(currNode, envir=ancNode2gene.Hash, mode="numeric")){
                        genes.elim <- get(currNode, envir=ancNode2gene.Hash, mode="numeric")
                        genes.term <- setdiff(genes.term, genes.elim)
                        #message(sprintf("\t\t%d %d", length(genes.elim), length(genes.term)), appendLF=TRUE)
                    }
        
                    ## do test
                    pvalue <- switch(test,
                        fisher =  doFisherTest(genes.group, genes.term, genes.universe),
                        hypergeo = doHypergeoTest(genes.group, genes.term, genes.universe, p.tail=p.tail),
                        binomial = doBinomialTest(genes.group, genes.term, genes.universe, p.tail=p.tail)
                    )
                    zscore <- zscoreHyper(genes.group, genes.term, genes.universe)
                    fc <- fcHyper(genes.group, genes.term, genes.universe)

                    vec <- orFisher(genes.group, genes.term, genes.universe)
                    or <- vec[1]
                    CIl <- vec[2]
                    CIu <- vec[3]
                    
                    ## store the result (the p-value)
                    assign(currNode, pvalue, envir=node2pval.Hash)
                    ## store the result (the z-score)
                    assign(currNode, zscore, envir=node2zscore.Hash)
                    ## store the result (the fc)
                    assign(currNode, fc, envir=node2fc.Hash)
                    
                    ## store the result (the or)
                    assign(currNode, or, envir=node2or.Hash)
                    ## store the result (the CIl)
                    assign(currNode, CIl, envir=node2CIl.Hash)
                    ## store the result (the CIu)
                    assign(currNode, CIu, envir=node2CIu.Hash)
                                                            
                    ## condition to update "ancNode2gene.Hash"
                    if(pvalue < pval.cutoff) {
                        ## mark the significant node
                        assign(currNode, pvalue, envir=sigNode2pval.Hash)

                        ## retrieve genes annotated by the significant node for the subsequent eliminating
                        elimGenesID <- currAnno[[currNode]]

                        ## find all the ancestors of the significant node
                        dag.ancestors <- dnet::dDAGinduce(subg, currNode, path.mode="all_paths")
                        ancestors <- setdiff(V(dag.ancestors)$name, currNode)
            
                        ## get only those ancestors that are already in "ancNode2gene.Hash"
                        oldAncestors2GenesID <- sapply(ancestors, function(ancestor){
                            if(exists(ancestor, envir=ancNode2gene.Hash, mode="numeric")){
                                get(ancestor, envir=ancNode2gene.Hash, mode='numeric')
                            }
                        })

                        ## add the new GenesID to the ancestors
                        newAncestors2GenesID <- lapply(oldAncestors2GenesID, function(oldGenes){
                            base::union(oldGenes, elimGenesID)
                        })

                        ## update the "ancNode2gene.Hash" table
                        if(length(newAncestors2GenesID) > 0){
                            sapply(names(newAncestors2GenesID), function(ancestor){
                                assign(ancestor, newAncestors2GenesID[[ancestor]], envir=ancNode2gene.Hash)
                            })
                        }
                    }
                }
    
                if(verbose){
                    num.signodes <- length(ls(sigNode2pval.Hash))
                    num.ancnodes <- length(ls(ancNode2gene.Hash))
                    num.elimgenes <- length(unique(unlist(as.list(ancNode2gene.Hash))))
                    message(sprintf("\tAt level %d, there are %d nodes/terms: up to %d significant nodes, %d ancestral nodes changed (%d genes/SNPs eliminated)", i, length(currNodes), num.signodes, num.ancnodes, num.elimgenes), appendLF=TRUE)
                }
            }
            
        }else if(ontology.algorithm=="lea"){
        
            ## node2pvalo.Hash: key (node called significant), value (original pvalue)
            node2pvalo.Hash <- new.env(hash=TRUE, parent=emptyenv())
        
            if(is.null(lea.depth) || is.na(lea.depth) || lea.depth<0){
                lea.depth <- 2
            }
            depth.cutoff <- as.integer(lea.depth)
            
            for(i in nLevels:1) {
                currNodes <- get(as.character(i), envir=level2node.Hash, mode="character")
                currAnno <- gs[currNodes]
                
                num.recalculate <- 0
                
                ## update "node2pval.Hash" for each node/term
                for(currNode in currNodes){
                    genes.term <- unique(unlist(gs[currNode]))
                    
                    ## do test
                    pvalue.old <- switch(test,
                        fisher =  doFisherTest(genes.group, genes.term, genes.universe),
                        hypergeo = doHypergeoTest(genes.group, genes.term, genes.universe, p.tail=p.tail),
                        binomial = doBinomialTest(genes.group, genes.term, genes.universe, p.tail=p.tail)
                    )
                    zscore.old <- zscoreHyper(genes.group, genes.term, genes.universe)
                    fc.old <- fcHyper(genes.group, genes.term, genes.universe)

                    vec.old <- orFisher(genes.group, genes.term, genes.universe)
                    or.old <- vec.old[1]
                    CIl.old <- vec.old[2]
                    CIu.old <- vec.old[3]
                                        
                    ## store the result (old pvalue)
                    assign(currNode, pvalue.old, envir=node2pvalo.Hash)
                    
                    ## get the outgoing neighbors/children (including self) that are reachable at most of given depth
                    neighs.out <- igraph::neighborhood(subg, order=depth.cutoff, nodes=currNode, mode="out")
                    adjNodes <- setdiff(V(subg)[unlist(neighs.out)]$name, currNode)
                        
                    if(length(adjNodes)!=0){
                        ## get children with the lower p-value
                        if(1){
                            pvalue.children <- sapply(adjNodes, function(child){
                                if(exists(child, envir=node2pvalo.Hash, mode="numeric")){
                                    get(child, envir=node2pvalo.Hash, mode="numeric")
                                }
                            })
                        }else{
                            pvalue.children <- sapply(adjNodes, function(child){
                                if(exists(child, envir=node2pval.Hash, mode="numeric")){
                                    get(child, envir=node2pval.Hash, mode="numeric")
                                }
                            })
                        }
                        
                        chNodes <- names(pvalue.children[pvalue.children < pvalue.old])
                        
                        ## whether there exist any children with the lower p-value
                        if(length(chNodes)>0){
                            num.recalculate <- num.recalculate + 1
                        
                            ## if yes, get genes that are annotated by children with the lower p-value
                            ## they will be removed
                            genes.elim <- unique(unlist(gs[chNodes]))
                            genes.term.new <- setdiff(genes.term, genes.elim)
                            
                            ## recalculate the significance
                            pvalue.new <- switch(test,
                                fisher =  doFisherTest(genes.group, genes.term.new, genes.universe),
                                hypergeo = doHypergeoTest(genes.group, genes.term.new, genes.universe, p.tail=p.tail),
                                binomial = doBinomialTest(genes.group, genes.term.new, genes.universe, p.tail=p.tail)
                            )
                            zscore.new <- zscoreHyper(genes.group, genes.term.new, genes.universe)
                            fc.new <- fcHyper(genes.group, genes.term.new, genes.universe)
                            
                            vec.new <- orFisher(genes.group, genes.term.new, genes.universe)
							or.new <- vec.new[1]
							CIl.new <- vec.new[2]
							CIu.new <- vec.new[3]
                                                        
                            ## take the maximum value of pvalue_new and the original pvalue
                            pvalue <- max(pvalue.new, pvalue.old)
                            
                            ## zscore
                            zscore <- ifelse(pvalue.new>pvalue.old, zscore.new, zscore.old)
                            
                            ## fc
                            fc <- ifelse(pvalue.new>pvalue.old, fc.new, fc.old)
                            
                            ## or
                            or <- ifelse(pvalue.new>pvalue.old, or.new, or.old)
                            ## CIl
                            CIl <- ifelse(pvalue.new>pvalue.old, CIl.new, CIl.old)
                            ## CIu
                            CIu <- ifelse(pvalue.new>pvalue.old, CIu.new, CIu.old)
                            
                        }else{
                            pvalue <- pvalue.old
                            zscore <- zscore.old
                            fc <- fc.old
                            
                            or <- or.old
                            CIl <- CIl.old
                            CIu <- CIu.old
                        }
                        
                    }else{
                        pvalue <- pvalue.old
                        zscore <- zscore.old
                        fc <- fc.old
                        
                        or <- or.old
                        CIl <- CIl.old
                        CIu <- CIu.old
                    }
                    
                    ## store the result (recalculated pvalue if have to)
                    assign(currNode, pvalue, envir=node2pval.Hash)
                    
                    ## zscore
                    assign(currNode, zscore, envir=node2zscore.Hash)
                    
                    ## fc
                    assign(currNode, fc, envir=node2fc.Hash)
                    
                    ## or
                    assign(currNode, or, envir=node2or.Hash)
                    ## CIl
                    assign(currNode, CIl, envir=node2CIl.Hash)
                    ## CIu
                    assign(currNode, CIu, envir=node2CIu.Hash)
                    
                }
    
                if(verbose){
                    message(sprintf("\tAt level %d, there are %d nodes/terms and %d being recalculated", i, length(currNodes), num.recalculate), appendLF=TRUE)
                }
            
            }
        }
        
        pvals <- unlist(as.list(node2pval.Hash))
        zscores <- unlist(as.list(node2zscore.Hash))
        fcs <- unlist(as.list(node2fc.Hash))
        
        ors <- unlist(as.list(node2or.Hash))
        CIl <- unlist(as.list(node2CIl.Hash))
        CIu <- unlist(as.list(node2CIu.Hash))
    
    }
	
	####################################################################################
	####################################################################################

    overlaps <- lapply(names(gs), function(term){
        genes.term <- unique(unlist(gs[term]))
        x <- intersect(genes.group, genes.term)
        x
    })
    names(overlaps) <- names(gs)
    ## for those with "min.overlap" overlaps will be processed and reported
    flag_filter <- sapply(overlaps, function(x) ifelse(length(x)>=min.overlap,TRUE,FALSE))
    
    if(sum(flag_filter)==0){
        #stop("It seems there are no terms meeting the specified 'size.range' and 'min.overlap'.\n")
        warnings("It seems there are no terms meeting the specified 'size.range' and 'min.overlap'.\n")
        return(NULL)
    }
    gs <- gs[flag_filter]
    overlaps <- overlaps[flag_filter]
    
    ## common terms
    common <- intersect(names(gs), names(zscores))
    ind_gs <- match(common,names(gs))
    ind_zscores <- match(common, names(zscores))
    
    ## restrict to the common terms (and sorted too)
    gs <- gs[ind_gs[!is.na(ind_gs)]]
    overlaps <- overlaps[ind_gs[!is.na(ind_gs)]]
    zscores <- zscores[ind_zscores[!is.na(ind_zscores)]]
    fcs <- fcs[ind_zscores[!is.na(ind_zscores)]]
    pvals <- pvals[ind_zscores[!is.na(ind_zscores)]]
    ors <- ors[ind_zscores[!is.na(ind_zscores)]]
    CIl <- CIl[ind_zscores[!is.na(ind_zscores)]]
    CIu <- CIu[ind_zscores[!is.na(ind_zscores)]]
    
    ## remove those with zscores=NA
    flag <- !is.na(zscores)
    gs <- gs[flag]
    overlaps <- overlaps[flag]
    zscores <- zscores[flag]
    fcs <- fcs[flag]
    pvals <- pvals[flag]
    ors <- ors[flag]
    CIl <- CIl[flag]
    CIu <- CIu[flag]
    
    if(length(pvals)==0){
        warnings("There are no pvals being calculated.\n")
        return(NULL)
    }
    
    ## update set_info
    ind <- match(rownames(set_info), names(pvals))
    set_info <- set_info[!is.na(ind),]
    
    zscores <- signif(zscores, digits=3)
    fcs <- signif(fcs, digits=3)
    pvals <- sapply(pvals, function(x) min(x,1))
    ors <- signif(ors, digits=3)
    CIl <- signif(CIl, digits=3)
    CIu <- signif(CIu, digits=3)
    
    if(verbose){
        now <- Sys.time()
        message(sprintf("Last, adjust the p-values for %d terms (with %d minimum overlaps) using the %s method (%s) ...", length(pvals), min.overlap, p.adjust.method, as.character(now)), appendLF=TRUE)
    }
    
    ## Adjust P-values for multiple comparisons
    adjpvals <- stats::p.adjust(pvals, method=p.adjust.method)
    
    pvals <- signif(pvals, digits=2)
    adjpvals <- sapply(adjpvals, function(x) min(x,1))
    adjpvals <- signif(adjpvals, digits=2)
    
    if(0){
    # force those zeros to be miminum of non-zeros
    tmp <- as.numeric(format(.Machine)['double.xmin'])
    tmp <- signif(tmp, digits=2)
    pvals[pvals < tmp] <- tmp
    adjpvals[adjpvals < tmp] <- tmp
    }
    
    # scientific notations
    pvals  <- sapply(pvals, function(x){
    	if(x < 0.1 & x!=0){
    		as.numeric(format(x,scientific=TRUE))
    	}else{
    		x
    	}
    })
    
    adjpvals <- sapply(adjpvals, function(x){
    	if(x < 0.1 & x!=0){
    		as.numeric(format(x,scientific=TRUE))
    	}else{
    		x
    	}
    })
    
    ################################
    cross <- matrix(0, nrow=length(overlaps), ncol=length(overlaps))
    if(length(overlaps)>=2){
		for(i in seq(1,length(overlaps)-1)){
			x1 <- overlaps[[i]]
			for(j in seq(i+1,length(overlaps))){
				x2 <- overlaps[[j]]
				cross[i,j] <- length(intersect(x1, x2))
				cross[j,i] <- length(intersect(x1, x2))
			}
		}
		colnames(cross) <- rownames(cross) <- names(overlaps)
		diag(cross) <- sapply(overlaps, length)
    }
    ####################################################################################
    
    eTerm <- list(term_info	 = set_info,
                  annotation = gs,
                  g 	   = subg,
                  data     = genes.group,
                  background=genes.universe,
                  overlap  = overlaps,
                  fc	   = fcs,
                  zscore   = zscores,
                  pvalue   = pvals,
                  adjp     = adjpvals,
                  or       = ors,
                  CIl      = CIl,
                  CIu	   = CIu,
                  cross	   = cross,
                  call     = match.call()
                 )
    class(eTerm) <- "eTerm"
    
    invisible(eTerm)
}
