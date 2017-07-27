
library(geojsonio)
library(tidyverse)
library(ggplot2)


w <-  topojson_read("world-countries.topojson")
w <- geojson_read("world.geojson")

w$type
w$features[[1]]$geometry$type
wd <- w@data
w@polygons[[1]]


tj <- topojson_read("ne_50m_admin_0_countries.topojson")
tj@data <- tj@data %>% mutate(code = iso_a3) %>% select(code, name, name_long)
length(tj@polygons)
tj@polygons <- map2(tj@polygons,dCode$code, function(x,y){
  x@ID <- as.character(y)
  x@id <- as.character(y)
  #str(x)
  x
})

tj@polygons[[1]]
tj@bbox
tj@polygons[[1]]@Polygons
tj@polygons[[1]]

geojson_write(tj, file = "ne_50m_admin_0_countries.geojson")



dtj <- fortify(tj) %>% mutate(id = as.numeric(id)+1)
str(dtj)

data <- tj@data %>% mutate(code = iso_a3)

x <- data %>% select(code, name, name_long)

length(unique(data$iso_a2))
length(unique(data$sovereignt))

dCode <- data %>% select(code, name = sovereignt) %>% mutate(id = 1:nrow(.))
str(dCode)
dCode <- dCode %>% mop::fct_to_chr()
d <- left_join(dtj, dCode) %>% mutate(id = code) %>% select(-code)

write_csv(d, "clean/world-countries-polygons.csv")

dLatLon <- d %>% group_by(id) %>% summarise(lat = mean(lat), lon = mean(long))

