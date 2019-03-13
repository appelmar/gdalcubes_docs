


Raster Data cubes are multidimensional arrays with dimensions band, datetime, y (latitude / northing), and x (longitude / easting). Cells of a cube
all have the same size in space and time with regard to a defined spatial reference system. Data cubes are different from image collections. 
Image collections are irregular in time, may contain gaps, and do not have a globally valid projection.

To create data cubes from image collections, we define a _data cube view_ (or simply _view_). Data cube views convert an image collection to a data cube by defining the 
basic shape of the cube, i.e. how we look at the data from an image collection. The data cube view includes
 
- the spatiotemporal extent, 
- the spatial reference system / map projection, 
- the spatiotemporal resolution either by number of or by the size of cells,
- a resampling algorithm used in [`gdalwarp`](https://www.gdal.org/gdalwarp.html), and 
- an aggregation algorithm that combines values of several images if they are located in the same cell of the target cube 

Views can be serialized as simple JSON object as in the example below. Note that there is no single correct view for a specific image collections. Instead, they are 
useful e.g. to run analysis an small subsets during model development before running on the full-resolution data.
  
```
{
  "aggregation" : "min",
  "resampling" : "bilinear",
  "space" :
  {
    "left" : 22.9,
    "right" : 23.1,
    "top" : -18.9,
    "bottom" : -19.1,
    "proj" : "EPSG:4326",
    "nx" : 500,
    "ny" : 500
  },
  "time" :
  {
    "t0" : "2017-01-01",
    "t1" : "2018-01-01",
    "dt" : "P1M"
  }
}
```

Data from images in a collection are read on-the-fly with regard to a specific data cube view. The target data cube is 
read chunk-wise, where chunk sizes in all directions _can_ be defined by the user. The procedure to read data of one chunk
is the following:

1. Find all GDAL datasets of the collection that intersect with the spatiotemporal extent of the chunk.
2. Iterate over all found datasets and do the following steps:
     1. Apply [gdalwarp](https://www.gdal.org/gdalwarp.html) to crop, reproject / transform, and resample the current dataset according to the spatiotemporal
extent of the current chunk and the data cube view.
     2. Store the result as an [in-memory GDAL dataset](https://www.gdal.org/frmt_mem.html).
     2. Copy the result to the in-memory chunk buffer (a four-dimensional array) at the correct temporal slice and the correct bands.
     3. If the chunk buffer already contains values at the target position, feed a pixel-wise aggregator (e.g. mean, median, min, max ) to combine
        pixel values from multiple images which are located at the same cell in the data cube.
3. Finalize the pixel-wise aggregator if needed (e.g. divide pixel values by $n$ for mean aggregation). 

Internally, chunk buffers are arrays of type double. Image data is however read according to their original data type. gdalwarp 
does the type conversion automatically, i.e. only the size of the chunk buffer in memory is larger but not the data that is transferred over the network for remotely stored imagery.
If input images contain lower-resolution overviews, these are used automatically by gdalwarp depending on the target resolution of the cube.

