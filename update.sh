#!/bin/bash
# CyberSecurity Tools - UPDATE & VERIFY
# Actualiza y verifica la instalación

set -e

# Colores
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo ""
echo "========================================"
echo "  UPDATE & VERIFY - CyberSecurity Tools"
echo "========================================"
echo ""

# Descargar última versión
echo "${CYAN}[+] Descargando última versión...${NC}"
CURRENT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Backup install.sh
if [ -f "$CURRENT_DIR/install.sh" ]; then
    cp "$CURRENT_DIR/install.sh" /tmp/cs_install_backup.sh
fi

# Descargar
rm -rf /tmp/cs_update
git clone --depth 1 https://github.com/DavidsmSilva/CiberSecurity-Tools.git /tmp/cs_update 2>/dev/null || true

# Copiar nuevos archivos
if [ -f /tmp/cs_update/install.sh ]; then
    cp /tmp/cs_update/install.sh "$CURRENT_DIR/install.sh"
    chmod +x "$CURRENT_DIR/install.sh"
    echo "${GREEN}[OK] Installer actualizado${NC}"
else
    echo "${RED}[ERROR] No se pudo descargar${NC}"
    exit 1
fi

# Ejecutar installer
echo ""
echo "${CYAN}[+] Ejecutando installation...${NC}"
cd "$CURRENT_DIR"
bash ./install.sh

echo ""
echo "========================================"
echo "  VERIFICANDO INSTALACION"
echo "========================================"
echo ""

INSTALLED=0
MISSING=0

check() {
    if command -v "$1" &>/dev/null; then
        echo "${GREEN}[OK]${NC} $1"
        INSTALLED=$((INSTALLED + 1))
    else
        echo "${YELLOW}[!]${NC} $1 (no instalado)"
        MISSING=$((MISSING + 1))
    fi
}

echo "Herramientas principales:"
check nmap
check masscan
check netdiscover
check naabu
check httpx
check nuclei
check sqlmap
check john
check hashcat
check hydra
check netcat
check socat
check ghidra
check radare2

echo ""
echo "Repositorios:"
[ -d /opt/SecLists ] && echo "${GREEN}[OK]${NC} SecLists" || echo "${YELLOW}[!]${NC} SecLists"
[ -d /opt/PEASS ] && echo "${GREEN}[OK]${NC} PEASS" || echo "${YELLOW}[!]${NC} PEASS"

echo ""
echo "Scripts:"
[ -f /usr/local/bin/linpeas ] && echo "${GREEN}[OK]${NC} linpeas" || echo "${YELLOW}[!]${NC} linpeas"

echo ""
echo "========================================"
echo "  RESUMEN"
echo "========================================"
echo "Instaladas: $INSTALLED"
echo "Faltantes: $MISSING"
echo ""

if command -v cibersec &>/dev/null; then
    echo "${GREEN}Listo para usar: cibersec${NC}"
else
    echo "${YELLOW}Para usar: pipx install . o pip install -e .${NC}"
fi

echo ""