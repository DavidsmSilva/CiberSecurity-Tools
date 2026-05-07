# 🛡️ CyberSecurity Tools

> **Launcher interactivo** para herramientas de pentesting en Kali Linux.

Un solo comando para ejecutar todas las herramientas que necesitás para tu trabajo de ciberseguridad.

## ⚡ Instalación

```bash
# Clonar el repositorio
git clone https://github.com/DavidsmSilva/CiberSecurity-Tools.git

# Entrar al directorio
cd CiberSecurity-Tools

# Instalar con pipx
pipx install .

# O instalar en modo desarrollo
pip install -e .
```

## 🚀 Uso

```bash
# Menú interactivo (recomendado)
cibersec

# Ver todas las categorías
cibersec --list

# Ver herramientas de una categoría
cibersec --category 1   # Reconocimiento
cibersec -c 2          # OSINT
cibersec -c 3          # Vulnerabilidades

# Ejecutar una herramienta
cibersec -c 1 -t 1    # nmap
cibersec -c 4 -t 3     # sqlmap

# o en modo interactivo:
# 1) Seleccionar categoría (número)
# 2) Seleccionar herramienta (número)
# 3) Se ejecuta automáticamente
```

## 📋 Categorías Disponibles

| # | Categoría | Herramientas |
|---|----------|-------------|
| 1 | Reconocimiento & Escaneo | nmap, masscan, naabu, httpx, dnsx, subfinder, whatweb, nikto |
| 2 | OSINT | sherlock, theHarvester, cyberfind, Linkook, Blackbird |
| 3 | Vulnerabilidades | nuclei, nikto, OpenVAS |
| 4 | Explotación | msfconsole, msfvenom, sqlmap, commix, searchsploit |
| 5 | Web | burpsuite, zaproxy, dirb, gobuster, wfuzz, XSStrike |
| 6 | Contraseñas | hashcat, john, hydra, cewl, crunch, cupp |
| 7 | Red & MitM | wireshark, ettercap, bettercap, responder, macchanger |
| 8 | Post-Explotación | netcat, socat, linpeas, winpeas, mimikatz, impacket |
| 9 | Active Directory | bloodhound, sharphound, crackmapexec, enum4linux, evil-winrm |
| 10 | Wordlists & Recursos | SecLists, rockyou, PayloadsAllTheThings |
| 11 | CTF & Reverse | pwntools, ghidra, radare2, binwalk, foremost |
| 12 | Utilidades | tmux, proxychains, tor, git, python3, pip3 |

## 🕹️ Uso Interactivo

```
$ cibersec

╔════════════════════════════════════════════════════════════════╗
║      🛡️  CyberSecurity Tools - Launcher v1.0            ║
╚═══════════════════════════════════════════════════════════╝

#   Categoría                  Herramientas
1   Reconocimiento & Escaneo    9 tools
2   OSINT                    5 tools
3   Vulnerabilidades         3 tools
4   Explotación              6 tools
5   Web                     6 tools
6   Contraseñas              6 tools
7   Red & MitM               5 tools
8   Post-Explotación         6 tools
9   Active Directory         6 tools
10  Wordlists & Recursos      3 tools
11  CTF & Reverse          6 tools
12  Utilidades              6 tools

Selecciona una categoría (número): 1

▸ Reconocimiento & Escaneo

#   Herramienta    Descripción
1   nmap         Escáner de puertos estándar
2   netdiscover Descubrimiento de red local (ARP)
3   masscan     Escaneo masivo de Internet
4   naabu      Port scanner rápido (Go)
5   httpx       HTTP toolkit para probing
6   dnsx       DNS enumeration
7   subfinder  Subdomain enumeration
8   whatweb    Identificación de tecnologías
9   nikto      Escaneo de vulnerabilidades web

Selecciona una herramienta (número) o 'b' para volver: 1

▸ Ejecutando: nmap
Comando: nmap -h

Nmap 7.94 ( https://nmap.org )
...
```

## 🔧 Requisitos

- **Kali Linux** (recomendado) o **Parrot OS**
- Python 3.9+
- Acceso a internet

## ⚠️ Aviso Legal

> **USO EXCLUSIVAMENTE EDUCATIVO Y AUTORIZADO**

Este toolkit está diseñado para:
- 🏋️ Práctica en laboratorios controlados (DVWA, Hack The Box)
- 🔍 Auditorías de seguridad autorizadas
- 🎯 CTF y competencias de ciberseguridad

**Usar en sistemas sin autorización es ILEGAL y está penado por la ley.**

---

## 📝 Changelog

### v1.0 (2026-05)
- ✅ Lanzamiento inicial
- ✅ Launcher interactivo
- ✅ ~70 herramientas categorizadas
- ✅ Ejecución directa desde el menú

---

## 🤝 Contribuir

Fork y pull requests bienvenidos.

**⭐ Si te sirve, dejá una estrella ⭐**