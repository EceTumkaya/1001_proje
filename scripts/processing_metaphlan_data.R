library(tidyverse)

files_metaphlan <- c(
  human = "data/metaphlan/raw/human_metaphlan4_2025-10-26.tsv.gz",
  ocean = "data/metaphlan/raw/ocean_metaphlan4_2025-10-26.tsv.gz",
  environment = "data/metaphlan/raw/environmental_metaphlan4_2025-10-26.tsv.gz")

#Metalog veritabanından indirdiğimiz metaphlan 4 verilerini R' da okuyoruz.
metaphlan4_human <- read_tsv(files_metaphlan["human"], col_types = cols(.default = "c"), na = c("", "NA"), locale = locale(encoding = "UTF-8"))
metaphlan4_ocean <- read_tsv(files_metaphlan["ocean"], col_types = cols(.default = "c"), na = c("", "NA"), locale = locale(encoding = "UTF-8"))
metaphlan4_env <- read_tsv(files_metaphlan["environment"], col_types = cols(.default = "c"), na = c("", "NA"), locale = locale(encoding = "UTF-8"))

#Metaphlan veri setlerini `metaphlan_all` adı ile birleştiriyoruz. `rbind` komutu birleştirme işlemini yapar.
metaphlan_all <- rbind(metaphlan4_human, metaphlan4_ocean, metaphlan4_env)

write.csv(x = metaphlan_all, file = "data/metaphlan/processed/metaphlan_all.csv")