#!/bin/bash

# AutoPush Durum Kontrolü
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
echo -e "${CYAN}║                  ${WHITE}AutoPush Durum Kontrolü${CYAN}                  ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""

# PID dosyası var mı?
if [ -f "$LOGS_DIR/autopush.pid" ]; then
    PID=$(cat "$LOGS_DIR/autopush.pid")
    echo -e "${WHITE}📊 Process Bilgileri:${NC}"
    echo -e "  ${CYAN}PID dosyası:${NC} ${WHITE}$LOGS_DIR/autopush.pid${NC}"
    echo -e "  ${CYAN}PID:${NC} ${WHITE}$PID${NC}"
    
    # Process çalışıyor mu?
    if ps -p $PID > /dev/null 2>&1; then
        echo -e "${GREEN}✅ AutoPush çalışıyor!${NC}"
        
        # Process detayları
        echo -e "${WHITE}🔍 Process Detayları:${NC}"
        ps -p $PID -o pid,ppid,cmd,etime | sed 's/^/  /'
        
        # Log dosyası son satırları
        if [ -f "$LOGS_DIR/program_log" ]; then
            echo ""
            echo -e "${WHITE}📝 Son Log Kayıtları:${NC}"
            tail -5 "$LOGS_DIR/program_log" | sed 's/^/  /'
        fi
    else
        echo -e "${RED}❌ AutoPush çalışmıyor${NC}"
        echo -e "${BLUE}🧹 Eski PID dosyası temizleniyor...${NC}"
        rm -f "$LOGS_DIR/autopush.pid"
    fi
else
    echo -e "${RED}❌ PID dosyası bulunamadı${NC}"
    echo -e "${YELLOW}ℹ️  AutoPush çalışmıyor${NC}"
fi

echo ""
echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║                      ${WHITE}Git Durumu${CYAN}                          ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"

if [ -d ".git" ]; then
    echo -e "${GREEN}✅ Git repository bulundu${NC}"
    echo -e "${WHITE}📁 Repository bilgileri:${NC}"
    echo -e "  ${CYAN}Repository dizini:${NC} ${WHITE}$PARENT_DIR${NC}"
    echo -e "  ${CYAN}Mevcut branch:${NC} ${WHITE}$(git branch --show-current)${NC}"
    
    # Backup branch kontrolü
    if git branch | grep -q "Backup"; then
        echo -e "  ${CYAN}Backup branch:${NC} ${GREEN}✅ Bulundu${NC}"
    else
        echo -e "  ${CYAN}Backup branch:${NC} ${YELLOW}⚠️  Bulunamadı${NC}"
    fi
else
    echo -e "${RED}❌ Git repository bulunamadı${NC}"
fi
