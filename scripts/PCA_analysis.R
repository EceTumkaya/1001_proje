#PCA ANALİZİ

#Tüm örnekleri kullanabilmek için tanımlıyoruz.
sample_ids <- master_wide$sample_alias

library(vegan)
library(ggplot2)

# Tüm sample_alias'ları al
sample_ids <- master_wide$sample_alias

# Metaphlan species matrix
sample_metaphlan_matrix <- make_metaphlan_species_matrix(
  metaphlan_all = metaphlan_all,
  sample_ids    = sample_ids)

# domain bilgisi
sample_data <- unique(master_wide[, c("sample_alias", "domain_group")])

sample_data_for_metaphlan <- sample_data[
  sample_data$sample_alias %in% colnames(sample_metaphlan_matrix), ]

# Sıralamayı hizala
sample_data_for_metaphlan <- sample_data_for_metaphlan[
  match(colnames(sample_metaphlan_matrix),
        sample_data_for_metaphlan$sample_alias), ]

# Bray–Curtis
bray_curtis_dist <- vegdist(
  x = t(sample_metaphlan_matrix),
  method = "bray")

# PCA
pca <- prcomp(x = bray_curtis_dist)

# Sonuç dataframe
pca_df <- as.data.frame(pca$x)

pca_df$sample_alias <- rownames(pca_df)
pca_df$domain_group <- sample_data_for_metaphlan$domain_group

# Grafik
ggplot(pca_df) +
  geom_point(aes(PC1, PC2, color = domain_group),
             size = 2, alpha = 0.8) +
  labs(x = "PC1",
       y = "PC2",
       color = "Domain",
       title = "PCA")
