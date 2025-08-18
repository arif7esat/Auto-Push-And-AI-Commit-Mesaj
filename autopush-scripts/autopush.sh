#!/bin/bash

# AutoPush - Gelişmiş Otomatik Git Push Sistemi
# 10 dakikada bir backup branch'e push yapar
# Sistem verimini izler ve İstanbul saatini kullanır
# Mevcut dizindeki .git repository ile çalışır

# Renk kodları
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Script dizinini al ve ana dizine git
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"
LOGS_DIR="$SCRIPT_DIR/logs"

# Ana dizine git (git repository'nin olduğu yer)
cd "$PARENT_DIR"

# Logs klasörünü oluştur (eğer yoksa)
mkdir -p "$LOGS_DIR"

# Log dosyaları
LOG_FILE="$LOGS_DIR/program_log"
PERFORMANCE_LOG="$LOGS_DIR/performance_log"
PID_FILE="$LOGS_DIR/autopush.pid"
STATS_FILE="$LOGS_DIR/system_stats"

# İstanbul saat dilimini ayarla
export TZ='Europe/Istanbul'

# Test modu kontrolü (TEST_MODE=1 yaparak 1 dakikada bir test edebilirsiniz)
TEST_MODE=${TEST_MODE:-0}
if [ "$TEST_MODE" = "1" ]; then
    SLEEP_TIME=60  # 1 dakika (test için)
    echo -e "${YELLOW}⚠️  TEST MODU AKTİF: 1 dakikada bir push yapılacak!${NC}"
else
    SLEEP_TIME=600  # 10 dakika (normal)
fi



# Sistem verimi ölçme fonksiyonu
get_system_stats() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
    local memory_info=$(free -m | grep Mem)
    local total_mem=$(echo $memory_info | awk '{print $2}')
    local used_mem=$(echo $memory_info | awk '{print $3}')
    local free_mem=$(echo $memory_info | awk '{print $4}')
    local memory_usage=$((used_mem * 100 / total_mem))
    local disk_usage=$(df -h . | tail -1 | awk '{print $5}' | cut -d'%' -f1)
    
    echo "$timestamp|CPU:$cpu_usage%|RAM:$memory_usage%|DISK:$disk_usage%|FREE_RAM:${free_mem}MB" >> "$PERFORMANCE_LOG"
    
    # Detaylı sistem istatistikleri
    cat > "$STATS_FILE" << EOF
=== SİSTEM İSTATİSTİKLERİ (${timestamp}) ===
CPU Kullanımı: ${cpu_usage}%
RAM Kullanımı: ${memory_usage}% (${used_mem}MB / ${total_mem}MB)
Boş RAM: ${free_mem}MB
Disk Kullanımı: ${disk_usage}%
Çalışan Süre: $(uptime -p)
Yük Ortalaması: $(uptime | awk -F'load average:' '{print $2}')
EOF
}

# Log fonksiyonu (İstanbul saati ile)
log_message() {
    echo "$(TZ='Europe/Istanbul' date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Performans raporu oluşturma
create_performance_report() {
    local report_file="$LOGS_DIR/performance_report_$(date '+%Y%m%d_%H%M%S').txt"
    
    echo "=== AUTOPUSH PERFORMANS RAPORU ===" > "$report_file"
    echo "Oluşturulma: $(TZ='Europe/Istanbul' date '+%Y-%m-%d %H:%M:%S')" >> "$report_file"
    echo "Çalışma Süresi: $(uptime -p)" >> "$report_file"
    echo "" >> "$report_file"
    
    echo "=== SON 10 PERFORMANS KAYDI ===" >> "$report_file"
    tail -10 "$PERFORMANCE_LOG" >> "$report_file"
    
    echo "" >> "$report_file"
    echo "=== SİSTEM ÖZETİ ===" >> "$report_file"
    cat "$STATS_FILE" >> "$report_file"
    
    echo -e "${PURPLE}📊 Performans raporu oluşturuldu: $report_file${NC}"
}

# PID'i log dosyasına kaydet
echo $$ > "$PID_FILE"
log_message "AutoPush başlatıldı. PID: $$"
log_message "Git repository dizini: $PARENT_DIR"
log_message "Logs klasörü: $LOGS_DIR"
log_message "Saat dilimi: Europe/Istanbul"
if [ "$TEST_MODE" = "1" ]; then
    log_message "TEST MODU: $SLEEP_TIME saniyede bir push"
else
    log_message "NORMAL MOD: $SLEEP_TIME saniyede bir push"
fi

# İlk sistem verimi ölçümü
get_system_stats

echo -e "${GREEN}🚀 AutoPush başlatıldı!${NC}"
echo -e "${WHITE}📊 Başlangıç bilgileri:${NC}"
echo -e "  ${CYAN}PID:${NC} ${WHITE}$$${NC}"
echo -e "  ${CYAN}Git Repository:${NC} ${WHITE}$PARENT_DIR${NC}"
echo -e "  ${CYAN}Logs Klasörü:${NC} ${WHITE}$LOGS_DIR${NC}"
echo -e "  ${CYAN}Saat Dilimi:${NC} ${WHITE}Europe/Istanbul${NC}"
if [ "$TEST_MODE" = "1" ]; then
    echo -e "  ${YELLOW}Test Modu:${NC} ${WHITE}1 dakikada bir push${NC}"
else
    echo -e "  ${CYAN}Normal Mod:${NC} ${WHITE}10 dakikada bir push${NC}"
fi
echo -e "  ${PURPLE}Performans İzleme:${NC} ${WHITE}Aktif${NC}"

# Sayaçlar
push_count=0
error_count=0
start_time=$(date +%s)

# Ana döngü
while true; do
    loop_start_time=$(date +%s)
    
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
    git commit -m "backup successful - $(TZ='Europe/Istanbul' date '+%Y-%m-%d %H:%M:%S')" --allow-empty
    
    # Push yap
    if git push origin Backup; then
        push_count=$((push_count + 1))
        log_message "Backup başarıyla push edildi (Toplam: $push_count)"
        echo -e "${GREEN}✅ Backup başarıyla push edildi (Toplam: $push_count)${NC}"
    else
        error_count=$((error_count + 1))
        log_message "Push hatası oluştu (Toplam hata: $error_count)"
        echo -e "${RED}❌ Push hatası oluştu (Toplam hata: $error_count)${NC}"
    fi
    
    # Sistem verimi ölç
    get_system_stats
    
    # Performans özeti göster
    loop_end_time=$(date +%s)
    loop_duration=$((loop_end_time - loop_start_time))
    total_runtime=$((loop_end_time - start_time))
    
    echo -e "${PURPLE}📈 Performans Özeti:${NC}"
    echo -e "  ${CYAN}Döngü Süresi:${NC} ${WHITE}${loop_duration}s${NC}"
    echo -e "  ${CYAN}Toplam Çalışma:${NC} ${WHITE}${total_runtime}s${NC}"
    echo -e "  ${CYAN}Başarılı Push:${NC} ${WHITE}${push_count}${NC}"
    echo -e "  ${CYAN}Hata Sayısı:${NC} ${WHITE}${error_count}${NC}"
    
    # Her 10 push'ta bir performans raporu oluştur
    if [ $((push_count % 10)) -eq 0 ] && [ $push_count -gt 0 ]; then
        create_performance_report
    fi
    
    # Git işlemlerinden sonra kalan süreyi hesapla ve bekle
    local remaining_time=$((SLEEP_TIME - loop_duration))
    
    if [ $remaining_time -gt 0 ]; then
        if [ "$TEST_MODE" = "1" ]; then
            echo -e "${YELLOW}⏰ $remaining_time saniye bekleniyor (TEST MODU)...${NC}"
        else
            echo -e "${BLUE}⏰ $remaining_time saniye bekleniyor...${NC}"
        fi
        sleep $remaining_time
    else
        echo -e "${YELLOW}⚠️  Git işlemleri çok uzun sürdü (${loop_duration}s), hemen devam ediliyor...${NC}"
    fi
done
