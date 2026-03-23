make_metaphlan_species_matrix <- function(metaphlan_all, sample_ids) {
  
  # 1) Gerekli sütunlar var mı kontrol edelim.
  needed_cols <- c("sample_alias", "clade_name", "rel_abund")
  missing <- setdiff(needed_cols, colnames(metaphlan_all))
  if (length(missing) > 0) {
    stop(paste(
      "metaphlan_all içinde eksik sütun(lar) var:",
      paste(missing, collapse = ", ")
    ))
  }
  
  # 2) sample_ids gerçekten metaphlan_all içinde var mı kontrol edelim.
  common_ids <- intersect(sample_ids, metaphlan_all$sample_alias)
  if (length(common_ids) == 0) {
    stop("Verdiğin sample_ids, metaphlan_all içinde bulunamadı.")
  }
  
  if (length(common_ids) < length(sample_ids)) {
    warning("Bazı sample_ids Metaphlan verisinde yok, sadece bulunanlar kullanılacak.")
  }
  
  # 3) Metaphlan long tablosundan sadece bu örnekleri alalım.
  metaphlan_subset_long <- metaphlan_all[
    metaphlan_all$sample_alias %in% common_ids,
    ,
    drop = FALSE
  ]
  # metaphlan_subset_long: seçilen örneklere ait long satırlar
  
  # 4) Sadece species ('s__') düzeyini alıp önünden 's__''i kaldıralım. 
  metaphlan_subset_long_species <- metaphlan_subset_long[
    grepl("s__", metaphlan_subset_long$clade_name),
    ,
    drop = FALSE
  ]
  # grepl("s__") → clade_name içinde tür düzeyi (s__) geçen satırlar
  
  metaphlan_subset_long_species$clade_name <- gsub(
    "s__",
    "",
    metaphlan_subset_long_species$clade_name
  )
  # gsub("s__", "") → clade_name içindeki s__ önekini silmek için.
  
  # rel_abund karakter geldiyse sayıya çevirelim. (ileride numeric matrix için)
  metaphlan_subset_long_species$rel_abund <- as.numeric(
    metaphlan_subset_long_species$rel_abund
  )
  
  # Aynı (sample_alias, clade_name) birden fazla kez gelmişse rel_abund'ları topla
  metaphlan_subset_long_species <- aggregate(rel_abund ~ sample_alias + clade_name,   data = metaphlan_subset_long_species, FUN  = sum)
  
  # 5) Long → Wide çevirelim.
  metaphlan_subset_wide_species <- spread(
    data  = metaphlan_subset_long_species,
    key   = "sample_alias",   
    value = "rel_abund"       
  )
  # metaphlan_subset_wide_species: satırlar = türler, sütunlar = seçilen örnekler
  
  # 6) Tibble ise klasik data.frame'e çevirelim. 
  metaphlan_subset_wide_species <- as.data.frame(
    metaphlan_subset_wide_species,
    stringsAsFactors = FALSE
  )
  
  # 7) Tür isimlerini satır ismi yapıp clade_name sütununu silelim.
  rownames(metaphlan_subset_wide_species) <- metaphlan_subset_wide_species$clade_name
  metaphlan_subset_wide_species$clade_name <- NULL
  
  # 8) Data.frame → numeric matrix
  metaphlan_subset_wide_species <- as.matrix(metaphlan_subset_wide_species)
  
  # 9) NA'ları 0 yapalım. 
  metaphlan_subset_wide_species[
    is.na(metaphlan_subset_wide_species)
  ] <- 0
  
  # 10) Matrisi çağıralım.
  return(metaphlan_subset_wide_species)
}

master_wide <- read.csv(file = "data/metalog/processed/master_common_core_wide.csv")
metaphlan_all <- read.csv(file = "data/metaphlan/processed/metaphlan_all.csv")

#Tüm örnekleri kullanabilmek için tanımlıyoruz.
sample_ids <- master_wide$sample_alias

# Tüm sample_alias'ları al
sample_ids <- master_wide$sample_alias

# Metaphlan species matrix
sample_metaphlan_matrix <- make_metaphlan_species_matrix(
  metaphlan_all = metaphlan_all,
  sample_ids    = sample_ids)

dir.create("outputs", showWarnings = FALSE)
saveRDS(sample_metaphlan_matrix, "outputs/sample_metaphlan_matrix.rds")
saveRDS(master_wide, "outputs/master_wide.rds")