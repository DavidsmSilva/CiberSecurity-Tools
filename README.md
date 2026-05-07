# 🛡️ CyberSecurity Tools

> **Instalador AUTOMÁTICO + Launcher** para Kali Linux.

Instala automáticamente herramientas de pentesting y las ejecuta desde un menú interactivo.

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

## 📦 El instalador instala:

| Categoría | Herramientas |
|-----------|-------------|
| **Reconocimiento** | nmap, netdiscover, masscan, naabu, httpx, dnsx, subfinder, whatweb, nikto, gobuster |
| **Vulnerabilidades** | nuclei, sqlmap, commix |
| **Explotación** | msfconsole, msfvenom, searchsploit |
| **Web** | zaproxy, dirb |
| **Contraseñas** | hashcat, john, hydra, cewl, crunch |
| **Red/Sniffing** | wireshark, tcpdump, ettercap, bettercap, responder |
| **Post-Explotación** | netcat, socat, linpeas |
| **AD** | enum4linux, ldapsearch, rpcclient |
| **Reversing** | ghidra, radare2, binwalk, foremost, gdb |
| **Utils** | tmux, proxychains |

---

## 📋 Menú del Launcher

```
╔════════════════════════════════════════════════════════════════╗
║      🛡️  CyberSecurity Tools - Launcher v2.0         ║
╚════════════════════════════════════════════════════════╝

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
11   Utilidades              3
```

Cada herramienta muestra:
- ✅ = instalada
- ❌ = no instalada (con comando para instalarla)

---

## ⚠️ Aviso Legal

> **USO EXCLUSIVAMENTE EDUCATIVO Y AUTORIZADO**

- Labs controlados (DVWA, HTB)
- Auditorías autorizadas
- CTF y competencias

---

## 📝 Changelog

### v2.0 (2026-05)
- ✅ install.sh v2.0 - instalación automática real
- ✅ main.py v2.0 - verifica herramientas antes de ejecutar
- ✅ Muestra estado ✅/❌ en el menú
- ✅ Comando de instalación si falta algo
- ✅ README corregido

### v1.x (2026-05)
- Versiones anteriores con installer básico