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