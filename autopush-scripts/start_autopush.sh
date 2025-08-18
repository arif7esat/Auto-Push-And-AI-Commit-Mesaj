#!/bin/bash

# AutoPush Daemon Başlatıcı
# Bu script AutoPush'ı arka planda çalıştırır
# Mevcut dizindeki .git repository ile çalışır

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="$SCRIPT_DIR"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"

# Ana dizine git (git repository'nin olduğu yer)
cd "$PARENT_DIR"

# Zaten çalışıyor mu kontrol et
if [ -f "autopush.pid" ]; then
    PID=$(cat autopush.pid)
    if ps -p $PID > /dev/null 2>&1; then
        echo "AutoPush zaten çalışıyor (PID: $PID)"
        exit 1
    else
        echo "Eski PID dosyası temizleniyor..."
        rm -f autopush.pid
    fi
fi

# AutoPush'ı arka planda başlat
nohup "$SCRIPTS_DIR/autopush.sh" > /dev/null 2>&1 &

# PID'i al ve log'a kaydet
sleep 1
if [ -f "autopush.pid" ]; then
    PID=$(cat autopush.pid)
    echo "AutoPush başarıyla başlatıldı (PID: $PID)"
    echo "Log dosyası: program_log"
    echo "PID dosyası: autopush.pid"
    echo "Git Repository: $PARENT_DIR"
else
    echo "HATA: AutoPush başlatılamadı!"
    exit 1
fi
