#!/usr/bin/env python3
"""
CyberSecurity Tools - Launcher Interactivo
Ejecuta herramientas directamente en terminal
"""
import os
import sys
import subprocess
from pathlib import Path

try:
    import typer
    from rich.console import Console
    from rich.table import Table
except ImportError:
    subprocess.run([sys.executable, "-m", "pip", "install", "typer", "rich"], check=True)
    import typer
    from rich.console import Console
    from rich.table import Table

console = Console()

# ============================================================
# HERRAMIENTAS
# ============================================================

TOOLS = {
    "1": {"category": "Reconocimiento & Escaneo", "tools": [
        {"name": "nmap", "cmd": "nmap"},
        {"name": "netdiscover", "cmd": "netdiscover"},
        {"name": "masscan", "cmd": "masscan"},
        {"name": "naabu", "cmd": "naabu"},
        {"name": "httpx", "cmd": "httpx"},
        {"name": "dnsx", "cmd": "dnsx"},
        {"name": "subfinder", "cmd": "subfinder"},
        {"name": "whatweb", "cmd": "whatweb"},
        {"name": "nikto", "cmd": "nikto"},
    ]},
    "2": {"category": "OSINT", "tools": [
        {"name": "sherlock", "cmd": "sherlock"},
        {"name": "theHarvester", "cmd": "theHarvester"},
        {"name": "cyberfind", "cmd": "cyberfind"},
    ]},
    "3": {"category": "Vulnerabilidades", "tools": [
        {"name": "nuclei", "cmd": "nuclei"},
        {"name": "nikto", "cmd": "nikto"},
    ]},
    "4": {"category": "Explotación", "tools": [
        {"name": "msfconsole", "cmd": "msfconsole"},
        {"name": "msfvenom", "cmd": "msfvenom"},
        {"name": "sqlmap", "cmd": "sqlmap"},
        {"name": "commix", "cmd": "commix"},
        {"name": "searchsploit", "cmd": "searchsploit"},
    ]},
    "5": {"category": "Web Pentesting", "tools": [
        {"name": "burpsuite", "cmd": "burpsuite"},
        {"name": "zaproxy", "cmd": "zap-x.sh"},
        {"name": "dirb", "cmd": "dirb"},
        {"name": "gobuster", "cmd": "gobuster"},
    ]},
    "6": {"category": "Contraseñas", "tools": [
        {"name": "hashcat", "cmd": "hashcat"},
        {"name": "john", "cmd": "john"},
        {"name": "hydra", "cmd": "hydra"},
        {"name": "cewl", "cmd": "cewl"},
        {"name": "crunch", "cmd": "crunch"},
    ]},
    "7": {"category": "Red & MitM", "tools": [
        {"name": "wireshark", "cmd": "wireshark"},
        {"name": "ettercap", "cmd": "ettercap"},
        {"name": "bettercap", "cmd": "bettercap"},
        {"name": "responder", "cmd": "responder"},
    ]},
    "8": {"category": "Post-Explotación", "tools": [
        {"name": "netcat", "cmd": "nc"},
        {"name": "socat", "cmd": "socat"},
        {"name": "linpeas", "cmd": "/usr/local/bin/linpeas"},
        {"name": "impacket", "cmd": "impacket-secretsdump"},
    ]},
    "9": {"category": "Active Directory", "tools": [
        {"name": "bloodhound", "cmd": "bloodhound"},
        {"name": "crackmapexec", "cmd": "crackmapexec"},
        {"name": "enum4linux", "cmd": "enum4linux"},
        {"name": "evil-winrm", "cmd": "evil-winrm"},
    ]},
    "10": {"category": "Wordlists & Recursos", "tools": [
        {"name": "SecLists", "cmd": "ls /opt/SecLists"},
        {"name": "rockyou", "cmd": "ls /usr/share/wordlists/rocktxt"},
    ]},
    "11": {"category": "CTF & Reverse", "tools": [
        {"name": "pwntools", "cmd": "python3 -c import pwn"},
        {"name": "ghidra", "cmd": "ghidra"},
        {"name": "radare2", "cmd": "r2"},
        {"name": "binwalk", "cmd": "binwalk"},
    ]},
    "12": {"category": "Utilidades", "tools": [
        {"name": "tmux", "cmd": "tmux"},
        {"name": "proxychains", "cmd": "proxychains4"},
        {"name": "tor", "cmd": "tor"},
    ]},
    "13": {"category": "Wireless Security", "tools": [
        {"name": "aircrack-ng", "cmd": "aircrack-ng"},
        {"name": "wifite", "cmd": "wifite"},
        {"name": "reaver", "cmd": "reaver"},
    ]},
    "14": {"category": "Social Engineering", "tools": [
        {"name": "setoolkit", "cmd": "setoolkit"},
    ]},
    "15": {"category": "C2 & Remote Access", "tools": [
        {"name": "sliver", "cmd": "sliver"},
        {"name": "mythic", "cmd": "mythic"},
        {"name": "pupy", "cmd": "pupy"},
    ]},
}


def show_menu():
    console.print("\n")
    console.print("[bold cyan]╔════════════════════════════════════════════════════════════════╗[/bold cyan]")
    console.print("[bold cyan]║      🛡️  CyberSecurity Tools - Launcher v1.0                  ║[/bold cyan]")
    console.print("[bold cyan]╚════════════════════════════════════════════════════════════════╝[/bold cyan]")
    console.print("")
    
    table = Table(show_header=True, header_style="bold cyan")
    table.add_column("#", style="cyan", width=4)
    table.add_column("Categoría", style="white")
    table.add_column("Herramientas", style="dim")
    
    for key, val in TOOLS.items():
        table.add_row(key, val["category"], f"{len(val['tools'])} tools")
    
    console.print(table)
    console.print("")


def show_tools(category):
    cat = TOOLS[category]
    console.print(f"\n[bold cyan]▸ {cat['category']}[/bold cyan]\n")
    
    table = Table(show_header=True, header_style="bold cyan")
    table.add_column("#", style="cyan", width=4)
    table.add_column("Herramienta", style="white")
    table.add_column("Descripción", style="dim")
    
    descriptions = {
        "nmap": "Escáner de puertos",
        "netdiscover": "Descubrir hosts en red local",
        "masscan": "Escaneo masivo",
        "naabu": "Port scanner rápido",
        "httpx": "HTTP toolkit",
        "dnsx": "DNS enumeration",
        "subfinder": "Subdomain enum",
        "whatweb": "Tecnologías web",
        "nikto": "Web vulnerabilities",
        "sherlock": "Buscar usuarios",
        "theHarvester": "Emails y subdomains",
        "nuclei": "Vulnerability scanner",
        "msfconsole": "Metasploit",
        "msfvenom": "Generar payloads",
        "sqlmap": "SQL Injection",
        "commix": "Command Injection",
        "searchsploit": "Buscar exploits",
        "burpsuite": "Proxy web",
        "zaproxy": "OWASP ZAP",
        "dirb": "Directory busting",
        "gobuster": "Directory brute",
        "hashcat": "Cracking GPU",
        "john": "Cracking CPU",
        "hydra": "Brute force",
        "cewl": "Generar wordlist",
        "crunch": "Generar wordlist",
        "wireshark": "Sniffer",
        "ettercap": "MitM",
        "bettercap": "MitM moderno",
        "responder": "LLMNR poison",
        "netcat": "Reverse shell",
        "socat": "Relay",
        "linpeas": "Linux priv esc",
        "impacket": "Windows protocols",
        "bloodhound": "AD attack paths",
        "crackmapexec": "AD exploitation",
        "enum4linux": "SMB enum",
        "evil-winrm": "WinRM shell",
        "ghidra": "Decompiler",
        "radare2": "Binary analysis",
        "binwalk": "Embedded files",
    }
    
    for idx, tool in enumerate(cat["tools"], 1):
        desc = descriptions.get(tool["name"], "")
        table.add_row(str(idx), tool["name"], desc)
    
    console.print(table)
    console.print("")


def run_interactive(category: str, tool_idx: int):
    cat = TOOLS[category]
    tool = cat["tools"][tool_idx - 1]
    cmd = tool["cmd"]
    
    console.print(f"\n[green]▸ Ejecutando: {tool['name']}[/green]")
    console.print(f"[dim]Comando: {cmd} [parametros][/dim]\n")
    console.print("[yellow]✎ Escribe 'exit' para volver al menú[/yellow]\n")
    
    # Ejecutar interactivamente
    try:
        # Ejecutar con shell interactivo
        process = subprocess.Popen(
            cmd,
            shell=True,
            executable="/bin/bash",
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
        )
        
        # Loop interactivo
        while True:
            try:
                # Leer output directamente al proceso
                # Usar exec para ejecutar el comando directamente
                subprocess.run(cmd, shell=True, executable="/bin/bash")
                break
            except KeyboardInterrupt:
                console.print("\n[yellow]Deteniendo...[/yellow]")
                process.terminate()
                break
        
    except FileNotFoundError:
        console.print(f"\n[red]✗ Herramienta no encontrada: {tool['name']}[/red]")
        console.print(f"[dim]¿Está instalada?[/dim]")
    except Exception as e:
        console.print(f"[red]✗ Error: {e}[/red]")


def run_direct(category: str, tool_idx: int):
    """Ejecuta la herramienta directamente"""
    cat = TOOLS[category]
    tool = cat["tools"][tool_idx - 1]
    cmd = tool["name"]
    
    console.print(f"\n[green]▸ {tool['name']}[/green]")
    console.print("[yellow]→ Ejecutando directamente...[/yellow]\n")
    
    # Reemplazar el comando por solo el nombre (sin -h)
    # y ejecutar directamente
    try:
        # Verificar si existe
        result = subprocess.run(
            ["which", tool["name"]],
            capture_output=True,
            text=True
        )
        
        if result.returncode != 0:
            console.print(f"[red]✗ {tool['name']} no está instalado[/red]")
            return
        
        # Ejecutar el comando directamente (sin parámetros)
        # El usuario agrega lo que necesita
        os.system(tool["name"])
        
    except KeyboardInterrupt:
        console.print("\n[yellow]Interrupted[/yellow]")
    except Exception as e:
        console.print(f"[red]Error: {e}[/red]")


def main():
    while True:
        show_menu()
        
        console.print("[bold]Selecciona categoría:[/bold] ", end="")
        category = input().strip()
        
        if category.lower() in ["q", "quit", "exit"]:
            console.print("[cyan]¡Hasta luego! 👋[/cyan]")
            break
        
        if category not in TOOLS:
            console.print(f"[red]Categoría inválida[/red]")
            continue
        
        # Mostrar herramientas
        show_tools(category)
        
        console.print("[bold]Selecciona herramienta:[/bold] ", end="")
        tool_idx_input = input().strip()
        
        if tool_idx_input.lower() in ["b", "back"]:
            continue
        if tool_idx_input.lower() in ["q", "quit", "exit"]:
            break
        
        try:
            tool_idx = int(tool_idx_input)
            cat = TOOLS[category]
            
            if tool_idx < 1 or tool_idx > len(cat["tools"]):
                console.print(f"[red]Índice inválido[/red]")
                continue
            
            # Ejecutar directamente
            run_direct(category, tool_idx)
            
        except ValueError:
            console.print(f"[red]Número inválido[/red]")


if __name__ == "__main__":
    main()