
library(tidyverse)

# Prepare depto alternative names
x <- read_csv("../col-adm1-departments.csv")
x <- x %>% filter(!is.na(alternativeNames)) %>% select(id, alternativeNames)
y <- x %>% mutate(alternativeNames = strsplit(alternativeNames, "|", fixed = TRUE)) %>%
  unnest(alternativeNames)
write_csv(y, "../col-adm2-departments-altnames.csv")

x <- read_csv("../col-adm1-departments.csv") %>% select(-alternativeNames)

write_csv(x, "../col-adm2-departments.csv")


# Prepare municipio alternative names
x <- read_csv("tmp/col-adm2-municipalities.csv")
x <- x %>% filter(!is.na(alternativeNames)) %>% select(id, alternativeNames)
y <- x %>% mutate(alternativeNames = strsplit(alternativeNames, "|", fixed = TRUE)) %>%
  unnest(alternativeNames)
write_csv(y, "clean/col-adm2-municipalities-altnames.csv")


# prepare municipio regions

x <- yaml::yaml.load_file(system.file("dmaps/col.yaml",package = "dmaps"))$col_municipalities
reg <- x$regions

rl <- reg %>% map(function(x) data_frame(id = x$id)) %>% bind_rows(,.id = "region")
write_csv(rl, "clean/col-adm2-municipalities-regions.csv")


