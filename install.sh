#!/bin/bash
# CyberSecurity Tools - INSTALLER v1.4
# Instala todo el toolkit

set -e

# Colores simples
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo ""
echo "========================================"
echo "  CyberSecurity Tools - INSTALLER v1.4"
echo "========================================"
echo ""

# Actualizar sistema
echo "${CYAN}[+] Actualizando sistema...${NC}"
apt update -qq
apt upgrade -y -qq
echo "${GREEN}[OK] Sistema actualizado${NC}"
echo ""

# Instalar deps
echo "${CYAN}[+] Instalando dependencias...${NC}"
apt install -y git curl wget build-essential python3 python3-pip ruby ruby-dev -qq
echo "${GREEN}[OK] Dependas instaladas${NC}"
echo ""

# Python packages
echo "${CYAN}[+] Paquetes Python...${NC}"
pip3 install --upgrade pip -q 2>/dev/null || true
pip3 install typer rich -q 2>/dev/null || true
echo "${GREEN}[OK] Python packages${NC}"
echo ""

# APT tools
echo "${CYAN}[+] Herramientas del sistema...${NC}"
apt install -y nmap netdiscover masscan nikto whatweb metasploit-framework exploitdb sqlmap zaproxy dirb john hashcat hydra cewl crunch wireshark ettercap-graphical bettercap netcat-traditional socat enum4linux ldap-utils binwalk foremost radare2 ghidra gdb tmux screen proxychains4 macchanger wordlists -qq 2>/dev/null || true
echo "${GREEN}[OK] Herramientas del sistema${NC}"
echo ""

# Go tools
echo "${CYAN}[+] Herramientas Go (3-8 min)...${NC}"
export PATH=$PATH:/usr/local/go/bin
go install github.com/projectdiscovery/naabu/v2/cmd/naabu@latest 2>/dev/null || true
go install github.com/projectdiscovery/httpx/cmd/httpx@latest 2>/dev/null || true
go install github.com/projectdiscovery/dnsx/cmd/dnsx@latest 2>/dev/null || true
go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest 2>/dev/null || true
go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest 2>/dev/null || true
go install github.com/OJ/gobuster/v3@latest 2>/dev/null || true
echo "${GREEN}[OK] Herramientas Go${NC}"
echo ""

# Repos (usando solo si no existen)
echo "${CYAN}[+] Repositorios principales...${NC}"
mkdir -p /opt

# SecLists
if [ -d /opt/SecLists ]; then
    echo "  SecLists (ya existe)"
else
    echo "  Descargando SecLists..."
    git clone --depth 1 https://github.com/danielmiessler/SecLists.git /opt/SecLists 2>/dev/null || echo "  Error SecLists"
fi

# PEASS
if [ -d /opt/PEASS ]; then
    echo "  PEASS (ya existe)"
else
    echo "  Descargando PEASS..."
    git clone --depth 1 https://github.com/carlospolop/PEASS-ng.git /opt/PEASS 2>/dev/null || echo "  Error PEASS"
fi

echo "${GREEN}[OK] Repositorios${NC}"
echo ""

# Scripts
echo "${CYAN}[+] Scripts de privilege escalation...${NC}"
mkdir -p /usr/local/bin
curl -sL https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh -o /usr/local/bin/linpeas
chmod +x /usr/local/bin/linpeas
curl -sL https://github.com/carlospolop/PEASS-ng/releases/latest/download/winPEAS.bat -o /usr/local/bin/winPEAS.bat
chmod +x /usr/local/bin/winPEAS.bat
echo "${GREEN}[OK] Scripts${NC}"
echo ""

# Nuclei
echo "${CYAN}[+] Nuclei templates...${NC}"
nuclei -up 2>/dev/null || true
echo "${GREEN}[OK] Nuclei${NC}"
echo ""

# Fin
echo "========================================"
echo "  INSTALACION COMPLETA"
echo "========================================"
echo ""
echo "Ejecutar: cibersec"
echo ""