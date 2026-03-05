#Metaphlan veri setlerini `metaphlan_all` adı ile birleştiriyoruz. `rbind` komutu birleştirme işlemini yapar.
metaphlan_all <- rbind(metaphlan4_human, metaphlan4_ocean, metaphlan4_env)