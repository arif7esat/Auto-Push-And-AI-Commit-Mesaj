#!/bin/bash

# AutoPush Daemon Başlatıcı
# Bu script AutoPush'ı arka planda çalıştırır
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
SCRIPTS_DIR="$SCRIPT_DIR"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"
LOGS_DIR="$SCRIPT_DIR/logs"

# Test modu kontrolü
TEST_MODE=${TEST_MODE:-0}

# Ana dizine git (git repository'nin olduğu yer)
cd "$PARENT_DIR"

# Logs klasörünü oluştur (eğer yoksa)
mkdir -p "$LOGS_DIR"

# Zaten çalışıyor mu kontrol et
if [ -f "$LOGS_DIR/autopush.pid" ]; then
    PID=$(cat "$LOGS_DIR/autopush.pid")
    if ps -p $PID > /dev/null 2>&1; then
        echo -e "${YELLOW}⚠️  AutoPush zaten çalışıyor (PID: ${WHITE}$PID${YELLOW})${NC}"
        exit 1
    else
        echo -e "${BLUE}🧹 Eski PID dosyası temizleniyor...${NC}"
        rm -f "$LOGS_DIR/autopush.pid"
    fi
fi

# AutoPush'ı arka planda başlat
echo -e "${CYAN}🚀 AutoPush arka planda başlatılıyor...${NC}"
if [ "$TEST_MODE" = "1" ]; then
    echo -e "${YELLOW}⚠️  TEST MODU: 1 dakikada bir push yapılacak!${NC}"
    TEST_MODE=1 nohup "$SCRIPTS_DIR/autopush.sh" > /dev/null 2>&1 &
else
    echo -e "${CYAN}📅 NORMAL MOD: 10 dakikada bir push yapılacak${NC}"
    nohup "$SCRIPTS_DIR/autopush.sh" > /dev/null 2>&1 &
fi

# PID'i al ve log'a kaydet
sleep 1
if [ -f "$LOGS_DIR/autopush.pid" ]; then
    PID=$(cat "$LOGS_DIR/autopush.pid")
    echo -e "${GREEN}✅ AutoPush başarıyla başlatıldı!${NC}"
    echo -e "${WHITE}📊 Detaylar:${NC}"
    echo -e "  ${CYAN}PID:${NC} ${WHITE}$PID${NC}"
    echo -e "  ${CYAN}Log dosyası:${NC} ${WHITE}$LOGS_DIR/program_log${NC}"
    echo -e "  ${CYAN}PID dosyası:${NC} ${WHITE}$LOGS_DIR/autopush.pid${NC}"
    echo -e "  ${CYAN}Git Repository:${NC} ${WHITE}$PARENT_DIR${NC}"
    if [ "$TEST_MODE" = "1" ]; then
        echo -e "  ${YELLOW}Test Modu:${NC} ${WHITE}1 dakikada bir push${NC}"
    else
        echo -e "  ${CYAN}Normal Mod:${NC} ${WHITE}10 dakikada bir push${NC}"
    fi
else
    echo -e "${RED}❌ HATA: AutoPush başlatılamadı!${NC}"
    exit 1
fi
