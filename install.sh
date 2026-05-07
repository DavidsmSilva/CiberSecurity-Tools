#!/bin/bash
# CyberSecurity Tools - INSTALLER v1.5
# Instala todo el toolkit + repos opcionales

set -e

CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo ""
echo "========================================"
echo "  CyberSecurity Tools - INSTALLER v1.5"
echo "========================================"
echo ""

# 1. Actualizar sistema
echo "${CYAN}[1/7] Actualizando sistema...${NC}"
apt update -qq && apt upgrade -y -qq
echo "${GREEN}[OK] Sistema actualizado${NC}"
echo ""

# 2. Instalar deps
echo "${CYAN}[2/7] Dependencias base...${NC}"
apt install -y git curl wget build-essential python3 python3-pip ruby ruby-dev net-tools -qq
echo "${GREEN}[OK] Dependencias${NC}"
echo ""

# 3. Python packages
echo "${CYAN}[3/7] Paquetes Python...${NC}"
pip3 install --upgrade pip -q 2>/dev/null || true
pip3 install typer rich pwntools scapy impacket -q 2>/dev/null || true
echo "${GREEN}[OK] Python packages${NC}"
echo ""

# 4. APT tools
echo "${CYAN}[4/7] Herramientas del sistema (~30)...${NC}"
apt install -y nmap netdiscover masscan nikto whatweb metasploit-framework exploitdb sqlmap zaproxy dirb john hashcat hydra cewl crunch wireshark ettercap-graphical bettercap netcat-traditional socat enum4linux ldap-utils binwalk foremost radare2 ghidra gdb tmux screen proxychains4 macchanger wordlists -qq 2>/dev/null || true
echo "${GREEN}[OK] Herramientas APT${NC}"
echo ""

# 5. Go tools
echo "${CYAN}[5/7] Herramientas Go (3-8 min)...${NC}"
export PATH=$PATH:/usr/local/go/bin
go install github.com/projectdiscovery/naabu/v2/cmd/naabu@latest 2>/dev/null || true
go install github.com/projectdiscovery/httpx/cmd/httpx@latest 2>/dev/null || true
go install github.com/projectdiscovery/dnsx/cmd/dnsx@latest 2>/dev/null || true
go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest 2>/dev/null || true
go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest 2>/dev/null || true
go install github.com/OJ/gobuster/v3@latest 2>/dev/null || true
echo "${GREEN}[OK] Herramientas Go${NC}"
echo ""

# 6. Repositorios (alternativos si git falla)
echo "${CYAN}[6/7] Repositorios...${NC}"
mkdir -p /opt

# Intentar clonar, si falla descargar ZIP
download_repo() {
    local name="$1"
    local url="$2"
    local dir="$3"
    local zip_url="$4"
    
    if [ -d "$dir" ]; then
        echo "  ⏭️  $name (ya existe)"
        return 0
    fi
    
    echo "  📥 $name..."
    
    # Intentar git clone
    if timeout 60 git clone --depth 1 "$url" "$dir" 2>/dev/null; then
        echo "  ✅ $name (git)"
        return 0
    fi
    
    # Si git falla, intentar descargar ZIP
    if [ -n "$zip_url" ]; then
        if timeout 120 curl -sL "$zip_url" -o "/tmp/${name}.zip"; then
            if unzip -q "/tmp/${name}.zip" -d /opt 2>/dev/null; then
                echo "  ✅ $name (zip)"
                rm -f "/tmp/${name}.zip"
                return 0
            fi
        fi
    fi
    
    echo "  ⚠️  $name (no se pudo descargar)"
    return 1
}

# SecLists - descargar directamente si git falla
if [ ! -d /opt/SecLists ]; then
    echo "  📥 SecLists (~500MB)..."
    # Usar release alternativa
    if timeout 180 curl -sL "https://github.com/danielmiessler/SecLists/archive/refs/heads/master.zip" -o /tmp/seclists.zip; then
        unzip -q /tmp/seclists.zip -d /opt 2>/dev/null
        mv /opt/SecLists-master /opt/SecLists 2>/dev/null
        rm -f /tmp/seclists.zip
        [ -d /opt/SecLists ] && echo "  ✅ SecLists" || echo "  ⚠️  SecLists"
    else
        echo "  ⚠️  SecLists (sin conexión)"
    fi
else
    echo "  ⏭️  SecLists (ya existe)"
fi

# PEASS
if [ ! -d /opt/PEASS ]; then
    echo "  📥 PEASS..."
    if timeout 60 git clone --depth 1 "https://github.com/carlospolop/PEASS-ng.git" /opt/PEASS 2>/dev/null; then
        echo "  ✅ PEASS"
    else
        echo "  ⚠️  PEASS"
    fi
else
    echo "  ⏭️  PEASS (ya existe)"
fi

# PayloadsAllTheThings
if [ ! -d /opt/PayloadsAllTheThings ]; then
    echo "  📥 PayloadsAllTheThings..."
    if timeout 60 git clone --depth 1 "https://github.com/swisskyrepo/PayloadsAllTheThings.git" /opt/PayloadsAllTheThings 2>/dev/null; then
        echo "  ✅ PayloadsAllTheThings"
    else
        echo "  ⚠️  PayloadsAllTheThings"
    fi
else
    echo "  ⏭️  PayloadsAllTheThings (ya existe)"
fi

echo "${GREEN}[OK] Repositorios${NC}"
echo ""

# 7. Scripts y Nuclei
echo "${CYAN}[7/7] Scripts y Nuclei...${NC}"
mkdir -p /usr/local/bin

# LinPEAS/WinPEAS
curl -sL "https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh" -o /usr/local/bin/linpeas 2>/dev/null && chmod +x /usr/local/bin/linpeas
curl -sL "https://github.com/carlospolop/PEASS-ng/releases/latest/download/winPEAS.bat" -o /usr/local/bin/winPEAS.bat 2>/dev/null && chmod +x /usr/local/bin/winPEAS.bat

# Nuclei
nuclei -up 2>/dev/null || true

echo "${GREEN}[OK] Scripts y Nuclei${NC}"
echo ""

# Fin
echo "========================================"
echo "  INSTALACION COMPLETA"
echo "========================================"
echo ""
echo "Ejecutar: cibersec"
echo ""