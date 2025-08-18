#!/bin/bash

# AutoPush Durdurucu
# Mevcut dizindeki .git repository ile çalışır

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"
LOGS_DIR="$SCRIPT_DIR/logs"

# Ana dizine git (git repository'nin olduğu yer)
cd "$PARENT_DIR"

echo "=== AutoPush Durdurma ==="

# PID dosyası var mı?
if [ -f "$LOGS_DIR/autopush.pid" ]; then
    PID=$(cat "$LOGS_DIR/autopush.pid")
    echo "PID: $PID"
    
    # Process çalışıyor mu?
    if ps -p $PID > /dev/null 2>&1; then
        echo "AutoPush durduruluyor..."
        kill $PID
        
        # Process durdu mu kontrol et
        sleep 2
        if ps -p $PID > /dev/null 2>&1; then
            echo "Process durmadı, zorla kapatılıyor..."
            kill -9 $PID
        fi
        
        echo "✅ AutoPush durduruldu"
        
        # PID dosyasını temizle
        rm -f "$LOGS_DIR/autopush.pid"
        echo "PID dosyası temizlendi"
    else
        echo "❌ AutoPush zaten çalışmıyor"
        rm -f "$LOGS_DIR/autopush.pid"
    fi
else
    echo "❌ PID dosyası bulunamadı"
    echo "AutoPush çalışmıyor"
fi
