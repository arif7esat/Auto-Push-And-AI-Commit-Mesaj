#!/bin/bash

# AutoPush Daemon Başlatıcı
# Bu script AutoPush'ı arka planda çalıştırır
# Mevcut dizindeki .git repository ile çalışır

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="$SCRIPT_DIR"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"
LOGS_DIR="$SCRIPT_DIR/logs"

# Ana dizine git (git repository'nin olduğu yer)
cd "$PARENT_DIR"

# Logs klasörünü oluştur (eğer yoksa)
mkdir -p "$LOGS_DIR"

# Zaten çalışıyor mu kontrol et
if [ -f "$LOGS_DIR/autopush.pid" ]; then
    PID=$(cat "$LOGS_DIR/autopush.pid")
    if ps -p $PID > /dev/null 2>&1; then
        echo "AutoPush zaten çalışıyor (PID: $PID)"
        exit 1
    else
        echo "Eski PID dosyası temizleniyor..."
        rm -f "$LOGS_DIR/autopush.pid"
    fi
fi

# AutoPush'ı arka planda başlat
nohup "$SCRIPTS_DIR/autopush.sh" > /dev/null 2>&1 &

# PID'i al ve log'a kaydet
sleep 1
if [ -f "$LOGS_DIR/autopush.pid" ]; then
    PID=$(cat "$LOGS_DIR/autopush.pid")
    echo "AutoPush başarıyla başlatıldı (PID: $PID)"
    echo "Log dosyası: $LOGS_DIR/program_log"
    echo "PID dosyası: $LOGS_DIR/autopush.pid"
    echo "Git Repository: $PARENT_DIR"
else
    echo "HATA: AutoPush başlatılamadı!"
    exit 1
fi
