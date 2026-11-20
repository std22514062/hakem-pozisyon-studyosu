# Hakem Pozisyon Stüdyosu

Pozisyonu anlat, 3D canlandır, IFAB Oyun Kuralları 2026/27'ye göre değerlendir.

Faul, elle oynama, ofsayt ve oyunu geciktirme pozisyonlarını adım adım tarif edersin. Uygulama pozisyonu 3D olarak canlandırır: temas anını iki açıdan tekrar gösterir, kare kare ilerletmene izin verir. Sonra karar kartını çıkarır: karar, yeniden başlama, disiplin cezası, ilgili kurallar ve VAR notu.

Telefon, tablet ve bilgisayarda tarayıcıdan açılır. Ana ekrana uygulama olarak kurulabilir ve ilk açılıştan sonra internetsiz çalışır.

> Eğitim ve anlatım aracıdır; sahadaki nihai karar hakeme aittir. Kural özetleri IFAB 2026/27 metninden Türkçe yorumlanmıştır. Resmi metin için [theifab.com](https://www.theifab.com/laws-of-the-game-documents/) adresine bakın.

## Cihaza kurma
- **Android (Chrome) ve bilgisayar (Chrome/Edge):** Sayfanın üstündeki **Uygulamayı yükle** düğmesi ya da adres çubuğundaki yükle simgesi.
- **iPhone/iPad (Safari):** **Uygulamayı yükle** düğmesi yönergeyi gösterir: Paylaş → Ana Ekrana Ekle → Ekle.

## Proje yapısı
| Yol | İçerik |
| --- | --- |
| `pozisyon-studyosu.html` | Uygulamanın kendisi: soru formu, kural motoru, 3D sahne. Düzeltmeler burada yapılır. |
| `pwa-src/` | Kurulum parçaları: `manifest.webmanifest`, servis çalışanı `sw.js`, yükleme düğmesi `pwa.js` / `pwa.css`, ikon. |
| `build-pwa.ps1` | İkisini birleştirip yayınlanacak `docs/` klasörünü üretir; PNG ikonları da çizer. |
| `docs/` | GitHub Pages'in yayınladığı hazır site (elle düzenlenmez, betikle üretilir). |
| `CHANGELOG.md` | Sürüm sürüm neyin değiştiği. |

## Güncelleme
1. `pozisyon-studyosu.html` dosyasında değişikliği yap.
2. Derle: `powershell -ExecutionPolicy Bypass -File build-pwa.ps1`
3. Gönder: `git add -A`, `git commit -m "…"`, `git push`
4. GitHub Pages bir iki dakika içinde yeni sürümü yayınlar. Uygulamayı kurmuş olanlar bir sonraki açılışta "Yeni sürüm hazır · Yenile" bildirimini görür.

## Notlar
- Uygulama bir yapay zekâ aracı değildir; yalnızca pozisyonu canlandırır ve kurallara göre değerlendirir. Anlatım, cihazda çalışan bir anahtar kelime çözümleyicisiyle forma aktarılır; hiçbir veri dışarı gönderilmez. Pozisyonu tartışmak isteyen, **Kararı kopyala** ile metni alıp kendi kullandığı yapay zekâ aracına sorabilir.
- Oyuncu isimleri varsayılan olarak kapalıdır. **Görünüm → Oyuncu isimleri** seçeneğiyle açılabilir.
- 3D kütüphanesi: [three.js](https://threejs.org) r147 (MIT lisansı), jsDelivr üzerinden yüklenir ve çevrimdışı kullanım için önbelleğe alınır.
