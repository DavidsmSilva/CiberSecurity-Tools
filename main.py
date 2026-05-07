#!/usr/bin/env python3
"""
CyberSecurity Tools - Launcher
Menú interactivo para ejecutar herramientas de pentesting
"""
import os
import sys
import subprocess
from pathlib import Path
import shlex

try:
    import typer
    from rich.console import Console
    from rich.table import Table
    from rich.panel import Panel
except ImportError:
    subprocess.run([sys.executable, "-m", "pip", "install", "typer", "rich"], check=True)
    import typer
    from rich.console import Console
    from rich.table import Table
    from rich.panel import Panel

console = Console()

# ============================================================
# HERRAMIENTAS DISPONIBLES
# ============================================================

TOOLS = {
    # --- RECONOCIMIENTO & ESCANEO ---
    "1": {
        "category": "Reconocimiento & Escaneo",
        "tools": [
            {"name": "nmap", "desc": "Escáner de puertos estándar", "cmd": "nmap -h"},
            {"name": "netdiscover", "desc": "Descubrimiento de red local (ARP)", "cmd": "netdiscover -h"},
            {"name": "masscan", "desc": "Escaneo masivo de Internet", "cmd": "masscan --help"},
            {"name": "naabu", "desc": "Port scanner rápido (Go)", "cmd": "naabu -h"},
            {"name": "httpx", "desc": "HTTP toolkit para probing", "cmd": "httpx -h"},
            {"name": "dnsx", "desc": "DNS enumeration", "cmd": "dnsx -h"},
            {"name": "subfinder", "desc": "Subdomain enumeration", "cmd": "subfinder -h"},
            {"name": "whatweb", "desc": "Identificación de tecnologías", "cmd": "whatweb -h"},
            {"name": "nikto", "desc": "Escaneo de vulnerabilidades web", "cmd": "nikto -h"},
        ]
    },
    # --- OSINT ---
    "2": {
        "category": "OSINT",
        "tools": [
            {"name": "sherlock", "desc": "Búsqueda de usernames en redes sociales", "cmd": "sherlock -h"},
            {"name": "theHarvester", "desc": "Emails, subdominios y hosts", "cmd": "theHarvester -h"},
            {"name": "cyberfind", "desc": "OSINT toolkit avanzado", "cmd": "cyberfind -h"},
            {"name": "Linkook", "desc": "Social media recon + emails", "cmd": "linkook -h"},
            {"name": "Blackbird", "desc": "Username + email search", "cmd": "blackbird -h"},
        ]
    },
    # --- VULNERABILIDADES ---
    "3": {
        "category": "Vulnerabilidades",
        "tools": [
            {"name": "nuclei", "desc": "Vulnerability scanner con templates", "cmd": "nuclei -h"},
            {"name": "nikto", "desc": "Web server scanner", "cmd": "nikto -h"},
            {"name": "OpenVAS", "desc": "Vulnerability scanner (Docker)", "cmd": "docker run -it greenbone/openvas"},
        ]
    },
    # --- EXPLOTACIÓN ---
    "4": {
        "category": "Explotación",
        "tools": [
            {"name": "msfconsole", "desc": "Metasploit Framework", "cmd": "msfconsole"},
            {"name": "msfvenom", "desc": "Generador de payloads", "cmd": "msfvenom -h"},
            {"name": "sqlmap", "desc": "SQL Injection automation", "cmd": "sqlmap -h"},
            {"name": "commix", "desc": "Command Injection", "cmd": "commix -h"},
            {"name": "searchsploit", "desc": "Buscar exploits", "cmd": "searchsploit -h"},
            {"name": "exploitdb", "desc": "Base de datos de exploits", "cmd": "searchsploit -h"},
        ]
    },
    # --- WEB PENTESTING ---
    "5": {
        "category": "Web Pentesting",
        "tools": [
            {"name": "burpsuite", "desc": "Proxy web (Community)", "cmd": "burpsuite"},
            {"name": "zaproxy", "desc": "OWASP ZAP scanner", "cmd": "zap-x.sh 2>/dev/null || zap -h"},
            {"name": "dirb", "desc": "Directory busting", "cmd": "dirb"},
            {"name": "gobuster", "desc": "Directory/DNS brute force", "cmd": "gobuster -h"},
            {"name": "wfuzz", "desc": "Web fuzzer", "cmd": "wfuzz -h"},
            {"name": " XSStrike", "desc": "XSS scanner", "cmd": "xsstrike -h"},
        ]
    },
    # --- CONTRASEÑAS ---
    "6": {
        "category": "Contraseñas",
        "tools": [
            {"name": "hashcat", "desc": "Cracking con GPU", "cmd": "hashcat -h"},
            {"name": "john", "desc": "John the Ripper (CPU)", "cmd": "john --help"},
            {"name": "hydra", "desc": "Brute force paralelo", "cmd": "hydra -h"},
            {"name": "cewl", "desc": "Generador de wordlists", "cmd": "cewl -h"},
            {"name": "crunch", "desc": "Generador de wordlists", "cmd": "crunch -h"},
            {"name": "cupp", "desc": "Wordlists personalizadas", "cmd": "cupp -h"},
        ]
    },
    # --- RED & MitM ---
    "7": {
        "category": "Red & MitM",
        "tools": [
            {"name": "wireshark", "desc": "Sniffer de red", "cmd": "wireshark -h &"},
            {"name": "ettercap", "desc": "MitM clásico", "cmd": "ettercap -h"},
            {"name": "bettercap", "desc": "MitM moderno", "cmd": "bettercap -h"},
            {"name": "responder", "desc": "LLMNR/NBT-NS poisoning", "cmd": "responder -h"},
            {"name": "macchanger", "desc": "Cambiar MAC address", "cmd": "macchanger -h"},
        ]
    },
    # --- POST-EXPLOTACIÓN ---
    "8": {
        "category": "Post-Explotación",
        "tools": [
            {"name": "netcat", "desc": "Reverse shells", "cmd": "nc -h"},
            {"name": "socat", "desc": "Relay multiplataforma", "cmd": "socat -h"},
            {"name": "linpeas", "desc": "Linux Privilege Escalation", "cmd": "/usr/local/bin/linpeas -h 2>/dev/null || echo 'Ejecutar: linpeas.sh'"},
            {"name": "winpeas", "desc": "Windows Privilege Escalation", "cmd": "/usr/local/bin/winPEAS.bat -h 2>/dev/null || echo 'Ejecutar en Windows'"},
            {"name": "mimikatz", "desc": "Windows credentials (Docker)", "cmd": "docker run -it mitmproxy/mimikatz"},
            {"name": "impacket", "desc": "Windows protocols", "cmd": "secretsdump -h 2>/dev/null || impacket-secretsdump -h"},
        ]
    },
    # --- ACTIVE DIRECTORY ---
    "9": {
        "category": "Active Directory",
        "tools": [
            {"name": "bloodhound", "desc": "AD attack path mapping", "cmd": "bloodhound -h 2>/dev/null || bloodhound --help"},
            {"name": "sharphound", "desc": "Data collector para BloodHound", "cmd": "sharphound -h"},
            {"name": "crackmapexec", "desc": "AD exploitation", "cmd": "crackmapexec -h"},
            {"name": "enum4linux", "desc": "SMB enumeration", "cmd": "enum4linux -h"},
            {"name": "evil-winrm", "desc": "WinRM shell", "cmd": "evil-winrm -h"},
            {"name": "ldapsearch", "desc": "LDAP queries", "cmd": "ldapsearch -h"},
        ]
    },
    # --- WORDLISTS & RECURSOS ---
    "10": {
        "category": "Wordlists & Recursos",
        "tools": [
            {"name": "SecLists", "desc": "Colección completa", "cmd": "ls /opt/SecLists 2>/dev/null || echo 'No instalado'"},
            {"name": "rockyou", "desc": "Wordlist clásica", "cmd": "ls /usr/share/wordlists/rockyou.txt 2>/dev/null | head -1"},
            {"name": "PayloadsAllTheThings", "desc": "Referencia de payloads", "cmd": "ls /opt/PayloadsAllTheThings 2>/dev/null || echo 'No instalado'"},
        ]
    },
    # --- CTF & REVERSE ---
    "11": {
        "category": "CTF & Reverse Engineering",
        "tools": [
            {"name": "pwntools", "desc": "CTF framework", "cmd": "python3 -c 'import pwn; print(pwn)'"},
            {"name": "ghidra", "desc": "Decompiler", "cmd": "ghidra 2>/dev/null || ghidraHeadless -h 2>/dev/null || echo 'No instalado'"},
            {"name": "radare2", "desc": "Binary analysis", "cmd": "r2 -h"},
            {"name": "binwalk", "desc": "Embedded files", "cmd": "binwalk --help"},
            {"name": "foremost", "desc": "File carving", "cmd": "foremost -h"},
            {"name": "strings", "desc": "Extraer strings", "cmd": "strings -h"},
        ]
    },
    # --- UTILIDADES ---
    "12": {
        "category": "Utilidades",
        "tools": [
            {"name": "tmux", "desc": "Terminal multiplexer", "cmd": "tmux -h"},
            {"name": "proxychains", "desc": "Proxy chaining", "cmd": "proxychains4 -h"},
            {"name": "tor", "desc": "Red Onion Router", "cmd": "tor --h"},
            {"name": "git", "desc": "Control de versiones", "cmd": "git -h"},
            {"name": "python3", "desc": "Intérprete Python", "cmd": "python3 -h"},
            {"name": "pip3", "desc": "Gestor de paquetes", "cmd": "pip3 -h"},
        ]
    },
    # --- WIRELESS SECURITY ---
    "13": {
        "category": "Wireless Security",
        "tools": [
            {"name": "aircrack-ng", "desc": "Cracking WEP/WPA/WPA2", "cmd": "aircrack-ng --help"},
            {"name": "wifite", "desc": "Automatizar wireless attacks", "cmd": "wifite -h"},
            {"name": "reaver", "desc": "WPS cracking", "cmd": "reaver -h"},
            {"name": "bully", "desc": "WPS attacker", "cmd": "bully -h"},
            {"name": "mdk4", "desc": "DoS attacks", "cmd": "mdk4 --help"},
            {"name": "cowpatty", "desc": "WPA handshakes", "cmd": "cowpatty --help"},
            {"name": "airodump-ng", "desc": "Capturar handshakes", "cmd": "airodump-ng --help"},
            {"name": "aireplay-ng", "desc": "Inject packets", "cmd": "aireplay-ng --help"},
        ]
    },
    # --- SOCIAL ENGINEERING ---
    "14": {
        "category": "Social Engineering",
        "tools": [
            {"name": "setoolkit", "desc": "Social-Engineer Toolkit", "cmd": "setoolkit"},
            {"name": "gophish", "desc": "Open source phishing", "cmd": "gophish -h"},
            {"name": "evilginx", "desc": "MitM phishing proxy", "cmd": "evilginx -h"},
            {"name": "hiddeneye", "desc": "Phishing con Ngrok", "cmd": "hiddeneye -h"},
            {"name": "nexphish", "desc": "Phishing scanner", "cmd": "nexphish -h"},
        ]
    },
    # --- C2 & REMOTE ACCESS ---
    "15": {
        "category": "C2 & Remote Access",
        "tools": [
            {"name": "sliver", "desc": "C2 moderno (Go)", "cmd": "sliver -h"},
            {"name": "mythic", "desc": "C2 con API/GUI", "cmd": "mythic config -h"},
            {"name": "pupy", "desc": "RAT multi-plataforma", "cmd": "pupy -h"},
            {"name": "koadic", "desc": "C2 via JavaScript/WMI", "cmd": "koadic -h"},
            {"name": "covenant", "desc": ".NET C2 framework", "cmd": "covenant -h"},
            {"name": "metasploit", "desc": "Handler de payloads", "cmd": "msfconsole -h"},
        ]
    },
}


def show_categories():
    """Muestra todas las categorías"""
    console.print("\n")
    console.print("[bold cyan]╔════════════════════════════════════════════════════════════════╗[/bold cyan]")
    console.print("[bold cyan]║      🛡️  CyberSecurity Tools - Launcher v1.0            ║[/bold cyan]")
    console.print("[bold cyan]╚══════��═��═══════════════════════════════════════════════════════╝[/bold cyan]")
    console.print("")
    
    table = Table(show_header=True, header_style="bold cyan")
    table.add_column("#", style="cyan", width=4)
    table.add_column("Categoría", style="white")
    table.add_column("Herramientas", style="dim")
    
    for key, val in TOOLS.items():
        count = len(val["tools"])
        table.add_row(key, val["category"], f"{count} tools")
    
    console.print(table)
    console.print("")


def show_tools(category: str):
    """Muestra las herramientas de una categoría"""
    if category not in TOOLS:
        console.print(f"[red]Categoría inválida: {category}[/red]")
        return
    
    cat = TOOLS[category]
    console.print(f"\n[bold cyan]▸ {cat['category']}[/bold cyan]\n")
    
    table = Table(show_header=True, header_style="bold cyan")
    table.add_column("#", style="cyan", width=4)
    table.add_column("Herramienta", style="white")
    table.add_column("Descripción", style="dim")
    
    for idx, tool in enumerate(cat["tools"], 1):
        table.add_row(f"{idx}", tool["name"], tool["desc"])
    
    console.print(table)
    console.print("")


def run_tool(category: str, tool_idx: int):
    """Ejecuta una herramienta"""
    if category not in TOOLS:
        console.print(f"[red]Categoría inválida[/red]")
        return
    
    cat = TOOLS[category]
    if tool_idx < 1 or tool_idx > len(cat["tools"]):
        console.print(f"[red]Índice inválido[/red]")
        return
    
    tool = cat["tools"][tool_idx - 1]
    cmd = tool["cmd"]
    
    console.print(f"\n[green]▸ Ejecutando: {tool['name']}[/green]")
    console.print(f"[dim]Comando: {cmd}[/dim]\n")
    
    # Ejecutar el comando
    try:
        # Determinar si es comando interactivo
        interactive = tool.get("interactive", False)
        
        result = subprocess.run(
            cmd,
            shell=True,
            executable="/bin/bash" if os.name != "nt" else "cmd.exe"
        )
        
        console.print(f"\n[yellow]→ Herramienta finalizada (código: {result.returncode})[/yellow]")
        
    except KeyboardInterrupt:
        console.print("\n[yellow]✗ Ejecución cancelada por el usuario[/yellow]")
    except FileNotFoundError:
        console.print(f"[red]✗ Herramienta no encontrada: {tool['name']}[/red]")
        console.print(f"[dim]¿Está instalada? Instala con: apt install {tool['name']}[/dim]")
    except Exception as e:
        console.print(f"[red]✗ Error: {e}[/red]")


def interactive_menu():
    """Menú interactivo"""
    while True:
        show_categories()
        
        console.print("[bold]Selecciona una categoría (número):[/bold] ", end="")
        category = input().strip()
        
        if category == "q" or category == "quit" or category == "exit":
            console.print("[cyan]¡Hasta luego! 👋[/cyan]")
            break
        
        if category == "0":
            show_menu_all()
            continue
            
        if category not in TOOLS:
            console.print(f"[red]✗ Categoría inválida[/red]")
            continue
        
        # Mostrar herramientas de la categoría
        show_tools(category)
        
        console.print("[bold]Selecciona una herramienta (número) o 'b' para volver:[/bold] ", end="")
        tool_idx = input().strip()
        
        if tool_idx == "b" or tool_idx == "back":
            continue
        if tool_idx == "q":
            break
            
        try:
            idx = int(tool_idx)
            run_tool(category, idx)
        except ValueError:
            console.print(f"[red]✗ Índice inválido[/red]")
        
        console.print("\n[dim]Presiona Enter para continuar...[/dim]")
        input()


def show_menu_all():
    """Muestra todas las herramientas"""
    for key, cat in TOOLS.items():
        show_tools(key)


def main(
    category: str = typer.Option(None, "-c", "--category", help="Categoría a mostrar"),
    tool: int = typer.Option(None, "-t", "--tool", help="Índice de herramienta a ejecutar"),
    list_all: bool = typer.Option(False, "-l", "--list", help="Listar todas las herramientas"),
    interactive: bool = typer.Option(False, "-i", "--interactive", help="Menú interactivo"),
):
    """CyberSecurity Tools - Launcher"""
    
    # Si no hay argumentos, mostrar menú interactivo
    if len(sys.argv) == 1:
        interactive_menu()
        return
    
    # Listar todas
    if list_all:
        show_menu_all()
        return
    
    # Mostrar categoría específica
    if category:
        show_tools(category)
        # Si también hay tool, ejecutarla
        if tool:
            run_tool(category, tool)
        return
    
    # Mostrar todas las categorías
    show_categories()


if __name__ == "__main__":
    typer.run(main)