
#Öncelikleri gerekli paketleri çağırıyoruz.
library(curl)

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