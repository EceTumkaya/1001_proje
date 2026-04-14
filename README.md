# 1001_proje

Bu proje, modern ve antik metagenomik verileri işlemek, metadata tabloları oluşturmak ve bunlarla ilgili analizler yapmak için hazırlanmıştır.

## Kullanılan veriler

Projede iki ana veri kaynağı kullanılmaktadır:

1. **Metalog modern metadata verileri**
   - human
   - ocean
   - environmental

2. **Ancient Metagenome Directory verileri**
   - ancient host-associated samples
   - ancient environmental samples

Ayrıca MetaPhlAn çıktıları da tür matrisi vb. analizler için kullanılmaktadır.

NOT: Büyük veri boyutları nedeniyle bazı analizlerde örneklem (sampling) kullanılması gerekebilir.

## Klasör yapısı

- `data/` : indirilen ve işlenen veriler
- `outputs/` : üretilen çıktı dosyaları
- `scripts/` : analiz betikleri
- `png/` : görseller

## Kullanılacak betikler

- `download_data.R` metalog ve metaphlan verilerinin indirilmesi, okunması ve işlenmesi için kullanılacak betiktir (çalıştırıldığında aşağıda ayrı ayrı verilen metadata, metaphlan ve ancient çıktıları alınır). 

- `1001_analizler.qmd` oluşturulan işlenmiş veri setleri ile analizlerin yapıldığı betiktir.

- `master_tablo_olusturma.Rmd` işlenmiş antik ve modern verilerin aynı sütun formatında ve isimleri ile birleştirilmesi için kullanılan betiktir.

- `master_table_final_metadata_analysis.Rmd` son tablo üzerinden metadata analizlerinin yapıldığı betiktir.


## Betiklerin çalışma sırası

Metalog verisi ile çalışırken betikler aşağıdaki sırayla çalıştırılmalıdır:

1) `download_data.R`
2) `1001_analizler.qmd`
3) `master_tablo_olusturma.Rmd`
4) `master_table_final_metadata_analysis.Rmd`


### 1. Metadata verilerini indirme, okuma ve işleme
İlk olarak modern metadata ve gerekli diğer veri dosyaları hazırlanır.

- `download_data.R`

Bu betik:
- Metalog verilerini okur / indirir
- gerekli ham verileri hazırlar
- metalogdan alınan human, ocean ve environmental örneklerini birleştirir. 

Betik sonunda master_long, master_wide veri setleri oluşturulur (birleştirilmiş veri setleri).


### 2. MetaPhlAn verilerini indirme, okuma ve işleme
MetaPhlAn çıktıları okunur ve analiz için hazırlanır.

- `download_data.R`

Bu betik ile birlikte:
- metaphlan verileri okunur/indirilir
- `metaphlan_all` oluşturulur. Metaphlan human, ocean ve environmet verilerinin birleştirilmiş halidir. 


### 3. Antik verileri indirme ve okuma
Ancient metagenome dir üzerinden elde edeceğimiz ancient environmental ve ancient host-associated örnekleri indirilip okunur.

- `download_data.R` betiği kullanılır.

Bu betik ile birlikte:
`ancient_host` ve `ancient_env` dosyaları elde edilir.


### 4. Tür matrisi oluşturma
Analizlerde kullanılacak matrisi oluşturmak için:

- `make_metaphlan_species_matrix.R` betiği kullanılır (örneklerin tamamı kullanılarak oluşturulan tür matrisi için). 

- `1001_analizler.qmd` betiğinde 96. satır numarasından 203. satır numarasına kadar olan kod bloğu ise `pick_random_rows` fonksiyonu ile rastgele seçilmiş istediğimiz sayıda örnek kullanarak matris oluşturmak için kullanılır.


### 5. Ana analizler
Hazırlanan veri tabloları ile analizler yapılır.

- `1001_analizler.qmd` betiği kullanılır. 

- PCA analizi: `1001_analizler.qmd` içindeki 232 ve 287. satır numaraları arasındaki kod çalıştırılır. Eğer tüm örnekler ile hazırlanan matris ile işlem yapılmak istenirse `PCA_analysis.R2.R` betiği çalıştırılır.

- PcOA: önce 232-238 arasındaki kod çalıştırılır. Ardından 289-333. satır numaraları arasındaki kod çalıştırılır.

- Venn şeması: 335-364 arasındaki kod bloğu çalıştırılır.

- NMDS: 366-405 arasındaki kod bloğu çalıştırılır.


### 6. Metadata master tablo oluşturma
Antik ve modern örnekleri birleştiren son metadata tablosu oluşturulur.

- `master_tablo_olusturma.Rmd` betiği kullanılır.

Bu adım sonunda:
- `master_table_final` tablosu elde edilir.


### 7. Metadata özeti ve raporlama
Son tablo üzerinden özet tablolar ve metadata analizleri yapılır.

- `master_table_final_metadata_analysis.Rmd`

Bu betik:
- antik / modern örnek sayılarını
- Source1, Source2, Source3, Source4 dağılımlarını
- Örneklerin harita üzerindeki yerlerini

üretir.

## Önemli notlar

- Analiz dokümanları knit/render edilirken gerekli objelerin ya önce üretilmiş ya da dosyadan okunmuş olması gerekir.
- Final tablolar tekrar kullanılacaksa doğrudan ilgili çıktı dosyasından okunmalıdır.

## Çıktılar

Bu analiz sonucunda oluşturulan ana çıktı dosyası:

- outputs/master_table_final.tsv → tüm örnekleri ve metadata bilgilerini içeren final tablodur.
