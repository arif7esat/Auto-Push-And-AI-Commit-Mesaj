#!/bin/bash

# AutoPush - Basit Otomatik Git Push Sistemi
# 10 dakikada bir backup branch'e push yapar
# Mevcut dizindeki .git repository ile çalışır

# Script dizinini al ve ana dizine git
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"
LOGS_DIR="$SCRIPT_DIR/logs"

# Ana dizine git (git repository'nin olduğu yer)
cd "$PARENT_DIR"

# Logs klasörünü oluştur (eğer yoksa)
mkdir -p "$LOGS_DIR"

# Log dosyası
LOG_FILE="$LOGS_DIR/program_log"
PID_FILE="$LOGS_DIR/autopush.pid"

# Log fonksiyonu
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# PID'i log dosyasına kaydet
echo $$ > "$PID_FILE"
log_message "AutoPush başlatıldı. PID: $$"
log_message "Git repository dizini: $PARENT_DIR"
log_message "Logs klasörü: $LOGS_DIR"

# Ana döngü
while true; do
    # Git repo kontrolü
    if [ ! -d ".git" ]; then
        log_message "HATA: Bu dizin bir git repository değil!"
        exit 1
    fi
    
    # Backup branch kontrolü ve oluşturma
    if ! git branch | grep -q "Backup"; then
        log_message "Backup branch bulunamadı, oluşturuluyor..."
        git checkout -b Backup
        log_message "Backup branch oluşturuldu"
    else
        git checkout Backup
    fi
    
    # Değişiklikleri ekle
    git add .
    
    # Commit yap
    git commit -m "backup successful" --allow-empty
    
    # Push yap
    if git push origin Backup; then
        log_message "Backup başarıyla push edildi"
    else
        log_message "Push hatası oluştu"
    fi
    
    # 10 dakika bekle (600 saniye)
    sleep 600
done
