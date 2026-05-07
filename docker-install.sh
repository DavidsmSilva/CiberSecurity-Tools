#!/bin/bash
# Docker + DVWA + Laboratorios vulneráveis
# CyberSecurity Tools - Laboratorios Docker

set -e

CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo ""
echo "========================================"
echo "  Docker + Laboratorios Vulnerables"
echo "========================================"
echo ""

# Instalar Docker
echo "${CYAN}[1/4] Instalando Docker...${NC}"
if command -v docker &>/dev/null; then
    echo "${GREEN}Docker ya instalado${NC}"
else
    # Detectar SO
    if [ -f /etc/kali-release ]; then
        # Kali Linux
        apt update
        apt install -y docker.io docker-compose
        systemctl start docker
        systemctl enable docker
    elif [ -f /etc/debian_version ]; then
        # Debian/Ubuntu
        apt update
        apt install -y docker.io docker-compose
        systemctl start docker
        systemctl enable docker
    elif command -v pacman &>/dev/null; then
        # Arch
        pacman -Syu docker docker-compose
        systemctl start docker
    fi
fi
echo "${GREEN}[OK] Docker${NC}"
echo ""

# Docker Compose
echo "${CYAN}[2/4] Docker Compose...${NC}"
if command -v docker-compose &>/dev/null; then
    echo "${GREEN}Ya instalado${NC}"
else
    if command -v pip3 &>/dev/null; then
        pip3 install docker-compose
    fi
fi
echo "${GREEN}[OK] Docker Compose${NC}"
echo ""

# Laboratorios
echo "${CYAN}[3/4] BajandoLaboratorios...${NC}"
mkdir -p /opt/labs
cd /opt/labs

# DVWA
if [ ! -d DVWA ]; then
    echo "  📥 DVWA..."
    git clone --depth 1 https://github.com/digininja/DVWA.git
    echo "  ✅ DVWA"
fi

# Metasploitable 2 (si hay enlace)
# git clone --depth 1 https://github.com/rapid7/metasploitable2.git

echo "${GREEN}[OK] Laboratorios${NC}"
echo ""

# Crear docker-compose.yml
echo "${CYAN}[4/4] Creando docker-compose.yml...${NC}"
cat > /opt/labs/docker-compose.yml << 'EOF'
version: '3'

services:
  dvwa:
    image: vulnerabilityweb/dvwa
    container_name: dvwa_lab
    ports:
      - "8080:80"
    environment:
      - PUERTO=80
    privileged: true
    restart: unless-stopped

networks:
  default:
    driver: bridge
EOF

echo "${GREEN}[OK] docker-compose.yml${NC}"
echo ""

# Fin
echo "========================================"
echo "  LABORAORIOS LISTOS"
echo "========================================"
echo ""
echo "Ejecutar DVWA:"
echo "  cd /opt/labs"
echo "  docker-compose up -d"
echo ""
echo "Acceder:"
echo "  http://localhost:8080"
echo "  Usuario: admin"
echo "  Contraseña: password"
echo ""