#!/bin/bash
# ========================================================================
#  CyberSecurity Tools - INSTALLER COMPLETO v2.0
#  Instala TODAS las herramientas automáticamente
# ========================================================================

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Contadores
INSTALLED=0
FAILED=0
SKIPPED=0

# Función para mostrar estado
status() {
    echo -e "${CYAN}[→]${NC} $1"
}

ok() {
    echo -e "${GREEN}[✓]${NC} $1"
    INSTALLED=$((INSTALLED + 1))
}

fail() {
    echo -e "${RED}[✗]${NC} $1"
    FAILED=$((FAILED + 1))
}

skip() {
    echo -e "${YELLOW}[−]${NC} $1"
    SKIPPED=$((SKIPPED + 1))
}

warn() {
    echo -e "${YELLOW}[!]${NC} $1"
}

# Banner
echo ""
echo "╔═══════════════════════════════════════════════════════════════════╗"
echo "║     🛡️  CyberSecurity Tools - INSTALLER v2.0          ║"
echo "║     Instalación completa y automática                      ║"
echo "╚═══════════════════════════════════════════════════════════════════╝"
echo ""

# Verificar root
if [[ $EUID -ne 0 ]]; then
    warn "Ejecutar como root: sudo ./install.sh"
    exit 1
fi

# Detectar SO
if [[ -f /etc/kali-release ]]; then
    OS="kali"
elif [[ -f /etc/parrot-release ]]; then
    OS="parrot"
else
    OS="debian"
fi

status "Sistema: $OS"
echo ""

# ========================================================================
# 1. ACTUALIZAR SISTEMA
# ========================================================================
status "[1/6] Actualizando sistema..."
apt update -qq 2>/dev/null || true
apt upgrade -y -qq 2>/dev/null || true
ok "Sistema actualizado"
echo ""

# ========================================================================
# 2. INSTALAR DEPENDENCIAS
# ========================================================================
status "[2/6] Instalando dependencias..."

DEPS="git curl wget build-essential python3 python3-pip python3-venv ruby ruby-dev net-tools"

for dep in $DEPS; do
    if dpkg -l | grep -q "^ii  $dep "; then
        skip "$dep (ya instalado)"
    else
        if apt install -y -qq $dep 2>/dev/null; then
            ok "$dep"
        else
            fail "$dep"
        fi
    fi
done
echo ""

# Python packages
status "Paquetes Python..."
pip3 install --upgrade pip -q 2>/dev/null || true
for pkg in typer rich pwntools scapy impacket; do
    if pip3 show $pkg >/dev/null 2>&1; then
        skip "python-$pkg"
    else
        if pip3 install -q $pkg 2>/dev/null; then
            ok "python-$pkg"
        else
            fail "python-$pkg"
        fi
    fi
done
echo ""

# ========================================================================
# 3. INSTALAR HERRAMIENTAS APT
# ========================================================================
status "[3/6] Herramientas del sistema..."

# Lista de paquetes - solo los que existen en Kali
APT_PACKAGES=(
    "nmap"
    "netdiscover"
    "masscan"
    "nikto"
    "whatweb"
    "metasploit-framework"
    "exploitdb"
    "sqlmap"
    "commix"
    "zaproxy"
    "dirb"
    "gobuster"
    "john"
    "hashcat"
    "hydra"
    "cewl"
    "crunch"
    "wireshark"
    "ettercap-graphical"
    "bettercap"
    "responder"
    "netcat"
    "netcat-traditional"
    "socat"
    "enum4linux"
    "ldap-utils"
    "binwalk"
    "foremost"
    "radare2"
    "ghidra"
    "gdb"
    "tmux"
    "screen"
    "proxychains"
    "wordlists"
)

# Instalar en batches para no saturar
BATCH=""
for pkg in "${APT_PACKAGES[@]}"; do
    BATCH="$BATCH $pkg"
done

# Instalar todo junto
if apt install -y -qq $BATCH 2>/dev/null; then
    ok "Herramientas APT instaladas"
else
    # Intentar una por una
    for pkg in "${APT_PACKAGES[@]}"; do
        if apt install -y -qq $pkg 2>/dev/null; then
            ok "$pkg"
        else
            fail "$pkg"
        fi
    done
fi
echo ""

# ========================================================================
# 4. INSTALAR HERRAMIENTAS GO
# ========================================================================
status "[4/6] Herramientas Go..."

# Configurar Go
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin

# Verificar Go
if ! command -v go &>/dev/null; then
    status "Instalando Go..."
    wget -q https://go.dev/dl/go1.21.5.linux-amd64.tar.gz -O /tmp/go.tar.gz
    tar -C /usr/local -xzf /tmp/go.tar.gz 2>/dev/null || true
    rm -f /tmp/go.tar.gz
    export PATH=$PATH:/usr/local/go/bin
fi

# Herramientas Go
GO_TOOLS=(
    "github.com/projectdiscovery/naabu/v2/cmd/naabu@latest"
    "github.com/projectdiscovery/httpx/cmd/httpx@latest"
    "github.com/projectdiscovery/dnsx/cmd/dnsx@latest"
    "github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest"
    "github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest"
    "github.com/OJ/gobuster/v3@latest"
)

for tool in "${GO_TOOLS[@]}"; do
    TOOL_NAME=$(echo $tool | cut -d'/' -f5)
    if command -v $TOOL_NAME &>/dev/null; then
        skip "$TOOL_NAME (ya instalado)"
    else
        if go install $tool 2>/dev/null; then
            ok "$TOOL_NAME"
        else
            fail "$TOOL_NAME"
        fi
    fi
done
echo ""

# ========================================================================
# 5. HERRAMIENTAS ADICIONALES
# ========================================================================
status "[5/6] Scripts y herramientas adicionales..."

# Scripts de privilege escalation
mkdir -p /usr/local/bin

if curl -sL "https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh" -o /usr/local/bin/linpeas 2>/dev/null; then
    chmod +x /usr/local/bin/linpeas
    ok "linpeas"
else
    fail "linpeas"
fi

if curl -sL "https://github.com/carlospolop/PEASS-ng/releases/latest/download/winPEAS.bat" -o /usr/local/bin/winPEAS.bat 2>/dev/null; then
    chmod +x /usr/local/bin/winPEAS.bat
    ok "winPEAS"
else
    fail "winPEAS"
fi

# Nuclei templates
if command -v nuclei &>/dev/null; then
    if nuclei -up 2>/dev/null; then
        ok "nuclei-templates"
    else
        fail "nuclei-templates"
    fi
else
    skip "nuclei-templates (nuclei no instalado)"
fi
echo ""

# ========================================================================
# 6. VERIFICAR INSTALACIÓN
# ========================================================================
status "[6/6] Verificando instalación..."

VERIFY_TOOLS=(
    "nmap"
    "masscan"
    "netdiscover"
    "sqlmap"
    "nikto"
    "john"
    "hashcat"
    "hydra"
    "nuclei"
    "gobuster"
    "msfconsole"
)

for tool in "${VERIFY_TOOLS[@]}"; do
    if command -v $tool &>/dev/null; then
        ok "$tool"
    else
        fail "$tool"
    fi
done
echo ""

# ========================================================================
# RESUMEN
# ========================================================================
echo "╔═══════════════════════════════════════════════════════════════════╗"
echo "║                    📊 RESUMEN FINAL                          ║"
echo "╚═══════════════════════════════════════════════════════════════════╝"
echo ""
echo -e "  ${GREEN}Instaladas:${NC} $INSTALLED"
echo -e "  ${RED}Fallidas:${NC} $FAILED"
echo -e "  ${YELLOW}Omitidas:${NC} $SKIPPED"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✅ INSTALACIÓN COMPLETA - TODO OK${NC}"
else
    echo -e "${YELLOW}⚠️  Instalación completada con errores${NC}"
    echo ""
    echo "Para reinstallar una herramienta específica:"
    echo "  sudo apt install <nombre-paquete>"
fi

echo ""
echo "╔═══════════════════════════════════════════════════════════════════╗"
echo "║  🛡️  CyberSecurity Tools - INSTALADO                    ║"
echo "╚═══════════════════════════════════════════════════════════════════╝"
echo ""
echo "Ejecutar el launcher:"
echo "  cibersec"
echo ""
echo "O directamente una herramienta:"
echo "  nmap -sV 192.168.1.1"
echo ""