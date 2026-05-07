#!/bin/bash
# ========================================================================
#  CyberSecurity Tools - INSTALLER v2.1
#  Instalación automática con manejo de errores robusto
# ========================================================================

# No salir en error - continuar aun si falla algo
# set -e  # Deshabilitado para tolerancia a fallos

# ============================================================
# COLORES
# ============================================================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'
BOLD='\033[1m'

# ============================================================
# VARIABLES
# ============================================================
INSTALLED=()
FAILED=()
SKIPPED=()
START_TIME=$(date +%s)

# ============================================================
# FUNCIONES
# ============================================================

log_info() { echo -e "${CYAN}[INFO]${NC} $1"; }
log_ok() { echo -e "${GREEN}[OK]${NC} $1" INSTALLED+=("$1"); }
log_fail() { echo -e "${RED}[FAIL]${NC} $1" FAILED+=("$1"); }
log_skip() { echo -e "${YELLOW}[SKIP]${NC} $1" SKIPPED+=("$1"); }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }

# Banner
banner() {
    echo ""
    echo -e "${BOLD}╔═══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}║          🛡️  CyberSecurity Tools - INSTALLER v2.1          ║${NC}"
    echo -e "${BOLD}║               Instalación automática                     ║${NC}"
    echo -e "${BOLD}╚═══════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Verificar root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        log_warn "Ejecutar como root: sudo $0"
        exit 1
    fi
}

# Detectar SO
detect_os() {
    if [[ -f /etc/kali-release ]]; then
        OS="kali"
    elif [[ -f /etc/parrot-release ]]; then
        OS="parrot"
    elif [[ -f /etc/debian_version ]]; then
        OS="debian"
    else
        OS="unknown"
    fi
    log_info "Sistema: $OS"
}

# Verificar internet
check_internet() {
    log_info "Verificando conexión a internet..."
    if curl -s --max-time 5 https://github.com >/dev/null 2>&1; then
        log_ok "Conexión a internet"
    else
        log_warn "Sin internet - algunas herramientas no se instalarán"
    fi
}

# Instalar paquete APT
install_apt() {
    local pkg=$1
    if dpkg -l | grep -q "^ii  $pkg "; then
        log_skip "$pkg (ya instalado)"
        return 0
    fi
    if apt install -y -qq "$pkg" 2>/dev/null; then
        log_ok "$pkg"
        return 0
    else
        log_fail "$pkg"
        return 1
    fi
}

# Instalar paquete Python
install_pip() {
    local pkg=$1
    if pip3 show "$pkg" >/dev/null 2>&1; then
        log_skip "python-$pkg (ya instalado)"
        return 0
    fi
    if pip3 install -q "$pkg" 2>/dev/null; then
        log_ok "python-$pkg"
        return 0
    else
        log_fail "python-$pkg"
        return 1
    fi
}

# Instalador Go
install_go() {
    local tool=$1
    local name=$(echo "$tool" | cut -d'/' -f5)
    
    if command -v "$name" >/dev/null 2>&1; then
        log_skip "$name (ya instalado)"
        return 0
    fi
    
    # Agregar Go al PATH si no existe
    export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
    
    if go install "$tool"@latest 2>/dev/null; then
        log_ok "$name"
        return 0
    else
        log_fail "$name"
        return 1
    fi
}

# Descargar script
download_script() {
    local url=$1
    local dest=$2
    local name=$(basename "$dest")
    
    if [[ -f "$dest" ]]; then
        log_skip "$name (ya existe)"
        return 0
    fi
    
    if curl -sL "$url" -o "$dest" 2>/dev/null; then
        chmod +x "$dest"
        log_ok "$name"
        return 0
    else
        log_fail "$name"
        return 1
    fi
}

# Actualizar sistema
update_system() {
    log_info "Actualizando sistema..."
    apt update -qq 2>/dev/null || true
    apt upgrade -y -qq 2>/dev/null || true
    log_ok "Sistema actualizado"
}

# Instalar dependencias
install_deps() {
    log_info "Instalando dependencias..."
    
    local DEPS=(
        "git"
        "curl" 
        "wget"
        "build-essential"
        "python3"
        "python3-pip"
        "python3-venv"
        "ruby"
        "ruby-dev"
        "net-tools"
    )
    
    for dep in "${DEPS[@]}"; do
        install_apt "$dep"
    done
}

# Instalar Python packages
install_python_pkgs() {
    log_info "Instalando paquetes Python..."
    
    local PIP_PKGS=(
        "typer"
        "rich"
        "pwntools"
        "scapy"
        "impacket"
    )
    
    for pkg in "${PIP_PKGS[@]}"; do
        install_pip "$pkg"
    done
}

# Instalar herramientas APT
install_tools_apt() {
    log_info "Instalando herramientas APT..."
    
    # Reconocimiento
    install_apt "nmap"
    install_apt "netdiscover"
    install_apt "masscan"
    install_apt "net-tools"  # ya instalado
    
    # Web
    install_apt "nikto"
    install_apt "whatweb"
    install_apt "dirb"
    
    # Vulnerabilidades
    install_apt " exploitdb"
    install_apt "sqlmap"
    install_apt "commix"
    install_apt "zaproxy"
    
    # Metasploit
    install_apt "metasploit-framework"
    
    # Contraseñas
    install_apt "john"
    install_apt "hashcat"
    install_apt "hydra"
    install_apt "cewl"
    install_apt "crunch"
    
    # Red
    install_apt "wireshark"
    install_apt "ettercap-graphical"
    install_apt "bettercap"
    install_apt "responder"
    install_apt "netcat-traditional"
    install_apt "socat"
    
    # AD
    install_apt "enum4linux"
    install_apt "ldap-utils"
    install_apt "samba"
    
    # Reversing
    install_apt "ghidra"
    install_apt "radare2"
    install_apt "binwalk"
    install_apt "foremost"
    install_apt "gdb"
    
    # Utils
    install_apt "tmux"
    install_apt "proxychains"
    install_apt "dsniff"  # para arpspoof
}

# Instalar herramientas Go
install_tools_go() {
    log_info "Instalando herramientas Go..."
    
    # Verificar Go
    if ! command -v go >/dev/null 2>&1; then
        log_info "Instalando Go..."
        wget -q https://go.dev/dl/go1.21.5.linux-amd64.tar.gz -O /tmp/go.tar.gz
        tar -C /usr/local -xzf /tmp/go.tar.gz 2>/dev/null || true
        rm -f /tmp/go.tar.gz
    fi
    
    export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
    
    # Tools
    install_go "github.com/projectdiscovery/naabu/v2/cmd/naabu"
    install_go "github.com/projectdiscovery/httpx/cmd/httpx"
    install_go "github.com/projectdiscovery/dnsx/cmd/dnsx"
    install_go "github.com/projectdiscovery/subfinder/v2/cmd/subfinder"
    install_go "github.com/projectdiscovery/nuclei/v3/cmd/nuclei"
    install_go "github.com/OJ/gobuster/v3@latest"
}

# Instalar scripts adicionales
install_scripts() {
    log_info "Instalando scripts adicionales..."
    
    mkdir -p /usr/local/bin
    
    download_script "https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh" "/usr/local/bin/linpeas"
    download_script "https://github.com/carlospolop/PEASS-ng/releases/latest/download/winPEAS.bat" "/usr/local/bin/winPEAS.bat"
    
    # Nuclei templates
    if command -v nuclei >/dev/null 2>&1; then
        log_info "Actualizando Nuclei templates..."
        nuclei -up 2>/dev/null && log_ok "nuclei-templates" || log_fail "nuclei-templates"
    fi
}

# Instalar launcher
install_launcher() {
    log_info "Instalando launcher..."
    
    # Instalar con pip
    pip3 install -q -e . 2>/dev/null && log_ok "cibersec launcher" || log_warn "launcher (no se instaló como comando)"
    
    # Crear symlink directo
    ln -sf "$(pwd)/main.py" /usr/local/bin/cibersec 2>/dev/null && log_ok "symlink cibersec" || true
    chmod +x main.py
}

# Verificar instalación
verify_install() {
    log_info "Verificando herramientas..."
    
    local VERIFY=(
        "nmap"
        "masscan"
        "sqlmap"
        "nikto"
        "john"
        "hashcat"
        "hydra"
        "nuclei"
        "gobuster"
    )
    
    for tool in "${VERIFY[@]}"; do
        if command -v "$tool" >/dev/null 2>&1; then
            log_ok "$tool"
        else
            log_fail "$tool"
        fi
    done
}

# Resumen final
show_summary() {
    local end_time=$(date +%s)
    local duration=$((end_time - START_TIME))
    local minutes=$((duration / 60))
    local seconds=$((duration % 60))
    
    echo ""
    echo -e "${BOLD}╔═══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}║                    📊 RESUMEN FINAL                          ║${NC}"
    echo -e "${BOLD}╚═══════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "  ${GREEN}Instaladas:${NC} ${#INSTALLED[@]}"
    echo -e "  ${RED}Fallidas:${NC} ${#FAILED[@]}"
    echo -e "  ${YELLOW}Omitidas:${NC} ${#SKIPPED[@]}"
    echo -e "  ${BLUE}Tiempo:${NC} ${minutes}m ${seconds}s"
    echo ""
    
    if [[ ${#FAILED[@]} -eq 0 ]]; then
        echo -e "${GREEN}✅ INSTALACIÓN COMPLETA${NC}"
    else
        echo -e "${YELLOW}⚠️  Algunas herramientas no se instalaron${NC}"
        echo ""
        echo "Para reinstallar una herramienta específica:"
        echo "  sudo apt install <paquete>"
    fi
    
    echo ""
    echo -e "${BOLD}╔═══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}║  🛡️  CyberSecurity Tools - INSTALADO                   ║${NC}"
    echo -e "${BOLD}╚═════════════════════════════════════════════════════��═��═══════════╝${NC}"
    echo ""
    echo "Ejecutar: cibersec"
    echo ""
}

# ============================================================
# MAIN
# ============================================================

main() {
    banner
    check_root
    detect_os
    check_internet
    
    update_system
    install_deps
    install_python_pkgs
    install_tools_apt
    install_tools_go
    install_scripts
    install_launcher
    verify_install
    
    show_summary
}

# Ejecutar
main "$@"