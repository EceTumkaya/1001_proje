#Metalogdan indirdiğimiz verisetlerini okuyoruz. Buradaki kodların asıl amacı: R, bazı sayı değerlerini başka şeylere çevirmesin; hepsi aynı şekilde kalsın diye tüm verileri metin olarak okumamız.
human <- read_tsv(files_metalog["human"], col_types = cols(.default = "c"), na = c("", "NA"), locale = locale(encoding = "UTF-8"))
ocean <- read_tsv(files_metalog["ocean"], col_types = cols(.default = "c"), na = c("", "NA"), locale = locale(encoding = "UTF-8"))
env <- read_tsv(files_metalog["environment"], col_types = cols(.default = "c"), na = c("", "NA"), locale = locale(encoding = "UTF-8"))