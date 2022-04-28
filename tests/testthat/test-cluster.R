
test_that("cluster method", {
  require(raster)
  # read data
  hsi.file = system.file("extdata","wolf3_int.tif",package="habCluster")
  wolf = raster(hsi.file)

  clst = cluster(wolf, method = cluster_leiden, res = 80000, rp = 0.02)

  # check results are right objects
  testthat::expect_s4_class(clst$boundary,"SpatialPolygonsDataFrame")
  testthat::expect_s3_class(clst$communities ,"communities")

})
