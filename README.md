# 🛡️ CyberSecurity Tools

> **Instalador COMPLETO + Launcher** para herramientas de pentesting en Kali Linux.

Un solo comando para instalar y ejecutar todas las herramientas que necesitás.

---

## ⚡ Instalación (primera vez)

```bash
# Clonar el repositorio
git clone https://github.com/DavidsmSilva/CiberSecurity-Tools.git

# Entrar al directorio
cd CiberSecurity-Tools

# Dar permisos de ejecución
chmod +x install.sh update.sh

# Ejecutar el instalador completo
sudo ./install.sh
```

---

## 🔄 Actualización (si ya lo tenías instalado)

```bash
# Entrar al directorio
cd CiberSecurity-Tools

# Descargar última versión
git pull

# Dar permisos
chmod +x install.sh update.sh

# Actualizar + verificar
sudo ./update.sh
```

---

## 📦 El instalador:

- ✅ Actualiza el sistema
- ✅ Instala todas las herramientas (~100+)
- ✅ Instala el launcher
- ✅ Actualiza Nuclei templates
- 🚀 **TOTAL: ~5-15 minutos**

---

## 🚀 Uso del Launcher

```bash
# Menú interactivo
cibersec

# Ver todas las categorías
cibersec --list

# Ver categoría específica
cibersec --category 1
cibersec -c 2

# Ejecutar herramienta directamente
cibersec -c 1 -t 1
```

---

## 📋 15 Categorías (~95 herramientas)

| # | Categoría | Herramientas |
|---|----------|-------------|
| 1 | Reconocimiento & Escaneo | nmap, masscan, naabu, httpx, dnsx... |
| 2 | OSINT | sherlock, theHarvester, cyberfind... |
| 3 | Vulnerabilidades | nuclei, nikto, OpenVAS |
| 4 | Explotación | msfconsole, sqlmap, commix, searchsploit |
| 5 | Web | burpsuite, zaproxy, dirb, gobuster |
| 6 | Contraseñas | hashcat, john, hydra, cewl, crunch |
| 7 | Red & MitM | wireshark, ettercap, bettercap, responder |
| 8 | Post-Explotación | linpeas, winpeas, netcat, socat, impacket |
| 9 | Active Directory | bloodhound, crackmapexec, enum4linux |
| 10 | Wordlists | SecLists, rockyou, PayloadsAllTheThings |
| 11 | CTF & Reverse | pwntools, ghidra, radare2, binwalk |
| 12 | Utilidades | tmux, proxychains, tor |
| 13 | Wireless | aircrack-ng, wifite, reaver |
| 14 | Social Engineering | SET, gophish, evilginx |
| 15 | C2 & Remote Access | sliver, mythic, pupy |

---

## 🕹️ Uso Interactivo

```
$ cibersec

╔═══════════════════════════════════════════════════════════════════════╗
║      🛡️  CyberSecurity Tools - Launcher v1.0                 ║
╚═══════════════════════════════════════════════════════════════════════╝

#   Categoría                  Herramientas
1   Reconocimiento & Escaneo    9 tools
2   OSINT                      5 tools
3   Vulnerabilidades          3 tools
...
13   Wireless Security        8 tools
14   Social Engineering    5 tools
15   C2 & Remote Access    6 tools

Selecciona una categoría (número): 1

▸ Reconocimiento & Escaneo

#   Herramienta    Descripción
1   nmap         Escáner de puertos estándar
2   netdiscover Descubrimiento de red local
3   masscan     Escaneo masivo
4   naabu      Port scanner rápido
5   httpx      HTTP toolkit
...

Selecciona una herramienta (número): 1

▸ Ejecutando: nmap
Nmap 7.94...
```

---

## 📝 Quick Reference

| Comando | Descripción |
|---------|-----------|
| `./install.sh` | Primera instalación |
| `./update.sh` | Actualizar + verificar tools |
| `cibersec` | Launcher interactivo |
| `cibersec --list` | Ver todas las tools |
| `cibersec -c 1` | Ver categoría 1 |

---

## ⚠️ Aviso Legal

> **USO EXCLUSIVAMENTE EDUCATIVO Y AUTORIZADO**

Para uso en:
- 🏋️ Labs controlados (DVWA, Hack The Box)
- 🔍 Auditorías autorizadas
- 🎯 CTF y competencias

---

## 📝 Changelog

### v1.2 (2026-05)
- ✅ README corregido con orden correcto
- ✅ Secciones separadas: instalación vs actualización

### v1.1 (2026-05)
- ✅ Instalador completo (`install.sh`)
- ✅ Instala ~100 herramientas automáticamente
- ✅ Reinstalar forzado
- ✅ Actualiza Nuclei
- ✅ Script de update + verificación (`update.sh`)

### v1.0 (2026-05)
- ✅ Launcher interactivo
- ✅ 15 categorías
- ✅ ~95 herramientas

---

**⭐ Si te sirve, dejá una estrella ⭐**