# 🛡️ CyberSecurity Tools

> **Instalador AUTOMÁTICO + Launcher v1.0** para Kali Linux.

Instala automáticamente herramientas de pentesting y las ejecuta desde un menú interactivo o CLI.

---

## ⚡ Instalación

```bash
# Clonar
git clone https://github.com/DavidsmSilva/CiberSecurity-Tools.git
cd CiberSecurity-Tools

# Instalar (todo automático)
sudo ./install.sh
```

---

## 🚀 Ejecución

```bash
# Launcher interactivo
cibersec

# O directamente
python3 main.py
```

---

## 📦 El instalador instala (~50 herramientas)

| Categoría | Herramientas |
|-----------|-------------|
| **Reconocimiento** | nmap, netdiscover, masscan, tcpdump, naabu, httpx, dnsx, subfinder, whatweb, nikto, gobuster |
| **Vulnerabilidades** | nuclei, sqlmap, commix |
| **Explotación** | msfconsole, msfvenom, searchsploit |
| **Web** | zaproxy, dirb |
| **Contraseñas** | hashcat, john, hydra, cewl, crunch |
| **Red/Sniffing** | wireshark, tcpdump, ettercap, bettercap, responder |
| **MitM** | ettercap, bettercap, responder, arpspoof |
| **Post-Explotación** | netcat, socat, linpeas |
| **AD** | enum4linux, ldapsearch, rpcclient |
| **Reversing** | ghidra, radare2, binwalk, foremost, gdb |
| **Utils** | tmux, proxychains |

---

## 📋 Opciones del Instalador

```bash
sudo ./install.sh              # Instalación completa
sudo ./install.sh --check      # Solo verificar (sin instalar)
sudo ./install.sh --force      # Forzar reinstalación
sudo ./install.sh -v           # Salida detallada
```

---

## 📋 Uso del CLI

```bash
# Verificar TODAS las herramientas instaladas
cibersec --check
cibersec -c

# Listar categorías
cibersec --list
cibersec -l

# Ejecutar herramienta directamente
cibersec 1 1                    # nmap interactivo
cibersec 1 1 -sV 192.168.1.1     # nmap con argumentos

# Modo interactivo
cibersec
```

---

## 📋 Menú Interactivo

```
╔════════════════════════════════════════════════════════════════╗
║      🛡️  CyberSecurity Tools - Launcher v2.2         ║
╚════════════════════════════════════════════════════════════════╝

#   Categoría                  Tools
1   Reconocimiento & Escaneo     11
2   Vulnerabilidades             3
3   Explotación                3
4   Web Pentesting              2
5   Contraseñas               5
6   Red & Sniffing            5
7   MitM & ARP Spoofing       4
8   Post-Explotación         3
9   Active Directory         3
10   Reversing & Forensics   5
11   Utilidades              2
```

---

## ⚠️ Aviso Legal

> **USO EXCLUSIVAMENTE EDUCATIVO Y AUTORIZADO**

- Labs controlados (DVWA, HTB)
- Auditorías autorizadas
- CTF y competencias

---

## 📝 Changelog

### v1.0 (2026-05)
- ✅ Bug fix: sintaxis Bash en install.sh (falta `;` antes de arrays)
- ✅ Bug fix: encoding Windows para emojis
- ✅ Agregado `--reinstall`: reinstallar herramienta específica
- ✅ Agregado `--update`: solo actualizar herramientas existentes
- ✅ Removidas herramientas duplicadas (ettercap, bettercap, responder)
- ✅ Modo `--check` funcional en Windows
- ✅ pyproject.toml actualizado a v1.0.0

### v2.2 (2026-05)
- ✅ Bug fix: `exploitdb` sin espacio
- ✅ Agregado `tcpdump` a herramientas
- ✅ Modo `--force`: forzar reinstalación
- ✅ Modo `--check`: verificar sin instalar
- ✅ Modo `--verbose`: salida detallada
- ✅ PATH de Go persistido en `.bashrc`

### v2.1 (2026-05)
- ✅ CLI arguments
- ✅ Modo check

### v2.0 (2026-05)
- ✅ Instalador automático