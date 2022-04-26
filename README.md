
<!-- README.md is generated from README.Rmd. Please edit that file -->

# habCluster

<!-- badges: start -->
<!-- badges: end -->

Based on landscape connectivity, use Community Detection Algorithm to
find structure of raster and return a polygon representing the boundary
of the clusters.

## Installation

You can install the development version of habCluster from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("qiangxyz/habCluster")
```

## Example

This is a basic example which shows you how to find the cluster of
lands:

``` r
library(raster)
library(habCluster)
```

Read in habitat suitability index (HSI) data of wolf in Europe. The HSI
values of the cells in the raster indicate how smoothly the wolfs can
moved in the cells, and can be used to represent the connection between
cells as habitat.

``` r
hsi.file = system.file("extdata","wolf3_int.tif",package="habCluster")
wolf = raster(hsi.file)
```

Find habitat cluster using Leiden Algorithm. Raster for habitat
suitability will be resampled to 40 km (40000m), to reduce calculation
amount.Set cluster_resolution_parameter to 0.02 to control the cluster
size.

``` r
clst = cluster(wolf,method=cluster_leiden,res=40000,cluster_resolution_parameter=0.02,silent = FALSE)
#> 
#> resampling...
#> extracting edges...
#> create graph...
#> finding clusters...
#> preparing results...
```

You can also embed plots, for example:

<img src="man/figures/README-cluster-1.png" width="100%" />

## How to Cite

Zhang, C., D. Qiang\*, et al, (in review). Identifying Geographical
Boundary among Intraspecific Units Using Community Detection Algorithm.
