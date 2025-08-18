#!/bin/bash

# AutoPush Performans İzleme Scripti
# Sistem verimini gerçek zamanlı olarak gösterir

# Renk kodları
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Script dizinini al
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOGS_DIR="$SCRIPT_DIR/logs"
PERFORMANCE_LOG="$LOGS_DIR/performance_log"
STATS_FILE="$LOGS_DIR/system_stats"
PID_FILE="$LOGS_DIR/autopush.pid"

# İstanbul saat dilimini ayarla
export TZ='Europe/Istanbul'

# Yardım fonksiyonu
show_help() {
    echo -e "${WHITE}AutoPush Performans İzleme Scripti${NC}"
    echo -e "${CYAN}Kullanım:${NC}"
    echo -e "  ${WHITE}./monitor_performance.sh [seçenek]${NC}"
    echo -e ""
    echo -e "${CYAN}Seçenekler:${NC}"
    echo -e "  ${WHITE}live${NC}     - Gerçek zamanlı performans izleme"
    echo -e "  ${WHITE}stats${NC}    - Güncel sistem istatistikleri"
    echo -e "  ${WHITE}history${NC}  - Performans geçmişi"
    echo -e "  ${WHITE}summary${NC}  - Özet rapor"
    echo -e "  ${WHITE}status${NC}   - Program durumu"
    echo -e "  ${WHITE}help${NC}     - Bu yardım mesajı"
    echo -e ""
    echo -e "${CYAN}Örnek:${NC}"
    echo -e "  ${WHITE}./monitor_performance.sh live${NC}"
}

# Program durumu kontrolü
check_status() {
    if [ -f "$PID_FILE" ]; then
        local pid=$(cat "$PID_FILE")
        if ps -p "$pid" > /dev/null 2>&1; then
            echo -e "${GREEN}✅ AutoPush çalışıyor (PID: $pid)${NC}"
            local uptime=$(ps -o etime= -p "$pid" 2>/dev/null | tr -d ' ')
            if [ -n "$uptime" ]; then
                echo -e "${CYAN}Çalışma Süresi:${NC} ${WHITE}$uptime${NC}"
            fi
        else
            echo -e "${RED}❌ AutoPush çalışmıyor (PID: $pid - bulunamadı)${NC}"
        fi
    else
        echo -e "${RED}❌ AutoPush PID dosyası bulunamadı${NC}"
    fi
}

# Güncel sistem istatistikleri
show_stats() {
    if [ -f "$STATS_FILE" ]; then
        echo -e "${PURPLE}📊 Güncel Sistem İstatistikleri${NC}"
        echo -e "${CYAN}Son Güncelleme:${NC} ${WHITE}$(TZ='Europe/Istanbul' date '+%Y-%m-%d %H:%M:%S')${NC}"
        echo -e ""
        cat "$STATS_FILE"
    else
        echo -e "${YELLOW}⚠️  Sistem istatistikleri henüz oluşturulmamış${NC}"
    fi
}

# Performans geçmişi
show_history() {
    if [ -f "$PERFORMANCE_LOG" ]; then
        echo -e "${PURPLE}📈 Performans Geçmişi (Son 20 Kayıt)${NC}"
        echo -e "${CYAN}Toplam Kayıt:${NC} ${WHITE}$(wc -l < "$PERFORMANCE_LOG")${NC}"
        echo -e ""
        
        # Son 20 kaydı göster
        tail -20 "$PERFORMANCE_LOG" | while IFS='|' read -r timestamp cpu ram disk free_ram; do
            echo -e "${WHITE}$timestamp${NC}"
            echo -e "  ${CYAN}CPU:${NC} ${WHITE}$cpu${NC}"
            echo -e "  ${CYAN}RAM:${NC} ${WHITE}$ram${NC}"
            echo -e "  ${CYAN}Disk:${NC} ${WHITE}$disk${NC}"
            echo -e "  ${CYAN}Boş RAM:${NC} ${WHITE}$free_ram${NC}"
            echo ""
        done
    else
        echo -e "${YELLOW}⚠️  Performans log dosyası bulunamadı${NC}"
    fi
}

# Özet rapor
show_summary() {
    echo -e "${PURPLE}📋 AutoPush Özet Raporu${NC}"
    echo -e "${CYAN}Tarih:${NC} ${WHITE}$(TZ='Europe/Istanbul' date '+%Y-%m-%d %H:%M:%S')${NC}"
    echo -e ""
    
    # Program durumu
    check_status
    echo ""
    
    # Dosya boyutları
    if [ -f "$PERFORMANCE_LOG" ]; then
        local log_size=$(du -h "$PERFORMANCE_LOG" | cut -f1)
        echo -e "${CYAN}Performans Log Boyutu:${NC} ${WHITE}$log_size${NC}"
    fi
    
    if [ -f "$STATS_FILE" ]; then
        local stats_size=$(du -h "$STATS_FILE" | cut -f1)
        echo -e "${CYAN}Sistem Stats Boyutu:${NC} ${WHITE}$stats_size${NC}"
    fi
    
    # Logs klasörü boyutu
    if [ -d "$LOGS_DIR" ]; then
        local logs_size=$(du -sh "$LOGS_DIR" | cut -f1)
        echo -e "${CYAN}Logs Klasörü Boyutu:${NC} ${WHITE}$logs_size${NC}"
    fi
}

# Gerçek zamanlı izleme
live_monitoring() {
    echo -e "${PURPLE}🔴 Gerçek Zamanlı Performans İzleme${NC}"
    echo -e "${CYAN}Çıkmak için Ctrl+C tuşlayın${NC}"
    echo -e ""
    
    # Her 5 saniyede bir güncelle
    while true; do
        clear
        echo -e "${PURPLE}🔴 AutoPush Gerçek Zamanlı İzleme${NC}"
        echo -e "${CYAN}Son Güncelleme:${NC} ${WHITE}$(TZ='Europe/Istanbul' date '+%Y-%m-%d %H:%M:%S')${NC}"
        echo -e "${CYAN}Çıkmak için Ctrl+C tuşlayın${NC}"
        echo -e ""
        
        # Program durumu
        check_status
        echo ""
        
        # Güncel istatistikler
        if [ -f "$STATS_FILE" ]; then
            echo -e "${PURPLE}📊 Güncel Sistem Durumu${NC}"
            cat "$STATS_FILE"
        fi
        
        # Son performans kaydı
        if [ -f "$PERFORMANCE_LOG" ]; then
            echo -e ""
            echo -e "${PURPLE}📈 Son Performans Kaydı${NC}"
            tail -1 "$PERFORMANCE_LOG" | while IFS='|' read -r timestamp cpu ram disk free_ram; do
                echo -e "${WHITE}$timestamp${NC}"
                echo -e "  ${CYAN}CPU:${NC} ${WHITE}$cpu${NC}"
                echo -e "  ${CYAN}RAM:${NC} ${WHITE}$ram${NC}"
                echo -e "  ${CYAN}Disk:${NC} ${WHITE}$disk${NC}"
                echo -e "  ${CYAN}Boş RAM:${NC} ${WHITE}$free_ram${NC}"
            done
        fi
        
        sleep 5
    done
}

# Ana menü
case "${1:-help}" in
    "live")
        live_monitoring
        ;;
    "stats")
        show_stats
        ;;
    "history")
        show_history
        ;;
    "summary")
        show_summary
        ;;
    "status")
        check_status
        ;;
    "help"|*)
        show_help
        ;;
esac
