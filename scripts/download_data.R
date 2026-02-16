# Metalog veri indirme betigi
# Ece Tumkaya


#Başlangıçta klasörlerimizi oluşturuyoruz.
dir.create("data", showWarnings = FALSE)
dir.create("data/metalog/raw", recursive = TRUE, showWarnings = FALSE)
dir.create("data/metaphlan/raw", recursive = TRUE, showWarnings = FALSE)
dir.create("data/metaphlan/processed", recursive = TRUE, showWarnings = FALSE)
dir.create("data/metalog/processed", recursive = TRUE, showWarnings = FALSE)


#Öncelikleri gerekli paketleri çağırıyoruz.
library(curl)
library(tidyverse)


#Metalog verisetlerinin URL ve bilgisayarda kaydedilmesini istediğimiz klasöre kaydedilmesi için `links_metalog` ve `files_metalog` tanımladık.
links_metalog <- c(
  human = "https://metalog.embl.de/static/download/metadata/human_all_long_latest.tsv.gz",
  ocean = "https://metalog.embl.de/static/download/metadata/ocean_all_long_latest.tsv.gz",
  env   = "https://metalog.embl.de/static/download/metadata/environmental_all_long_latest.tsv.gz")

files_metalog <- c(
  human = "data/metalog/raw/human_all_long_latest.tsv.gz",
  ocean = "data/metalog/raw/ocean_all_long_latest.tsv.gz",
  environment   = "data/metalog/raw/environmental_all_long_latest.tsv.gz")


#Metalog verilerinin bilgisayarda yoksa indirilip, varsa bu işlemin atlanacağı bir for döngüsü oluşturuyoruz.
for(k in 1:length(links_metalog)) {
  
  if(!file.exists(files_metalog[k])) {
    message("İndiriliyor: ", k)
    curl_download(links_metalog[k], files_metalog[k])
  }
  else {
    message("Zaten var, indirme atlandı: ", k)
  }
}


#Metalogdan indirdiğimiz verisetlerini okuyoruz. Buradaki kodların asıl amacı: R, bazı sayı değerlerini başka şeylere çevirmesin; hepsi aynı şekilde kalsın diye tüm verileri metin olarak okumamız.
human <- read_tsv(files_metalog["human"], col_types = cols(.default = "c"), na = c("", "NA"), locale = locale(encoding = "UTF-8"))
ocean <- read_tsv(files_metalog["ocean"], col_types = cols(.default = "c"), na = c("", "NA"), locale = locale(encoding = "UTF-8"))
env <- read_tsv(files_metalog["environment"], col_types = cols(.default = "c"), na = c("", "NA"), locale = locale(encoding = "UTF-8"))



#Veri setlerindeki `curation_tier` değeri `core` yani elzem olanları listelemeliyiz. 
#Bunun nedeni: önemli sayılan `metadata_item` verileri, yüksek ihtimalle insan, okyanus ve çevre örneklerinde ortak olacaktır. 
#Hem elzem başlıkları öğreneceğiz hem de hepsinde ortak olan `metadata_item`lerı çıkarmamız kolaylaşacak. Her veri seti için sadece `core` filtresi yaparsak:
human_core <- human[human$curation_tier == "core", ]
ocean_core <- ocean[ocean$curation_tier == "core", ]
env_core <- env[env$curation_tier == "core", ]


#Şimdi de her listedeki ayrı başlıkları bir kesişime alarak hepsinde ortak olan `metadata_item` lari çıkaralım. Adı da `common_core` olsun.
common_core <- Reduce(intersect, list(unique(human_core$metadata_item), unique(ocean_core$metadata_item), unique(env_core$metadata_item)))


#Elimizde `common_core` adında, tüm veri setlerinde ortak olan metadataları içeren bir veri seti vardı. 
#Şimdi: daha sonra birleştirebilmek için human, ocean ve env veri setlerinde sadece `common core` ile ortak olan değerleri içeren yeni listeler oluşturacağız. 
#Bu sayede birleştirince çok fazla `NA` ile karşılaŞmayacağız.
human_core_filter <- human_core[human_core$metadata_item %in% common_core, ]
ocean_core_filter <- ocean_core[ocean_core$metadata_item %in% common_core, ]
env_core_filter <- env_core[env_core$metadata_item %in% common_core, ]


#Artık birleştirme aşamasına geçebiliriz. Birleştiriken ilk olarak ekstra bir sütun eklemeliyiz. 
#Bu sütun örneğin grubunu verecek ve ismi `domain_group` olsun.
human_core_filter$domain_group <- "human"
ocean_core_filter$domain_group <- "ocean"
env_core_filter$domain_group <- "env"


#Burada birleştireceğimiz tablolarda hangi sütunları istediğimizi `keep_cols` adlı vektöre tanımladık. Daha sonra kullanacağız.
keep_cols <- c("domain_group", "sample_alias", "metadata_item", "curation_tier", "value")


#Tabloları birleştiriyoruz.
master_long <- rbind(human_core_filter[,keep_cols],
                                 ocean_core_filter[,keep_cols],
                                 env_core_filter[,keep_cols])

#Satırlarda aynı bilgi birden fazla kez tekrarlanmış mı kontrol ediyoruz. sonuç 0 olmalı.
#dup_mask <- duplicated(master_long[, c("domain_group","sample_alias","metadata_item")])
#sum(dup_mask)


#`master_long` dosyasını, `master_wide` adı ile geniş formata çevirdik. `metadata_item` esas alınır.
master_wide <- spread(data = master_long, key = "metadata_item", value = "value")


#Oluşturduğumuz tabloyu kaydediyoruz.
write.csv(master_wide, "data/metalog/processed/master_common_core_wide.csv", row.names = FALSE)


#Metaphlan 4 verisetlerinin URL ve bilgisayarda kaydedilmesini istediğimiz klasöre kaydedilmesi için `links` ve `files` tanımladık.
links_metaphlan <- c(
  human = "https://metalog.embl.de/static/download/profiles/human_metaphlan4_latest.tsv.gz",
  ocean = "https://metalog.embl.de/static/download/profiles/ocean_metaphlan4_latest.tsv.gz",
  environment = "https://metalog.embl.de/static/download/profiles/environmental_metaphlan4_latest.tsv.gz")

files_metaphlan <- c(
  human = "data/metaphlan/raw/human_metaphlan4_2025-10-26.tsv.gz",
  ocean = "data/metaphlan/raw/ocean_metaphlan4_2025-10-26.tsv.gz",
  environment = "data/metaphlan/raw/environmental_metaphlan4_2025-10-26.tsv.gz")


#Metaphlan 4 verilerinin bilgisayarda yoksa indirilip, varsa bu işlemin atlanacağı bir for döngüsü oluşturuyotuz.
for(k in names(links_metaphlan)) {
  
  if(!file.exists(files_metaphlan[k])) {
    message("İndiriliyor: ", k)
    curl_download(links_metaphlan[k], files_metaphlan[k])
  }
  else {
    message("Zaten var, indirme atlandı: ", k)
  }
}

#Metalog veritabanından indirdiğimiz metaphlan 4 verilerini R' da okuyoruz.
metaphlan4_human <- read_tsv(files_metaphlan["human"], col_types = cols(.default = "c"), na = c("", "NA"), locale = locale(encoding = "UTF-8"))
metaphlan4_ocean <- read_tsv(files_metaphlan["ocean"], col_types = cols(.default = "c"), na = c("", "NA"), locale = locale(encoding = "UTF-8"))
metaphlan4_env <- read_tsv(files_metaphlan["environment"], col_types = cols(.default = "c"), na = c("", "NA"), locale = locale(encoding = "UTF-8"))


#Metaphlan veri setlerini `metaphlan_all` adı ile birleştiriyoruz. `rbind` komutu birleştirme işlemini yapar.
metaphlan_all <- rbind(metaphlan4_human, metaphlan4_ocean, metaphlan4_env)


#Analizlerde kullanacağımız büyük verileri tekrar tekrar indirmemek için diske kaydediyoruz:
saveRDS(master_long, "data/metalog/processed/master_long.rds")
saveRDS(master_wide, "data/metalog/processed/master_wide.rds")
saveRDS(metaphlan_all, "data/metaphlan/processed/metaphlan_all.rds")


ancient_host <- readr::read_tsv("data/ancient/ancientmetagenome-hostassociated_samples.tsv")
ancient_env <- readr::read_tsv("data/ancient/ancientmetagenome-environmental_samples.tsv")

