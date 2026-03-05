#Metalog veritabanından indirdiğimiz metaphlan 4 verilerini R' da okuyoruz.
metaphlan4_human <- read_tsv(files_metaphlan["human"], col_types = cols(.default = "c"), na = c("", "NA"), locale = locale(encoding = "UTF-8"))
metaphlan4_ocean <- read_tsv(files_metaphlan["ocean"], col_types = cols(.default = "c"), na = c("", "NA"), locale = locale(encoding = "UTF-8"))
metaphlan4_env <- read_tsv(files_metaphlan["environment"], col_types = cols(.default = "c"), na = c("", "NA"), locale = locale(encoding = "UTF-8"))