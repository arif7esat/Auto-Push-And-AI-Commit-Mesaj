#!/bin/bash

# AutoPush Durdurucu
# Mevcut dizindeki .git repository ile çalışır

# Renk kodları
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"
LOGS_DIR="$SCRIPT_DIR/logs"

# Ana dizine git (git repository'nin olduğu yer)
cd "$PARENT_DIR"

echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║                    ${WHITE}AutoPush Durdurma${CYAN}                    ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""

# PID dosyası var mı?
if [ -f "$LOGS_DIR/autopush.pid" ]; then
    PID=$(cat "$LOGS_DIR/autopush.pid")
    echo -e "${WHITE}📊 Process Bilgileri:${NC}"
    echo -e "  ${CYAN}PID:${NC} ${WHITE}$PID${NC}"
    
    # Process çalışıyor mu?
    if ps -p $PID > /dev/null 2>&1; then
        echo -e "${YELLOW}⏹️  AutoPush durduruluyor...${NC}"
        kill $PID
        
        # Process durdu mu kontrol et
        sleep 2
        if ps -p $PID > /dev/null 2>&1; then
            echo -e "${RED}⚠️  Process durmadı, zorla kapatılıyor...${NC}"
            kill -9 $PID
        fi
        
        echo -e "${GREEN}✅ AutoPush başarıyla durduruldu!${NC}"
        
        # PID dosyasını temizle
        rm -f "$LOGS_DIR/autopush.pid"
        echo -e "${BLUE}🧹 PID dosyası temizlendi${NC}"
    else
        echo -e "${YELLOW}⚠️  AutoPush zaten çalışmıyor${NC}"
        rm -f "$LOGS_DIR/autopush.pid"
    fi
else
    echo -e "${RED}❌ PID dosyası bulunamadı${NC}"
    echo -e "${YELLOW}ℹ️  AutoPush çalışmıyor${NC}"
fi
