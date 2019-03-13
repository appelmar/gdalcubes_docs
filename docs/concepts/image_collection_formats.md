
gdalcubes comes with a function to create an image collection from a set of GDAL dataset references as strings. This function
however, must know some details about the structure of a specific EO data product:

- How to derive date/time from images?
- Which GDAL dataset references include data for specific bands / variables?
- Which GDAL dataset references belong to the same image?

These questions are answered as a set of regular expressions on the GDAL dataset references in an _image collection format_. 
Image collection formats are JSON descriptions of how the data is structured. gdalcubes comes with some predefined
formats. An example format for Sentinel 2 level 1C data can is presented below.


```
{
  "description" : 
      "Image collection format for Sentinel 2 Level 1C data as 
       downloaded from the Copernicus Open Access Hub, expects 
       a list of file paths as input. The format works on original 
       ZIP compressed as well as uncompressed imagery.",
  "tags" : ["Sentinel", "Copernicus", "ESA", "TOA"],
  "pattern" : ".+/IMG_DATA/.+\\.jp2",
  "images" : {
    "pattern" : ".*/(.+)\\.SAFE.*"
  },
  "datetime" : {
    "pattern" : ".*MSIL1C_(.+?)_.*",
    "format" : "%Y%m%dT%H%M%S"
  },
  "bands" : {
    "B01" : { "nodata" : 0, "pattern" : ".+_B01\\.jp2"},
    "B02" : { "nodata" : 0, "pattern" : ".+_B02\\.jp2"},
    "B03" : { "nodata" : 0, "pattern" : ".+_B03\\.jp2"},
    "B04" : { "nodata" : 0, "pattern" : ".+_B04\\.jp2"},
    "B05" : { "nodata" : 0, "pattern" : ".+_B05\\.jp2"},
    "B06" : { "nodata" : 0, "pattern" : ".+_B06\\.jp2"},
    "B07" : { "nodata" : 0, "pattern" : ".+_B07\\.jp2"},
    "B08" : { "nodata" : 0, "pattern" : ".+_B08\\.jp2"},
    "B8A" : { "nodata" : 0, "pattern" : ".+_B8A\\.jp2"},
    "B09" : { "nodata" : 0, "pattern" : ".+_B09\\.jp2"},
    "B10" : { "nodata" : 0, "pattern" : ".+_B10\\.jp2"},
    "B11" : { "nodata" : 0, "pattern" : ".+_B11\\.jp2"},
    "B12" : { "nodata" : 0, "pattern" : ".+_B12\\.jp2"}
  }
}
```


gdalcubes then automatically creates the image collection file from a set of input datasets and a collection format. A few predefined collection formats are included in the library (see https://github.com/appelmar/gdalcubes/tree/master/formats).



