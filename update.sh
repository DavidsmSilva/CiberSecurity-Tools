#!/bin/bash
# ════════════════════════════════════════════════════════════════════════════
#  CyberSecurity Tools - UPDATE & VERIFY
#  Actualiza la app y verifica que todo esté instalado
# ════════════════════════════════════════════════════════════════════════════

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

progress() { echo -e "${CYAN}[→]${NC} $1"; }
success() { echo -e "${GREEN}[✓]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
error() { echo -e "${RED}[✗]${NC} $1"; }

echo ""
echo "╔═══════════════════════════════════════════════════════════════════════╗"
echo "║     🛡️  CyberSecurity Tools - UPDATE & VERIFY v1.1           ║"
echo "╚═══════════════════════════════════════════════════════════════════════╝"
echo ""

# ════════════════════════════════════════════════════════════════════════
# 1. ACTUALIZAR DESDE GITHUB
# ════════════════════════════════════════════════════════════════════════

progress "Actualizando CyberSecurity Tools desde GitHub..."

# Guardar directorio actual
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Hacer backup del install.sh si existe
if [ -f "$CURRENT_DIR/install.sh" ]; then
    cp "$CURRENT_DIR/install.sh" /tmp/cs_install_backup.sh
fi

# Descargar última versión
if [ -d /tmp/CiberSecurity-Tools ]; then
    rm -rf /tmp/CiberSecurity-Tools
fi

git clone --depth 1 https://github.com/DavidsmSilva/CiberSecurity-Tools.git /tmp/CiberSecurity-Tools 2>/dev/null || true

# Copiar nuevos archivos
if [ -f /tmp/CiberSecurity-Tools/install.sh ]; then
    cp /tmp/CiberSecurity-Tools/install.sh "$CURRENT_DIR/install.sh"
    chmod +x "$CURRENT_DIR/install.sh"
    success "Installer actualizado"
else
    error "No se pudo descargar el installer"
    exit 1
fi

echo ""

# ════════════════════════════════════════════════════════════════════════
# 2. REINSTALAR TODO
# ════════════════════════════════════════════════════════════════════════════════

progress "Ejecutando installer..."

cd "$CURRENT_DIR"
bash ./install.sh

echo ""

# ════════════════════════════════════════════════════════════════════════
# 3. VERIFICAR INSTALACIÓN
# ═════════════════════════════��══════════════════════════════════════════

echo ""
echo "╔═══════════════════════════════════════════════════════════════════════╗"
echo "║           🔍 VERIFICANDO INSTALACIÓN                          ║"
echo "╚═══════════════════════════════════════════════════════════════════════╝"
echo ""

INSTALLED=0
MISSING=0

check_tool() {
    local name="$1"
    local cmd="$2"
    
    if command -v "$name" &>/dev/null || [ -f "$cmd" ]; then
        success "$name"
        INSTALLED=$((INSTALLED + 1))
    else
        warn "$name (NO INSTALADO)"
        MISSING=$((MISSING + 1))
    fi
}

echo "🔧 Herramientas del sistema:"
check_tool "nmap" ""
check_tool "masscan" ""
check_tool "netdiscover" ""
check_tool "nikto" ""
check_tool "whatweb" ""
check_tool "metasploit-framework" ""
check_tool "sqlmap" ""
check_tool "zaproxy" ""
check_tool "dirb" ""
check_tool "gobuster" ""
check_tool "hashcat" ""
check_tool "john" ""
check_tool "hydra" ""
check_tool "cewl" ""
check_tool "crunch" ""
check_tool "wireshark" ""
check_tool "ettercap" ""
check_tool "bettercap" ""
check_tool "responder" ""
check_tool "netcat" ""
check_tool "socat" ""
check_tool "enum4linux" ""
check_tool "ghidra" ""
check_tool "radare2" ""
check_tool "binwalk" ""
check_tool "foremost" ""
check_tool "aircrack-ng" ""
check_tool "wifite" ""
check_tool "reaver" ""

echo ""
echo "🐹 Herramientas Go:"
check_tool "naabu" ""
check_tool "httpx" ""
check_tool "dnsx" ""
check_tool "subfinder" ""
check_tool "nuclei" ""

echo ""
echo "🐍 Paquetes Python:"
check_tool "python3" ""
check_tool "pwntools" ""
check_tool "impacket" ""

echo ""
echo "📂 Repositorios:"
[ -d /opt/SecLists ] && success "SecLists" || warn "SecLists (NO)"
[ -d /opt/PayloadsAllTheThings ] && success "PayloadsAllTheThings" || warn "PayloadsAllTheThings (NO)"
[ -d /opt/Responder ] && success "Responder" || warn "Responder (NO)"
[ -d /opt/theHarvester ] && success "theHarvester" || warn "theHarvester (NO)"
[ -d /opt/PEASS ] && success "PEASS" || warn "PEASS (NO)"

echo ""
echo "📜 Scripts de Privilege Escalation:"
[ -f /usr/local/bin/linpeas ] && success "linpeas" || warn "linpeas (NO)"
[ -f /usr/local/bin/winPEAS.bat ] && success "winPEAS" || warn "winPEAS (NO)"

# ════════════════════════════════════════════════════════════════════════
# RESUMEN
# ════════════════════════════════════════════════════════════════════════

echo ""
echo "╔════════════════════════════════════════════════════════════════��══════╗"
echo "║                    📊 RESUMEN                                  ║"
echo "╚═══════════════════════════════════════════════════════════════════════╝"
echo ""

if [ $MISSING -eq 0 ]; then
    success "¡TODAS LAS HERRAMIENTAS ESTÁN INSTALADAS!"
    echo ""
    echo "  ✅ Herramientas instaladas: $INSTALLED"
    echo "  ⚠️  Herramientas faltantes: $MISSING"
else
    warn "Algunas herramientas no se instalaron"
    echo ""
    echo "  ✅ Herramientas instaladas: $INSTALLED"
    echo "  ⚠️  Herramientas faltantes: $MISSING"
    echo ""
    echo "  Para reinstallar específico:"
    echo "    sudo apt install <nombre-paquete>"
    echo "    pip3 install <nombre-paquete>"
fi

echo ""
echo "  🎯 Launcher: $(command -v cibersec && echo '✅ instalado' || echo '❌ NO instalado')"
echo ""

# Verificar que cibersec funcione
if command -v cibersec &>/dev/null; then
    success "CyberSecurity Tools listo para usar!"
    echo ""
    echo "  Ejecuta: cibersec"
else
    warn "Ejecuta para completar instalación:"
    echo "  pipx install ."
    echo "  o"
    echo "  pip install -e ."
fi

echo ""