# 🟩 Color Block Jam — Renkli Blok Eşleştirme & Rota Bulmaca Oyunu

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white" alt="Dart">
  <img src="https://img.shields.io/badge/HTML5_Canvas-JavaScript-F7DF1E?logo=javascript&logoColor=black" alt="JS">
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-lightgrey" alt="Platform">
  <img src="https://img.shields.io/badge/License-MIT-green" alt="License">
</p>

> **"Blokları doğru rotaya yönlendir, sıkışıklığı çöz ve toplayıcıları doldur!"**  
> Color Block Jam, popüler "Block Jam" bulmaca mekaniğini akıcı 2D ızgara fiziği, engel temizleme ve renkli toplayıcı dinamikleriyle sunan eğlenceli bir mobil & web mantık bulmaca oyunudur.

---

## 🎯 Oyun Mantığı ve Kuralları

1. **6x6 Grid Haritası:** Oyun alanı üzerinde farklı renklerde yönlü bloklar (`Block`) ve kenarlarda bekleyen renk toplayıcıları (`Collector`) yer alır.
2. **Yol Açma & Kaydırma:** Önü açık olan bloklar ilgili renkteki toplayıcıya doğru hareket eder. Önünde başka bir blok varsa kilitlenir ("Jam").
3. **Maksimum Verimlilik:** En az hamle (`moves`) sayısıyla tahtadaki tüm blokları temizleyerek bir sonraki seviyeye geçin.
4. **Çoklu Seviye & Zorluk:** İlerleyen bölümlerde artan blok sayısı, daralan çıkış kapıları ve çift renkli özel engeller.

---

## 🧩 Mimari ve Klasör Yapısı

```bash
color_block_jam/
├── lib/
│   ├── game_engine.dart       # 6x6 grid, hareket validasyonu ve seviye mantığı
│   ├── models.dart            # Block, Collector, LevelData ve Renk paletleri
│   └── main.dart              # Flutter UI, hamle sayacı ve level paneli
├── web_demo/                  # Sıfır kurulumla tarayıcıda oynanabilir HTML5 Canvas sürümü
│   ├── index.html
│   ├── style.css
│   └── game.js
├── pubspec.yaml               # Bağımlılıklar (Provider)
└── README.md
```

---

## ✨ Teknik Vurgular

- ⚡ **Saf Dart/Flutter Fizik Mantığı:** Harici ağır kütüphaneler olmadan hızlı yanıt veren grid koordinat algoritması.
- 🎨 **Canlı & Modern Renk Teorisi:** Neon ve pastel renklerle desteklenmiş modern mobil UI.
- 🌐 **Çifte Sürüm (Flutter + HTML5):** Hem Flutter mobil platformlarında hem de `web_demo` klasöründeki saf HTML5/JS motoruyla tarayıcıda anında çalıştırılabilme esnekliği.

---

## 🚀 Kurulum ve Çalıştırma

### Flutter Sürümü:
```bash
# 1. Repoyu klonlayın
git clone https://github.com/siladgn/color-block-jam.git
cd color-block-jam

# 2. Paketleri yükleyin
flutter pub get

# 3. Çalıştırın
flutter run
# veya Web'de test edin:
flutter run -d chrome
```

### HTML5 / Web Demo Sürümü:
`web_demo/index.html` dosyasını doğrudan herhangi bir tarayıcıda çift tıklayarak açabilir ve anında oynayabilirsiniz!

---

## 📄 Lisans

Bu proje [MIT](LICENSE) lisansı ile lisanslanmıştır.
