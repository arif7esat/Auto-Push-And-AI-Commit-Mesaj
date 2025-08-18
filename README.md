# AutoPush - Basit Otomatik Git Push Sistemi

Bu proje, 10 dakikada bir otomatik olarak git repository'nizi Backup branch'ine push yapan basit bir sistemdir.

## Özellikler

- ✅ **10 dakikada bir otomatik push**
- ✅ **Backup branch'e push yapar** (main branch'e dokunmaz)
- ✅ **Backup branch yoksa otomatik oluşturur**
- ✅ **Arka planda çalışır** (daemon)
- ✅ **Terminal kapansa bile çalışmaya devam eder**
- ✅ **Log tutar** (`autopush-scripts/logs/program_log` dosyasında)
- ✅ **PID bilgisini saklar** (`autopush-scripts/logs/autopush.pid` dosyasında)
- ✅ **Basit commit mesajı**: "backup successful"
- ✅ **Düzenli klasör yapısı** (scriptler `autopush-scripts/` klasöründe)
- ✅ **Logs klasörü** (tüm log ve PID dosyaları tek yerde)
- ❌ **AI commit mesajları yok**
- ❌ **Gemini API yok**
- ❌ **Karmaşık özellikler yok**

## Kurulum

1. Scriptleri çalıştırılabilir yapın:
```bash
chmod +x autopush autopush-scripts/*.sh
```

2. Git repository'nizde olduğunuzdan emin olun:
```bash
git status
```

## Kullanım

### AutoPush'ı Başlat
```bash
./autopush start
```

### Durumu Kontrol Et
```bash
./autopush status
```

### AutoPush'ı Durdur
```bash
./autopush stop
```

### Yeniden Başlat
```bash
./autopush restart
```

### Yardım
```bash
./autopush
```

## Dosya Yapısı

```
Auto-Push-And-AI-Commit-Mesaj/
├── autopush                    # Ana kontrol scripti
├── autopush-scripts/           # Script klasörü
│   ├── autopush.sh            # Ana AutoPush scripti (daemon)
│   ├── start_autopush.sh      # Başlatma scripti
│   ├── stop_autopush.sh       # Durdurma scripti
│   ├── status_autopush.sh     # Durum kontrol scripti
│   └── logs/                  # Logs klasörü
│       ├── program_log        # Log dosyası
│       └── autopush.pid      # PID dosyası
├── .git/                      # Git repository
└── README.md                  # Bu dosya
```

## Nasıl Çalışır

1. `./autopush start` komutu ile AutoPush başlatılır
2. Script arka planda çalışmaya başlar
3. Her 10 dakikada bir:
   - Backup branch'e geçer (yoksa oluşturur)
   - Tüm değişiklikleri ekler
   - "backup successful" mesajı ile commit yapar
   - Backup branch'e push yapar
4. Log dosyasına tüm işlemler kaydedilir
5. PID dosyasında process ID saklanır

## Güvenlik

- Sadece Backup branch'e push yapar
- Main branch'e dokunmaz
- Git repository kontrolü yapar
- Hata durumunda log tutar

## Sorun Giderme

### AutoPush çalışmıyor
```bash
./autopush status
```

### Log dosyasını kontrol et
```bash
tail -f autopush-scripts/logs/program_log
```

### Process'i zorla durdur
```bash
./autopush stop
```

## Not

Bu sistem sadece basit backup amaçlıdır. Production ortamında kullanmadan önce test edin.

## Avantajlar

- **Düzenli yapı**: Tüm scriptler `autopush-scripts/` klasöründe
- **Logs klasörü**: Tüm log ve PID dosyaları `autopush-scripts/logs/` klasöründe
- **Kolay bakım**: Scriptleri ayrı klasörde tutmak bakımı kolaylaştırır
- **Temiz ana dizin**: Ana dizinde sadece gerekli dosyalar
- **Modüler yapı**: Her script kendi görevini yerine getirir
- **Merkezi log yönetimi**: Tüm loglar tek klasörde
