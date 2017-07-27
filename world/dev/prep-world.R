
library(geojsonio)
library(tidyverse)
library(ggplot2)



# 3.

# ## Read topojson in R, extract CSV data add code property and remove metadata from geojson.
#
# tj <- topojson_read("original/ne_50m_admin_0_countries.topojson")
# d <- tj@data
# tj@data <- tj@data %>% mutate(code = iso_a3) %>% select(code, name, name_long)
# geojson_write(tj, file = "original/ne_50m_admin_0_countries.min.geojson")
# # transform geojson again to topojson using mapshaper
# #archivo.min.json
# # Add ids manually


tj <- topojson_read("original/ne_50m_admin_0_countries.topojson")

d_altnames <- d %>% mutate(code = iso_a3) %>%
  select(code,sovereignt,type, geounit,subunit,name,name_long,brk_name,abbrev,
         formal_en,formal_fr, name_sort, name_alt, iso_a2, iso_a3) %>%
  filter(code != "-99")
z <- d_altnames %>%
  gather(var, altname, -code) %>%
  arrange(code)
z <- z %>%
  filter(!var %in% c("sovereignt","type"), altname != "") %>%
  select(-var, id = code, altname) %>% distinct()
write_csv(z, "clean/world-countries-altnames.csv")

d_regions <- d %>% mutate(id = iso_a3) %>%
  select(code, continent, region_un, subregion, region_wb)
d_reg_continents <- d_regions %>%
  select(region = continent, id) %>%
  arrange(region)
d_reg_un <- d_regions %>%
  select(region = region_un, id) %>%
  mutate(region = paste("UN", region)) %>%
  arrange(region)
d_reg_un_sub <- d_regions %>%
  select(region = subregion, id) %>%
  mutate(region = paste("UN Subregion", region)) %>%
  arrange(region)
d_reg_wb <- d_regions %>%
  select(region = region_wb, id) %>%
  mutate(region = paste("WB", region)) %>%
  arrange(region)
d_regs <- bind_rows(d_reg_continents,d_reg_un,d_reg_un_sub,d_reg_wb)
write_csv(d_regs, "clean/world-countries-regions.csv")

d_codes <- d %>% select(id = code) %>% mutate(.id = 1:nrow(.))
d_polygons <- fortify(tj) %>% mutate(.id = as.numeric(id)+1) %>% select(-id)
d_polygons <- left_join(d_polygons, d_codes) %>% select(-.id)
write_csv(d_polygons, "clean/world-countries-polygons.csv")

dLatLon <- d_polygons %>% filter(id != "-99") %>%
  group_by(id) %>% summarise(lat = mean(lat), lon = mean(long))

dinfo <- d %>% select(id = code, name, name_long)
dinfo <- left_join(dinfo, dLatLon)

write_csv(dinfo, "clean/world-countries.csv")



