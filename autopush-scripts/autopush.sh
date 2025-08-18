#!/bin/bash

# AutoPush - Basit Otomatik Git Push Sistemi
# 10 dakikada bir backup branch'e push yapar
# Mevcut dizindeki .git repository ile çalışır

# Renk kodları
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

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

# Test modu kontrolü (TEST_MODE=1 yaparak 1 dakikada bir test edebilirsiniz)
TEST_MODE=${TEST_MODE:-0}
if [ "$TEST_MODE" = "1" ]; then
    SLEEP_TIME=60  # 1 dakika (test için)
    echo -e "${YELLOW}⚠️  TEST MODU AKTİF: 1 dakikada bir push yapılacak!${NC}"
else
    SLEEP_TIME=600  # 10 dakika (normal)
fi

# Log fonksiyonu
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# PID'i log dosyasına kaydet
echo $$ > "$PID_FILE"
log_message "AutoPush başlatıldı. PID: $$"
log_message "Git repository dizini: $PARENT_DIR"
log_message "Logs klasörü: $LOGS_DIR"
if [ "$TEST_MODE" = "1" ]; then
    log_message "TEST MODU: $SLEEP_TIME saniyede bir push"
else
    log_message "NORMAL MOD: $SLEEP_TIME saniyede bir push"
fi

echo -e "${GREEN}🚀 AutoPush başlatıldı!${NC}"
echo -e "${WHITE}📊 Başlangıç bilgileri:${NC}"
echo -e "  ${CYAN}PID:${NC} ${WHITE}$$${NC}"
echo -e "  ${CYAN}Git Repository:${NC} ${WHITE}$PARENT_DIR${NC}"
echo -e "  ${CYAN}Logs Klasörü:${NC} ${WHITE}$LOGS_DIR${NC}"
if [ "$TEST_MODE" = "1" ]; then
    echo -e "  ${YELLOW}Test Modu:${NC} ${WHITE}1 dakikada bir push${NC}"
else
    echo -e "  ${CYAN}Normal Mod:${NC} ${WHITE}10 dakikada bir push${NC}"
fi

# Ana döngü
while true; do
    # Git repo kontrolü
    if [ ! -d ".git" ]; then
        log_message "HATA: Bu dizin bir git repository değil!"
        echo -e "${RED}❌ HATA: Bu dizin bir git repository değil!${NC}"
        exit 1
    fi
    
    # Backup branch kontrolü ve oluşturma
    if ! git branch | grep -q "Backup"; then
        log_message "Backup branch bulunamadı, oluşturuluyor..."
        echo -e "${YELLOW}⚠️  Backup branch bulunamadı, oluşturuluyor...${NC}"
        git checkout -b Backup
        log_message "Backup branch oluşturuldu"
        echo -e "${GREEN}✅ Backup branch oluşturuldu${NC}"
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
        echo -e "${GREEN}✅ Backup başarıyla push edildi${NC}"
    else
        log_message "Push hatası oluştu"
        echo -e "${RED}❌ Push hatası oluştu${NC}"
    fi
    
    # Bekleme süresi
    if [ "$TEST_MODE" = "1" ]; then
        echo -e "${YELLOW}⏰ 1 dakika bekleniyor (TEST MODU)...${NC}"
    else
        echo -e "${BLUE}⏰ 10 dakika bekleniyor...${NC}"
    fi
    sleep $SLEEP_TIME
done
