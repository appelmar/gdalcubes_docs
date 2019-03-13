
Data cube objects can be serialized as a simple JSON formatted directed acyclich graph. Below, a data cube operation chain that selects two bands of an image collection, computes differences between the bands, and finally computes the median differences over time is serialized as a graph. This graph can be used to recreate the same operation chain.  
  

```
{
  "cube_type": "reduce",
  "in_cube": {
    "band_names": [
      "LST difference"
    ],
    "cube_type": "apply_pixel",
    "expr": [
      "0.02*(LST_DAY-LST_NIGHT)"
    ],
    "in_cube": {
      "bands": [
        "LST_DAY",
        "LST_NIGHT"
      ],
      "cube_type": "select_bands",
      "in_cube": {
        "chunk_size": [
          16,
          256,
          256
        ],
        "cube_type": "image_collection",
        "file": "MOD11A2.db",
        "view": {
          "aggregation": "first",
          "resampling": "near",
          "space": {
            "bottom": 4447802.0,
            "left": -1703607.0,
            "nx": 633,
            "ny": 413,
            "proj": "+proj=sinu +lon_0=0 +x_0=0 +y_0=0 +a=6371007.181 +b=6371007.181 +units=m +no_defs",
            "right": 1703607.0,
            "top": 6671703.0
          },
          "time": {
            "dt": "P1M",
            "t0": "2018-01",
            "t1": "2018-12"
          }
        }
      }
    }
  },
  "reducer": "median"
}
```

