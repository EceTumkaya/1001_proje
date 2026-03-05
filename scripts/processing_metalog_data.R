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

#`master_long` dosyasını, `master_wide` adı ile geniş formata çevirdik. `metadata_item` esas alınır.
master_wide <- spread(data = master_long, key = "metadata_item", value = "value")

#Oluşturduğumuz tabloyu kaydediyoruz.
write.csv(master_wide, "data/metalog/processed/master_common_core_wide.csv", row.names = FALSE)