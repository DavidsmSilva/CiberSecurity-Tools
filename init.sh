#!/bin/bash
# ════════════════════════════════════════════════════════════════════════════
#  CyberSecurity Tools - INIT
#  Inicializador del toolkit
# ════════════════════════════════════════════════════════════════════════════

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}"
echo "╔═══════════════════════════════════════════════════════════════════╗"
echo "║     🛡️  CyberSecurity Tools - INIT v1.0                          ║"
echo "╚═══════════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Detectar SO
if [[ -f /etc/kali-release ]]; then
    OS="kali"
elif [[ -f /etc/parrot-release ]]; then
    OS="parrot"
elif [[ -f /etc/debian_version ]]; then
    OS="debian"
else
    OS="unknown"
fi

echo -e "${BLUE}[ℹ]${NC} SO detectado: $OS"
echo -e "${BLUE}[ℹ]${NC} Python: $(python3 --version 2>&1)"
echo ""

# Verificar dependencias
echo -e "${YELLOW}[→]${NC} Verificando dependencias..."

# Instalar Python dependencies si no están
if ! python3 -c "import typer" 2>/dev/null; then
    echo -e "${YELLOW}[!]${NC} Instalando typer..."
    pip3 install typer rich --quiet
fi

if ! python3 -c "import rich" 2>/dev/null; then
    echo -e "${YELLOW}[!]${NC} Instalando rich..."
    pip3 install rich --quiet
fi

# Verificar herramientas del sistema
MISSING_TOOLS=()

echo -e "${YELLOW}[→]${NC} Verificando herramientas del sistema..."

check_tool() {
    if command -v "$1" &>/dev/null; then
        echo -e "${GREEN}[✓]${NC} $1"
    else
        echo -e "${YELLOW}[!]${NC} $1 (no instalado)"
        MISSING_TOOLS+=("$1")
    fi
}

# Herramientas críticas
check_tool "nmap"
check_tool "masscan"
check_tool "netdiscover"
check_tool "python3"
check_tool "go"

# Instalar herramientas del sistema (solo en Kali/Parrot)
if [[ "$OS" == "kali" || "$OS" == "parrot" ]]; then
    if [ ${#MISSING_TOOLS[@]} -gt 0 ]; then
        echo ""
        echo -e "${YELLOW}[!]${NC} Hay herramientas faltantes."
        echo -e "${YELLOW}[!]${NC} Para instalar todas: sudo apt update && sudo apt install -y ${MISSING_TOOLS[*]}"
    fi
fi

echo ""
echo -e "${GREEN}[✓]${NC} INIT completado!"
echo ""
echo "═══════════════════════════════════════════════════════════════════"
echo "  PRÓXIMOS PASOS:"
echo "═══════════════════════════════════════════════════════════════════"
echo ""
echo "  1. Instalar el toolkit como módulo:"
echo "     pipx install ."
echo ""
echo "  2. O en modo desarrollo:"
echo "     pip install -e ."
echo ""
echo "  3. Ejecutar:"
echo "     cibersec"
echo ""
echo "  4. Para actualizar:"
echo "     pipx reinstall cibersecurity-tools"
echo ""
echo -e "${CYAN}¡Listo para usar! 🛡️${NC}"
echo ""