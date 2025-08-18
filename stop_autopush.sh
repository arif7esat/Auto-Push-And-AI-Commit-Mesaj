#!/bin/bash

# AutoPush Durdurucu

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "=== AutoPush Durdurma ==="

# PID dosyası var mı?
if [ -f "autopush.pid" ]; then
    PID=$(cat autopush.pid)
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
        rm -f autopush.pid
        echo "PID dosyası temizlendi"
    else
        echo "❌ AutoPush zaten çalışmıyor"
        rm -f autopush.pid
    fi
else
    echo "❌ PID dosyası bulunamadı"
    echo "AutoPush çalışmıyor"
fi
