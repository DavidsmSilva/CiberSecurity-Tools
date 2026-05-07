# 🛡️ CyberSecurity Tools

> **Instalador AUTOMÁTICO + Launcher v2.1** para Kali Linux.

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
| **Reconocimiento** | nmap, netdiscover, masscan, naabu, httpx, dnsx, subfinder, whatweb, nikto, gobuster |
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

## 📋 Uso del CLI

```bash
# Verificar TODAS las herramientas instaladas
cibersec --check
cibersec -c

# Listar categorías
cibersec --list
cibersec -l

# Ver categoría específica
cibersec -c 1

# Ejecutar herramienta directamente
cibersec 1 1                    # nmap interactivo
cibersec 1 1 -sV 192.168.1.1     # nmap con argumentos
cibersec 5 1 -m 22000 hash.txt   # hashcat

# Modo interactivo
cibersec

# Versión
cibersec --version
```

---

## 📋 Menú Interactivo

```
╔════════════════════════════════════════════════════════════════╗
║      🛡️  CyberSecurity Tools - Launcher v2.1         ║
╚════════════════════════════════════════════════════════════════╝

#   Categoría                  Tools
1   Reconocimiento & Escaneo     10
2   Vulnerabilidades             3
3   Explotación                4
4   Web Pentesting              2
5   Contraseñas               5
6   Red & Sniffing            5
7   MitM & ARP Spoofing       4
8   Post-Explotación         3
9   Active Directory         3
10   Reversing & Forensics   5
11   Utilidades              2

Escribe 'c' para verificar todas las tools
```

---

## ⚠️ Aviso Legal

> **USO EXCLUSIVAMENTE EDUCATIVO Y AUTORIZADO**

- Labs controlados (DVWA, HTB)
- Auditorías autorizadas
- CTF y competencias

---

## 📝 Changelog

### v2.1 (2026-05)
- ✅ CLI arguments: `cibersec nmap -sV target`
- ✅ Modo `--check`: verifica todas las tools
- ✅ Mejor manejo de errores
- ✅ Verifica conexión a internet antes de descargar
- ✅ Contadores de éxito/fallo
- ✅ Tiempo total de instalación
- ✅ install.sh con funciones reutilizables

### v2.0 (2026-05)
- ✅ Instalador automático
- ✅ Launcher con verificación

### v1.x (2026-05)
- Versiones anteriores