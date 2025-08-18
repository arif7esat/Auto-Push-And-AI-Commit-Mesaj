# AutoPush - Gelişmiş Otomatik Git Push Sistemi

Otomatik olarak git repository'nizi backup branch'e push yapan, sistem verimini izleyen ve İstanbul saatini kullanan gelişmiş bir sistem.

## 🚀 Özellikler

- **Otomatik Backup**: 10 dakikada bir otomatik git push
- **Sistem Verimi İzleme**: CPU, RAM ve disk kullanımını takip eder
- **İstanbul Saati**: Tüm loglar ve commit'ler İstanbul saatine göre
- **Performans Raporları**: Detaylı sistem istatistikleri
- **Gerçek Zamanlı İzleme**: Canlı performans takibi
- **Test Modu**: 1 dakikada bir test için TEST_MODE=1

## 📁 Dosya Yapısı

```
Auto-Push-And-AI-Commit-Mesaj/
├── autopush-scripts/
│   ├── autopush.sh              # Ana program
│   ├── monitor_performance.sh   # Performans izleme
│   ├── start_autopush.sh        # Program başlatma
│   ├── stop_autopush.sh         # Program durdurma
│   ├── status_autopush.sh       # Durum kontrolü
│   └── logs/                    # Log dosyaları
│       ├── program_log          # Program logları
│       ├── performance_log      # Performans verileri
│       ├── system_stats         # Sistem istatistikleri
│       └── autopush.pid         # Process ID
├── README.md
└── test_file.txt
```

## 🛠️ Kurulum ve Kullanım

### 1. Program Başlatma
```bash
cd autopush-scripts
./start_autopush.sh
```

### 2. Test Modu (1 dakikada bir)
```bash
TEST_MODE=1 ./start_autopush.sh
```

### 3. Performans İzleme
```bash
./monitor_performance.sh [seçenek]
```

**Seçenekler:**
- `live` - Gerçek zamanlı izleme
- `stats` - Güncel sistem istatistikleri
- `history` - Performans geçmişi
- `summary` - Özet rapor
- `status` - Program durumu
- `help` - Yardım

### 4. Program Durdurma
```bash
./stop_autopush.sh
```

### 5. Durum Kontrolü
```bash
./status_autopush.sh
```

## 📊 Performans İzleme

Program çalışırken şu verileri toplar:

- **CPU Kullanımı**: Yüzde olarak
- **RAM Kullanımı**: Yüzde ve MB olarak
- **Disk Kullanımı**: Yüzde olarak
- **Çalışma Süresi**: Program ne kadar süredir çalışıyor
- **Yük Ortalaması**: Sistem yükü
- **Push Sayıları**: Başarılı ve başarısız push'lar

## 🕐 Saat Dilimi

Tüm loglar, commit mesajları ve tarih bilgileri **İstanbul saati (Europe/Istanbul)** kullanılarak kaydedilir.

## 📈 Log Dosyaları

- **`program_log`**: Program çalışma logları
- **`performance_log`**: Sistem performans verileri (her push'ta)
- **`system_stats`**: Güncel sistem istatistikleri
- **`performance_report_YYYYMMDD_HHMMSS.txt`**: Her 10 push'ta bir oluşturulan detaylı rapor

## 🔧 Test Modu

Test modunda program 1 dakikada bir push yapar:

```bash
export TEST_MODE=1
./start_autopush.sh
```

## 📋 Sistem Gereksinimleri

- Linux/Unix sistemi
- Bash shell
- Git kurulu
- `top`, `free`, `df` komutları mevcut
- `uptime` komutu mevcut

## 🚨 Güvenlik

- Program sadece mevcut dizindeki git repository ile çalışır
- Backup branch'e push yapar (ana branch'e dokunmaz)
- PID dosyası ile process kontrolü yapar

## 💡 Ek Özellikler

- **Otomatik Backup Branch**: Backup branch yoksa otomatik oluşturur
- **Hata Sayacı**: Başarısız push'ları takip eder
- **Döngü Süresi**: Her push işleminin ne kadar sürdüğünü ölçer
- **Toplam Çalışma Süresi**: Programın ne kadar süredir çalıştığını gösterir

## 📞 Destek

Herhangi bir sorun yaşarsanız log dosyalarını kontrol edin:

```bash
# Program logları
tail -f autopush-scripts/logs/program_log

# Performans verileri
tail -f autopush-scripts/logs/performance_log

# Sistem istatistikleri
cat autopush-scripts/logs/system_stats
```

---

**Not**: Program çalışırken `sleep` komutu kullanır, bu sayede beklerken CPU kullanımı %0 olur ve sistem kaynaklarını korur.
