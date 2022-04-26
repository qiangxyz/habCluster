

#' Clustering cells from a raster by Community Detection Algorithm according to the connections between them and return a cluster map
#'
#' @description This function use Community Detection Algorithm to find structure of raster and return a polygon representing the boundary of the clusters.
#' @param r an object of igraph, or raster. The value of each cell of the raster is the ‘smoothness’ to indicated how easy the cell connecting with neighbor cells.
#' @param method method from package igraph used to finding community structure. (see details below).
#' @param res Numeric. Resample the input raster to given resolution and use the resampled raster to find community structure. Set this to NULL if using the original resolution of of the input raster,given the parameter r is an object of raster.
#' @param cluster_resolution_parameter If cluster_leiden is chosen, use it to control the size of clusters. Higher resolution_parameter lead to more smaller clusters, while lower resolution_parameter lead to fewer larger clusters.
#' @param ... optional arguments to method
#'
#' @details Choice of the method used to finding community structure(see Mukerjee, 2014). The default method is cluster_louvain, but could also be methods like cluster_leiden, cluster_walktrap, or cluster_fast_greedy. If cluster_leiden is chosen, then we can use resolution_parameter to control the size of clusters. Higher resolution_parameter lead to more smaller clusters, while lower resolution_parameter lead to fewer larger clusters.
#' @return A SpatialPolygonsDataFrame object for boundaries of habitat clusters
#' and an object of communities defined in package igraph.
#'
#' @references
#' Mukerjee, S. (2021). A systematic comparison of community detection algorithms for measuring selective exposure in co-exposure networks. Sci Rep 11, 15218. https://doi.org/10.1038/s41598-021-94724-1\cr
#' Traag, V. A., Waltman, L., & van Eck, N. J. (2019). From Louvain to Leiden: guaranteeing well-connected communities. Scientific reports, 9(1), 5233. doi: 10.1038/s41598-019-41695-z\cr
#'
#' @export
#'
#' @examples
#' # read in habitat suitability data of wolf in Europe
#' library(raster)
#' hsi.file = system.file("extdata","wolf3_int.tif",package="habCluster")
#' wolf = raster(hsi.file)
#'
#' # find habitat cluster using Leiden Algorithm.
#' # Raster for habitat suitability will be resampled to 40 km, to reduce calculation amount.
#' # Set cluster_resolution_parameter to 0.02 to control the cluster size.
#' clst = cluster(wolf,method=cluster_leiden,res=40000,cluster_resolution_parameter=0.02)
#'
#' # plot the results
#' image(wolf,col=terrain.colors(100,rev = T),asp = 1)
#' plot(clst$boundary,add=T,asp=1,border="lightseagreen")

cluster <- function(r=NULL,method=cluster_louvain,res=NULL,cluster_resolution_parameter=1,silent=TRUE,...){

  g = raster2Graph(r,res,silent)

  if(!silent){
    cat('\nfinding clusters...')
  }

  if(identical(method, cluster_leiden)){
    clusters = cluster_leiden(g$graph,resolution_parameter=cluster_resolution_parameter,...)
  }else{
    clusters = method(g$graph,...)
  }
  if(!silent){
  cat('\npreparing results...')
  }

  cluster.id = membership(clusters)
  cell.id = as.integer(names(cluster.id))
  cluster.raster = g$raster
  cluster.raster[cell.id] = cluster.id
  boundaries = rasterToPolygons(cluster.raster,dissolve=TRUE)
  names(boundaries)= 'cluster.id'
  out=list()
  out$boundary = boundaries
  out$communities = clusters
  return(out)
}
