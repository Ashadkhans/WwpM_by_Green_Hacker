#!/bin/bash

# --- Colors ---
GREEN='\033[1;32m'
RED='\033[1;31m'
WHITE='\033[1;37m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
RESET='\033[0m'

banner() {
    clear
    echo -e "${CYAN}  ██╗    ██╗██╗    ██╗██████╗ ███╗   ███╗"
    echo "  ██║    ██║██║    ██║██╔══██╗████╗ ████║"
    echo "  ██║ █╗ ██║██║ █╗ ██║██████╔╝██╔████╔██║"
    echo "  ██║███╗██║██║███╗██║██╔═══╝ ██║╚██╔╝██║"
    echo "  ╚███╔███╔╝╚███╔███╔╝██║     ██║ ╚═╝ ██║"
    echo -e "   ╚══╝╚══╝  ╚══╝╚══╝ ╚═╝     ╚═╝     ╚═╝${RESET}"
    echo -e "      ${GREEN}>> PROJECT: WwpM (MASTER) <<${RESET}"
    echo -e "${BLUE}======================================================${RESET}"
}

start_background_server() {
    pkill -f "python server.py" > /dev/null 2>&1
    echo -e "\n${YELLOW}[*] Starting Backend...${RESET}"
    termux-wake-lock
    nohup python server.py > /dev/null 2>&1 &
    sleep 2
    echo -e "${GREEN}[✔] Server ACTIVE!${RESET}"
}

world_wide() {
    start_background_server
    echo -e "${YELLOW}[*] Requesting Secure Link...${RESET}"
    cloudflared tunnel --url http://localhost:8080 2>&1 | grep --line-buffered -o 'https://[-0-9a-z]*\.trycloudflare.com' | while read -r url; do
        echo -e "\n${BLUE}┌────────────────────────────────────────────────────┐${RESET}"
        echo -e "  ${WHITE}URL:${RESET} ${GREEN}$url${RESET}"
        echo -e "${BLUE}└────────────────────────────────────────────────────┘${RESET}"
        echo -e "${RED}>> Press [Ctrl+C] to stop and return <<${RESET}"
    done
}

data_monitor() {
    banner
    echo -e "${PURPLE}[#] LIVE DATA MONITOR (Press Ctrl+C to stop)${RESET}"
    tail -f data.txt
}

# --- Main Logic ---
while true; do
    banner
    echo -e "${WHITE}[1] Local Host  [2] World Wide  [3] Live Data  [4] Exit${RESET}"
    echo -ne "\n${YELLOW}WwpM >> ${RESET}"
    read choice
    case $choice in
        1) start_background_server; echo "Local: http://localhost:8080"; read ;;
        2) world_wide ;;
        3) data_monitor ;;
        4) pkill -f "python server.py"; pkill -f "cloudflared"; termux-wake-unlock; exit ;;
        *) echo "Invalid Option"; sleep 1 ;;
    esac
done
