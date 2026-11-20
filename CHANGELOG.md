# Değişiklik günlüğü

Her güncelleme burada en yenisi üstte olacak şekilde listelenir. Ayrıntılı kod farkları için GitHub'daki commit geçmişine bakın.

## 2026-11-20 · Doğal animasyon ve atletik vücut
**Koşu**
- Yeni koşu döngüsü: kalça, diz ve ayak bileği hareketleri, gerçek koşudaki adım fazlarına (basma, itiş, salınım) göre hesaplanıyor. Yürüyüşten sprinte kadar adım uzunluğu ve ritim hıza göre değişiyor.
- Gövde hızla birlikte öne eğiliyor, dirsekler yaklaşık 80° bükük, kollar bacakların tersine sallanıyor, kalça ve omuzlar karşılıklı dönüyor, baş sabit kalıyor.
- Yere basan ayak kaymıyor, adım uzunluğu bacak hareketinden hesaplanıyor. Vücudun en alttaki noktası her karede zemine oturtuluyor; yerde yatan oyuncular zemine gömülmüyor ya da havada kalmıyor.
- Top sürme: top her iki adımda bir sağ ayakla itiliyor, açılıyor, oyuncu yetişip yeniden dokunuyor.
- Dururken nefes alma ve ağırlık aktarma; oyuncular başlarını topa çeviriyor. Kaleci bekleme pozisyonunda dizleri bükük, eller önde.

**Temas ve sonrası**
- Kayarak müdahale: savunmacı destek bacağını büküp kalçası ve uyluğunun yanından yere iniyor, yerde kayarken temas ediyor, yavaşlayıp eliyle dayanıyor ve tek dizinin üstünden kalkıyor.
- Düşüşler aşamalı: denge kaybı → eller ve dizler yere → yüzüstü ya da sırtüstü → yana dönüp bacağını tutma. Ağır müdahalede oyuncu sırtüstü dönüp bileğini tutarak yerde kalıyor; değilse dört ayak üstünden ya da oturduğu yerden diz üstüne, oradan ayağa kalkıyor. Hiçbir geçiş dik duruştan geçerek "zıplamıyor".
- Ayağa basılan oyuncu yere oturup ayağını tutuyor; yüzüne darbe alan dizlerine çöküp yana yatıyor; itilen oyuncu sendeleyip öne düşüyor; dengesini kaybedenin kolları çırpınıyor.
- "Üzerine sıçrama"da diz, rakibin vücudundaki temas noktasının yüksekliğine çıkacak kadar sıçrıyor.
- Temas noktası doğruluğu arttı: rastgele 160 senaryoda uzuv ile temas noktası arasındaki mesafe, en kötü %10'da 0,47 m'den 0,20 m'ye indi.

**Vücut**
- Atletik V gövde: daha geniş sırt ve omuz, dolgun göğüs ve deltoid, dar bel, kalın boyun. Kafa vücuda göre biraz küçültüldü (yüzler aynı).
- Forma, şort ve tozlukta kumaş kıvrımı dokusu ve kumaş parlaması.

## 2026-11-20 · Reklam panoları kaldırıldı, tribünler sadeleşti
- Saha kenarındaki reklam panoları ve tribün katları arasındaki yazılı LED şerit tamamen kaldırıldı; şeridin yerinde düz koyu bir duvar var.
- Tribünler takım renklerine göre yeniden boyandı: uzun kenarlar ve hücum edilen kalenin arkası hücum eden takımın kırmızısı, diğer kale arkası savunan takımın mavisi. Seyircilerin yaklaşık dörtte üçü takım rengi giyiyor, kalanı beyaz ve koyu nötr kıyafetler.

## 2026-11-20 · GitHub sayfasından tek tıkla açılış
- README'nin en üstüne **Uygulamayı tarayıcıda aç** bağlantısı ve düğmesi eklendi; indirme gerekmediği açıkça yazıldı.
- Depo açıklamasına (About) site adresi ve konu etiketleri eklendi.

## 2026-11-20 · Yapay zekâ özellikleri kaldırıldı
- "Claude ile çözümle" ve "Claude'a sor" kaldırıldı. Uygulama artık yalnızca pozisyonu canlandırıyor ve kurallara göre değerlendiriyor; hiçbir yapay zekâ hizmetine bağlanmıyor.
- **Anlatımı çözümle** düğmesi her zaman cihazdaki anahtar kelime çözümleyicisini kullanıyor.
- Pozisyonu tartışmak isteyen, **Kararı kopyala** ile metni alıp kendi kullandığı araca sorabilir (README'ye not eklendi).
- Bu dosya (CHANGELOG.md) eklendi.

## 2026-11-20 · İlk yayın
- Kurulabilir web uygulaması (PWA): telefon, tablet ve bilgisayarda tarayıcıdan açılır, ana ekrana kurulur, ilk açılıştan sonra internetsiz çalışır.
- GitHub Pages üzerinden yayın (`docs/` klasörü).
- Gerçekçi 3D görünüm: stadyum, ışıklar, oyuncu modelleri ve koşu animasyonu.
- Sadeleştirilmiş soru formu: kısa etiketler, "Ek ayrıntılar" ve "Gol şansı" grupları.
- Herkese açık sürümde gerçek oyuncu isimleri varsayılan olarak kapalı; **Görünüm** menüsünden açılabilir.
