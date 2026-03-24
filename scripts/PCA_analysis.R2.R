#PCA ANALİZİ

library(vegan)
library(ggplot2)

sample_metaphlan_matrix <- readRDS("outputs/sample_metaphlan_matrix.rds")
master_wide <- readRDS("outputs/master_wide.rds")

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
p <- ggplot(pca_df) +
  geom_point(aes(PC1, PC2, color = domain_group),
             size = 2, alpha = 0.8) +
  labs(x = "PC1",
       y = "PC2",
       color = "Domain",
       title = "PCA")


ggsave(plot = p, file = "pca_with_bray_curtis_metalog.pdf2", width = 297, height = 210, units = "mm")