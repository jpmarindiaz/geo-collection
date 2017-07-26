
library(tidyverse)


x <- read_csv("col-adm2-municipalities.csv")

x <- x %>% filter(!is.na(alternativeNames)) %>% select(id, alternativeNames)


