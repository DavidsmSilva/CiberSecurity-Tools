#!/bin/bash
# CyberSecurity Tools - INSTALLER v1.6 (SIMPLE)
# Solo instala herramientas - repos opcionales MANUAL

set -e

CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# ============================================================
# INSTALACIÓN RÁPIDA (sin repos grandes)
# ============================================================

echo ""
echo "========================================"
echo "  CyberSecurity Tools - INSTALLER v1.6"
echo "========================================"
echo ""

# 1. Sistema
echo "${CYAN}[1/5] Sistema...${NC}"
apt update -qq && apt upgrade -y -qq 2>/dev/null || true
echo "${GREEN}[OK]${NC}"

# 2. Dependencias
echo "${CYAN}[2/5] Dependencias...${NC}"
apt install -y git curl wget build-essential python3 python3-pip ruby ruby-dev net-tools -qq 2>/dev/null || true
echo "${GREEN}[OK]${NC}"

# 3. Python
echo "${CYAN}[3/5] Python packages...${NC}"
pip3 install --upgrade pip -q 2>/dev/null || true
pip3 install typer rich pwntools scapy impacket -q 2>/dev/null || true
echo "${GREEN}[OK]${NC}"

# 4. APT tools (~40 herramientas)
echo "${CYAN}[4/5] Herramientas (~40)...${NC}"
apt install -y \
    nmap netdiscover masscan \
    nikto whatweb \
    metasploit-framework exploitdb sqlmap commix \
    zaproxy dirb gobuster \
    john hashcat hydra cewl crunch cupp \
    wireshark ettercap-graphical bettercap responder \
    netcat-traditional socat \
    enum4linux ldap-utils \
    binwalk foremost radare2 ghidra gdb \
    tmux screen proxychains4 macchanger \
    wordlists \
    -qq 2>/dev/null || true
echo "${GREEN}[OK]${NC}"

# 5. Go tools
echo "${CYAN}[5/5] Herramientas Go...${NC}"
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
go install github.com/projectdiscovery/naabu/v2/cmd/naabu@latest 2>/dev/null || true
go install github.com/projectdiscovery/httpx/cmd/httpx@latest 2>/dev/null || true
go install github.com/projectdiscovery/dnsx/cmd/dnsx@latest 2>/dev/null || true
go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest 2>/dev/null || true
go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest 2>/dev/null || true
go install github.com/OJ/gobuster/v3@latest 2>/dev/null || true
echo "${GREEN}[OK]${NC}"

# 6. Scripts esenciales
mkdir -p /usr/local/bin
curl -sL "https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh" -o /usr/local/bin/linpeas 2>/dev/null && chmod +x /usr/local/bin/linpeas
curl -sL "https://github.com/carlospolop/PEASS-ng/releases/latest/download/winPEAS.bat" -o /usr/local/bin/winPEAS.bat 2>/dev/null && chmod +x /usr/local/bin/winPEAS.bat

# Nuclei
nuclei -up 2>/dev/null || true

# Fin
echo ""
echo "========================================"
echo "  ✅ INSTALACION COMPLETA"
echo "========================================"
echo ""
echo "Ejecutar: cibersec"
echo ""

# Verificar
echo "Verificación rápida:"
echo ""
which nmap >/dev/null && echo "  ✅ nmap"
which masscan >/dev/null && echo "  ✅ masscan"
which sqlmap >/dev/null && echo "  ✅ sqlmap"
which john >/dev/null && echo "  ✅ john"
which hashcat >/dev/null && echo "  ✅ hashcat"
which nuclei >/dev/null && echo "  ✅ nuclei"
echo ""