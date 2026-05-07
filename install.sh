#!/bin/bash
# ════════════════════════════════════════════════════════════════════════════
#  CyberSecurity Tools - INSTALLER COMPLETO
#  Instala todo el toolkit desde cero
# ════════════════════════════════════════════════════════════════════════════

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Función para mostrar progreso
progress() {
    echo -e "${CYAN}[→]${NC} $1"
}

success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[!]${NC} $1"
}

error() {
    echo -e "${RED}[✗]${NC} $1"
}

# Banner
echo ""
echo "╔═══════════════════════════════════════════════════════════════════╗"
echo "║     🛡️  CyberSecurity Tools - INSTALLER v1.0                 ║"
echo "║     Instalación completa de todas las herramientas         ║"
echo "╚═══════════════════════════════════════════════════════════════════╝"
echo ""

# Verificar root
if [[ $EUID -ne 0 ]]; then
    warn "Recomendado ejecutar como root: sudo ./install.sh"
    echo ""
fi

# Detectar SO
if [[ -f /etc/kali-release ]]; then
    OS="kali"
elif [[ -f /etc/parrot-release ]]; then
    OS="parrot"
else
    OS="debian"
fi

progress "SO detectado: $OS"
progress " Python: $(python3 --version 2>&1 | grep -oP '\d+\.\d+')"
echo ""

# ════════════════════════════════════════════════════════════════════════════
# 1. ACTUALIZAR SISTEMA
# ════════════════════════════════════════════════════════════════════════════

progress "Actualizando sistema..."
apt update -qq 2>/dev/null || true
apt upgrade -y -qq 2>/dev/null || true
success "Sistema actualizado"
echo ""

# ════════════════════════════════════════════════════════════════════════════
# 2. INSTALAR DEPENDENCIAS BASE
# ════════════════════════════════════════════════════════════════════════════

progress "Instalando dependencias base..."

# Git, curl, wget
apt install -y git curl wget build-essential 2>/dev/null || true

# Python y pip
apt install -y python3 python3-pip python3-venv 2>/dev/null || true

# Ruby
apt install -y ruby ruby-dev 2>/dev/null || true

# Go
if ! command -v go &>/dev/null; then
    progress "Instalando Go..."
    wget -q https://go.dev/dl/go1.21.5.linux-amd64.tar.gz -O /tmp/go.tar.gz
    tar -C /usr/local -xzf /tmp/go.tar.gz 2>/dev/null || true
    rm /tmp/go.tar.gz
fi

# Añadir Go al PATH
export PATH=$PATH:/usr/local/go/bin
success "Dependencias base instaladas"
echo ""

# ════════════════════════════════════════════════════════════════════════════
# 3. INSTALAR PAQUETES PYTHON
# ════════════════════════════════════════════════════════════════════════════

progress "Instalando paquetes Python..."

pip3 install --upgrade pip -q 2>/dev/null || true
pip3 install typer rich -q 2>/dev/null || true
pip3 install pwntools scapy impacket -q 2>/dev/null || true

success "Paquetes Python instalados"
echo ""

# ════════════════════════════════════════════════════════════════════
# 4. INSTALAR HERRAMIENTAS DEL SISTEMA (APT)
# ════════════════════════════════════════════════════════════════════════════

progress "Instalando herramientas del sistema..."

# Herramientas de red
apt install -y nmap netdiscover masscan 2>/dev/null || true

# Escaneo
apt install -y nikto whatweb 2>/dev/null || true

# Explotación
apt install -y metasploit-framework exploitdb sqlmap 2>/dev/null || true

# Web
apt install -y zaproxy dirb 2>/dev/null || true

# Contraseñas
apt install -y john hashcat hydra cewl crunch 2>/dev/null || true

# Red
apt install -y wireshark ettercap-graphical bettercap 2>/dev/null || true

# Post-explotación
apt install -y netcat-traditional socat 2>/dev/null || true

# AD
apt install -y enum4linux ldap-utils 2>/dev/null || true

# CTF
apt install -y binwalk foremost radare2 ghidra gdb 2>/dev/null || true

# Utilidades
apt install -y tmux screen proxychains4 macchanger 2>/dev/null || true

# Wordlists
apt install -y wordlists 2>/dev/null || true

success "Herramientas del sistema instaladas"
echo ""

# ════════════════════════════════════════════════════════════════════════════
# 5. INSTALAR HERRAMIENTAS GO
# ════════════════════════════════════════════════════════════════════

# Spinner function
spin() {
    spinner='|/-'
    i=0
    while kill -0 $1 2>/dev/null; do
        printf "\r[%c] %s" "${spinner:i++%4:1}" "$2"
        sleep 0.1
    done
    printf "\r[✓] %s完成\n" "$2"
}

progress "Instalando herramientas Go... (puede tardar 5-10 min)"

export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# ProjectDiscovery tools con loading
echo "  📦 naabu (port scanner)..."
go install github.com/projectdiscovery/naabu/v2/cmd/naabu@latest 2>/dev/null &
wait

echo "  📦 httpx (HTTP toolkit)..."
go install github.com/projectdiscovery/httpx/cmd/httpx@latest 2>/dev/null &
wait

echo "  📦 dnsx (DNS enumeration)..."
go install github.com/projectdiscovery/dnsx/cmd/dnsx@latest 2>/dev/null &
wait

echo "  📦 subfinder (subdomains)..."
go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest 2>/dev/null &
wait

echo "  📦 nuclei (vulnerability scanner)..."
go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest 2>/dev/null &
wait

echo "  📦 gobuster (directory brute)..."
go install github.com/OJ/gobuster/v3@latest 2>/dev/null &
wait

success "Herramientas Go instaladas"
echo ""

# ════════════════════════════════════════════════════════════════════════════
# 6. CLONAR REPOSITORIOS
# ══════════════════════════════════════════════════════════���═��═══════════════

progress "Clonando repositorios..."

# Crear directorio
mkdir -p /opt

# SecLists
if [ ! -d /opt/SecLists ]; then
    git clone --depth 1 https://github.com/danielmiessler/SecLists.git /opt/SecLists 2>/dev/null || true
fi

# PayloadsAllTheThings
if [ ! -d /opt/PayloadsAllTheThings ]; then
    git clone --depth 1 https://github.com/swisskyrepo/PayloadsAllTheThings.git /opt/PayloadsAllTheThings 2>/dev/null || true
fi

# Responder
if [ ! -d /opt/Responder ]; then
    git clone --depth 1 https://github.com/sbzar/Responder.git /opt/Responder 2>/dev/null || true
fi

# theHarvester
if [ ! -d /opt/theHarvester ]; then
    git clone --depth 1 https://github.com/laramies/theHarvester.git /opt/theHarvester 2>/dev/null || true
fi

# PEASS
if [ ! -d /opt/PEASS ]; then
    git clone --depth 1 https://github.com/carlospolop/PEASS-ng.git /opt/PEASS 2>/dev/null || true
fi

success "Repositorios clonados"
echo ""

# ════════════════════════════════════════════════════════════════════════════
# 7. DESCARGAR SCRIPTS DE PRIVILEGE ESCALATION
# ════════════════════════════════════════════════════════════════════════════

progress "Descargando scripts de privilege escalation..."

mkdir -p /usr/local/bin

# LinPEAS
curl -sL https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh -o /usr/local/bin/linpeas 2>/dev/null || true
chmod +x /usr/local/bin/linpeas 2>/dev/null || true

# WinPEAS
curl -sL https://github.com/carlospolop/PEASS-ng/releases/latest/download/winPEAS.bat -o /usr/local/bin/winPEAS.bat 2>/dev/null || true
chmod +x /usr/local/bin/winPEAS.bat 2>/dev/null || true

success "Scripts de privilege escalation descargados"
echo ""

# ════════════════════════════════════════════════════════════════════════════
# 8. INSTALAR ELPrograma principal
# ════════════════════════════════════════════════════════════════════════════

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd"

progress "Instalando CyberSecurity Tools..."

# Desinstalar versión anterior si existe
pipx uninstall cibersecurity-tools 2>/dev/null || true
pip3 uninstall cibersecurity-tools 2>/dev/null || true

# Instalar nueva versión
cd "$SCRIPT_DIR"
pipx install . 2>/dev/null || pip3 install -e . 2>/dev/null || true

success "CyberSecurity Tools instalado"
echo ""

# ════════════════════════════════════════════════════════════════════════════
# 9. ACTUALIZAR NUCLEI TEMPLATES
# ════════════════════════════════════════════════════════════════════════════

progress "Actualizando Nuclei templates..."
nuclei -up 2>/dev/null || true
success "Nuclei actualizado"
echo ""

# ════════════════════════════════════════════════════════════════════════════
# FIN
# ════════════════���═���═════════════════════════════════════════════════════════

echo ""
echo "╔═══════════════════════════════════════════════════════════════════╗"
echo "║           🛡️  INSTALACIÓN COMPLETA                        ║"
echo "╚═══════════════════════════════════════════════════════════════════╝"
echo ""
echo "  Para ejecutar:"
echo "    cibersec"
echo ""
echo "  Para actualizar:"
echo "    ./install.sh"
echo ""
echo -e "${GREEN}¡Listo para usar! 🛡️${NC}"
echo ""