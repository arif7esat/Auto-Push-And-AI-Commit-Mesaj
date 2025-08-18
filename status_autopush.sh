#!/bin/bash

# AutoPush Durum Kontrolü

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "=== AutoPush Durum Kontrolü ==="

# PID dosyası var mı?
if [ -f "autopush.pid" ]; then
    PID=$(cat autopush.pid)
    echo "PID dosyası: autopush.pid"
    echo "PID: $PID"
    
    # Process çalışıyor mu?
    if ps -p $PID > /dev/null 2>&1; then
        echo "✅ AutoPush çalışıyor (PID: $PID)"
        
        # Process detayları
        echo "Process detayları:"
        ps -p $PID -o pid,ppid,cmd,etime
        
        # Log dosyası son satırları
        if [ -f "program_log" ]; then
            echo ""
            echo "Son log kayıtları:"
            tail -5 program_log
        fi
    else
        echo "❌ AutoPush çalışmıyor (PID: $PID)"
        echo "Eski PID dosyası temizleniyor..."
        rm -f autopush.pid
    fi
else
    echo "❌ PID dosyası bulunamadı"
    echo "AutoPush çalışmıyor"
fi

echo ""
echo "=== Git Durumu ==="
if [ -d ".git" ]; then
    echo "Git repository: ✅"
    echo "Mevcut branch: $(git branch --show-current)"
    echo "Backup branch: $(git branch | grep Backup || echo 'Bulunamadı')"
else
    echo "Git repository: ❌"
fi
