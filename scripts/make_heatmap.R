library(pheatmap)

# Verileri oku
sample_metaphlan_matrix <- readRDS("outputs/sample_metaphlan_matrix.rds")
master_wide <- readRDS("outputs/master_wide.rds")

# Sample alias ve domain bilgisi
sample_data <- unique(master_wide[, c("sample_alias", "domain_group")])

# Matrixte bulunan sample'ları seç
sample_data_for_metaphlan <- sample_data[
  sample_data$sample_alias %in% colnames(sample_metaphlan_matrix), ]

# Matrix kolon sırasına göre sample bilgilerini hizala
sample_data_for_metaphlan <- sample_data_for_metaphlan[
  match(colnames(sample_metaphlan_matrix),
        sample_data_for_metaphlan$sample_alias), ]

# Annotation tablosu oluştur
annotation_col <- data.frame(
  domain_group = sample_data_for_metaphlan$domain_group
)
rownames(annotation_col) <- sample_data_for_metaphlan$sample_alias

# Heatmap çok büyük olmasın diye 200 sample seç
set.seed(42)
selected_samples <- sample(colnames(sample_metaphlan_matrix), 5000)

sample_metaphlan_matrix_small <- sample_metaphlan_matrix[, selected_samples]

annotation_col_small <- annotation_col[selected_samples, , drop = FALSE]

# PDF çıktısı al
pdf("heatmap.pdf", width = 12, height = 8)

pheatmap(
  log10(sample_metaphlan_matrix_small + 0.1),
  annotation_col = annotation_col_small,
  show_rownames = FALSE,
  show_colnames = FALSE
)

dev.off()