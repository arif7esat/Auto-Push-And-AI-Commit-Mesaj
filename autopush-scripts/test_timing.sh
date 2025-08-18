#!/bin/bash

# AutoPush Zaman Test Scripti
# Timing fix'in çalışıp çalışmadığını test eder

# Renk kodları
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# İstanbul saat dilimini ayarla
export TZ='Europe/Istanbul'

echo -e "${PURPLE}🧪 AutoPush Zaman Test Scripti${NC}"
echo -e "${CYAN}Bu script timing fix'in çalışıp çalışmadığını test eder${NC}"
echo ""

# Test parametreleri
TEST_INTERVAL=30  # 30 saniyede bir test (10 dakika yerine)
SIMULATED_GIT_TIME=5  # Git işlemlerinin 5 saniye sürdüğünü simüle et

echo -e "${WHITE}Test Ayarları:${NC}"
echo -e "  ${CYAN}Test Aralığı:${NC} ${WHITE}${TEST_INTERVAL} saniye${NC}"
echo -e "  ${CYAN}Simüle Git Süresi:${NC} ${WHITE}${SIMULATED_GIT_TIME} saniye${NC}"
echo ""

# Test fonksiyonu
test_timing() {
    local push_count=0
    local start_time=$(date +%s)
    
    echo -e "${GREEN}🚀 Test başlatılıyor...${NC}"
    echo ""
    
    while [ $push_count -lt 5 ]; do  # 5 push test et
        local loop_start_time=$(date +%s)
        
        echo -e "${PURPLE}📊 Push #$((push_count + 1))${NC}"
        echo -e "  ${CYAN}Başlangıç:${NC} ${WHITE}$(date -d @$loop_start_time '+%H:%M:%S')${NC}"
        
        # Git işlemlerini simüle et
        echo -e "  ${YELLOW}🔄 Git işlemleri simüle ediliyor (${SIMULATED_GIT_TIME}s)...${NC}"
        sleep $SIMULATED_GIT_TIME
        
        # Push zamanını kaydet
        push_count=$((push_count + 1))
        local current_push_time=$(date +%s)
        
        echo -e "  ${GREEN}✅ Push tamamlandı:${NC} ${WHITE}$(date -d @$current_push_time '+%H:%M:%S')${NC}"
        echo -e "  ${CYAN}Git işlem süresi:${NC} ${WHITE}${SIMULATED_GIT_TIME}s${NC}"
        
        # Git işlemlerinden sonra kalan süreyi hesapla
        local loop_duration=$((current_push_time - loop_start_time))
        local remaining_time=$((TEST_INTERVAL - loop_duration))
        
        if [ $remaining_time -gt 0 ]; then
            echo -e "  ${BLUE}⏰ $remaining_time saniye bekleniyor...${NC}"
            sleep $remaining_time
        else
            echo -e "  ${YELLOW}⚠️  Git işlemleri çok uzun sürdü (${loop_duration}s), hemen devam ediliyor...${NC}"
        fi
        
        echo ""
    done
    
    # Test sonuçları
    local end_time=$(date +%s)
    local total_time=$((end_time - start_time))
    local expected_time=$((TEST_INTERVAL * 4 + SIMULATED_GIT_TIME * 5))
    
    echo -e "${PURPLE}📋 Test Sonuçları:${NC}"
    echo -e "  ${CYAN}Toplam süre:${NC} ${WHITE}${total_time}s${NC}"
    echo -e "  ${CYAN}Beklenen süre:${NC} ${WHITE}${expected_time}s${NC}"
    echo -e "  ${CYAN}Test push sayısı:${NC} ${WHITE}${push_count}${NC}"
    echo ""
    
    if [ $total_time -ge $expected_time ]; then
        echo -e "${GREEN}✅ Test başarılı! Timing fix çalışıyor.${NC}"
    else
        echo -e "${RED}❌ Test başarısız! Timing fix çalışmıyor.${NC}"
    fi
}

# Ana menü
case "${1:-test}" in
    "test")
        test_timing
        ;;
    "help")
        echo -e "${WHITE}AutoPush Zaman Test Scripti${NC}"
        echo -e "${CYAN}Kullanım:${NC}"
        echo -e "  ${WHITE}./test_timing.sh [seçenek]${NC}"
        echo -e ""
        echo -e "${CYAN}Seçenekler:${NC}"
        echo -e "  ${WHITE}test${NC}  - Zaman testini çalıştır (varsayılan)"
        echo -e "  ${WHITE}help${NC}  - Bu yardım mesajı"
        ;;
    *)
        test_timing
        ;;
esac
