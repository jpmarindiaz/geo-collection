
# World topojson

1. Download shapefile from http://www.naturalearthdata.com/downloads/50m-cultural-vectors
2. Export to topojson using http://mapshaper.org, simplyfied at 10%
3. Read in R, extract CSV data add code property and remove metadata from geojson.
4. Import again into mashaper to export it to topojson.
5. Manually adjust ids of regions.

Process in dev using R to generate regions and alternative names.
