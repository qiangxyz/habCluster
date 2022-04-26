
#' Create a graph from an raster according the connection between cells
#'
#' @param r  an object of raster. The value of each cell of the raster is the ‘smoothness’ to indicated how easy the cell connecting with neighbor cells.
#' @param res Numeric. Resample the input raster to given resolution and use the resampled raster to build graph. Set this to NULL if using the original resolution of of the input raster.
#'
#' @return a list with an graph and the resampled raster. The graph is igraph object, with cells as node and connections as weight
#' @export
#'
#' @examples
#' # read in habitat suitability data of wolf in Europe
#' library(raster)
#' hsi.file = system.file("extdata", "wolf3_int.tif", package = "habCluster")
#' wolf = raster(hsi.file)
#'
#' # build graph from raster
#' g = raster2Graph(wolf, 40000)

raster2Graph  <- function(r, res=NULL,silent=TRUE){

  r2 = NULL
  if(!is.null(res)){
    mask = raster::raster(ext = extent(r), crs = crs(r), res = res)
    if(!silent){
    cat('\nresampling...')
    }
    r2 = raster::resample(r, mask)
  }else{
    r2 = r
  }

  matrix = raster::as.matrix(r2)
  if(!silent){
  cat('\nextracting edges...')
  }
  edf = getEdgeDF(matrix)
  if(!silent){
  cat('\ncreate graph...')
  }
  g =list()
  g$graph = igraph::graph_from_data_frame(edf, directed=F)
  g$raster = r2
  return(g)
}

