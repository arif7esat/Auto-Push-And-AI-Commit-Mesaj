#!/bin/bash

# AutoPush Durum Kontrolü
# Mevcut dizindeki .git repository ile çalışır

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"
LOGS_DIR="$SCRIPT_DIR/logs"

# Ana dizine git (git repository'nin olduğu yer)
cd "$PARENT_DIR"

echo "=== AutoPush Durum Kontrolü ==="

# PID dosyası var mı?
if [ -f "$LOGS_DIR/autopush.pid" ]; then
    PID=$(cat "$LOGS_DIR/autopush.pid")
    echo "PID dosyası: $LOGS_DIR/autopush.pid"
    echo "PID: $PID"
    
    # Process çalışıyor mu?
    if ps -p $PID > /dev/null 2>&1; then
        echo "✅ AutoPush çalışıyor (PID: $PID)"
        
        # Process detayları
        echo "Process detayları:"
        ps -p $PID -o pid,ppid,cmd,etime
        
        # Log dosyası son satırları
        if [ -f "$LOGS_DIR/program_log" ]; then
            echo ""
            echo "Son log kayıtları:"
            tail -5 "$LOGS_DIR/program_log"
        fi
    else
        echo "❌ AutoPush çalışmıyor (PID: $PID)"
        echo "Eski PID dosyası temizleniyor..."
        rm -f "$LOGS_DIR/autopush.pid"
    fi
else
    echo "❌ PID dosyası bulunamadı"
    echo "AutoPush çalışmıyor"
fi

echo ""
echo "=== Git Durumu ==="
if [ -d ".git" ]; then
    echo "Git repository: ✅"
    echo "Repository dizini: $PARENT_DIR"
    echo "Mevcut branch: $(git branch --show-current)"
    echo "Backup branch: $(git branch | grep Backup || echo 'Bulunamadı')"
else
    echo "Git repository: ❌"
fi
