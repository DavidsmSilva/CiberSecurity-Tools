#!/usr/bin/env python3
"""
CyberSecurity Tools - Launcher v2.0
Verifica disponibilidad antes de ejecutar
"""
import os
import sys
import subprocess
import shutil
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
# HERRAMIENTAS - solo las que install.sh instala
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
        {"name": "gobuster", "cmd": "gobuster"},
    ]},
    "2": {"category": "Vulnerabilidades", "tools": [
        {"name": "nuclei", "cmd": "nuclei"},
        {"name": "sqlmap", "cmd": "sqlmap"},
        {"name": "commix", "cmd": "commix"},
    ]},
    "3": {"category": "Explotación", "tools": [
        {"name": "msfconsole", "cmd": "msfconsole"},
        {"name": "msfvenom", "cmd": "msfvenom"},
        {"name": "searchsploit", "cmd": "searchsploit"},
        {"name": "exploitdb", "cmd": "searchsploit"},
    ]},
    "4": {"category": "Web Pentesting", "tools": [
        {"name": "zaproxy", "cmd": "zap-x.sh"},
        {"name": "dirb", "cmd": "dirb"},
    ]},
    "5": {"category": "Contraseñas", "tools": [
        {"name": "hashcat", "cmd": "hashcat"},
        {"name": "john", "cmd": "john"},
        {"name": "hydra", "cmd": "hydra"},
        {"name": "cewl", "cmd": "cewl"},
        {"name": "crunch", "cmd": "crunch"},
    ]},
    "6": {"category": "Red & Sniffing", "tools": [
        {"name": "wireshark", "cmd": "wireshark"},
        {"name": "tcpdump", "cmd": "tcpdump"},
        {"name": "ettercap", "cmd": "ettercap"},
        {"name": "bettercap", "cmd": "bettercap"},
        {"name": "responder", "cmd": "responder"},
    ]},
    "7": {"category": "MitM & ARP Spoofing", "tools": [
        {"name": "ettercap", "cmd": "ettercap"},
        {"name": "bettercap", "cmd": "bettercap"},
        {"name": "responder", "cmd": "responder"},
        {"name": "arpspoof", "cmd": "arpspoof"},
    ]},
    "8": {"category": "Post-Explotación", "tools": [
        {"name": "netcat", "cmd": "nc"},
        {"name": "socat", "cmd": "socat"},
        {"name": "linpeas", "cmd": "/usr/local/bin/linpeas"},
    ]},
    "9": {"category": "Active Directory", "tools": [
        {"name": "enum4linux", "cmd": "enum4linux"},
        {"name": "ldapsearch", "cmd": "ldapsearch"},
        {"name": "rpcclient", "cmd": "rpcclient"},
    ]},
    "10": {"category": "Reversing & Forensics", "tools": [
        {"name": "ghidra", "cmd": "ghidra"},
        {"name": "radare2", "cmd": "r2"},
        {"name": "binwalk", "cmd": "binwalk"},
        {"name": "foremost", "cmd": "foremost"},
        {"name": "gdb", "cmd": "gdb"},
    ]},
    "11": {"category": "Utilidades", "tools": [
        {"name": "tmux", "cmd": "tmux"},
        {"name": "proxychains", "cmd": "proxychains4"},
        {"name": "socat", "cmd": "socat"},
    ]},
}


def check_installed(cmd):
    """Verifica si una herramienta está instalada"""
    # ¿Es path directo?
    if cmd.startswith("/"):
        return Path(cmd).exists()
    
    # Buscar en PATH
    return shutil.which(cmd) is not None


def get_install_cmd(tool_name):
    """Devuelve comando de instalación para la herramienta"""
    # Mapear nombre a paquete APT
    install_map = {
        "nmap": "nmap",
        "netdiscover": "netdiscover",
        "masscan": "masscan",
        "naabu": "github.com/projectdiscovery/naabu/v2/cmd/naabu",
        "httpx": "github.com/projectdiscovery/httpx/cmd/httpx",
        "dnsx": "github.com/projectdiscovery/dnsx/cmd/dnsx",
        "subfinder": "github.com/projectdiscovery/subfinder/v2/cmd/subfinder",
        "whatweb": "whatweb",
        "nikto": "nikto",
        "gobuster": "gobuster",
        "nuclei": "github.com/projectdiscovery/nuclei/v3/cmd/nuclei",
        "sqlmap": "sqlmap",
        "commix": "commix",
        "msfconsole": "metasploit-framework",
        "msfvenom": "metasploit-framework",
        "searchsploit": "exploitdb",
        "exploitdb": "exploitdb",
        "zaproxy": "zaproxy",
        "dirb": "dirb",
        "hashcat": "hashcat",
        "john": "john",
        "hydra": "hydra",
        "cewl": "cewl",
        "crunch": "crunch",
        "wireshark": "wireshark",
        "tcpdump": "tcpdump",
        "ettercap": "ettercap-graphical",
        "bettercap": "bettercap",
        "responder": "responder",
        "arpspoof": "dsniff",
        "netcat": "netcat-traditional",
        "socat": "socat",
        "linpeas": "curl -sL https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh -o /usr/local/bin/linpeas",
        "enum4linux": "enum4linux",
        "ldapsearch": "ldap-utils",
        "rpcclient": "samba",
        "ghidra": "ghidra",
        "radare2": "radare2",
        "binwalk": "binwalk",
        "foremost": "foremost",
        "gdb": "gdb",
        "tmux": "tmux",
        "proxychains4": "proxychains",
    }
    
    pkg = install_map.get(tool_name, tool_name)
    if pkg.startswith("github.com"):
        return f"go install {pkg}@latest"
    elif pkg.startswith("curl"):
        return pkg
    else:
        return f"sudo apt install -y {pkg}"


def show_menu():
    """Muestra menú principal"""
    console.print("\n")
    console.print("[bold cyan]╔════════════════════════════════════════════════════════════════╗[/bold cyan]")
    console.print("[bold cyan]║      🛡️  CyberSecurity Tools - Launcher v2.0                   ║[/bold cyan]")
    console.print("[bold cyan]╚════════════════════════════════════════════════════════════════╝[/bold cyan]")
    console.print("")
    
    table = Table(show_header=True, header_style="bold cyan")
    table.add_column("#", style="cyan", width=4)
    table.add_column("Categoría", style="white")
    table.add_column("Tools", style="dim")
    
    for key, val in TOOLS.items():
        table.add_row(key, val["category"], str(len(val['tools'])))
    
    console.print(table)
    console.print("\n[dim]Selecciona categoría o escribe 'q' para salir[/dim]")


def show_tools(category):
    """Muestra herramientas de una categoría con estado"""
    cat = TOOLS[category]
    console.print(f"\n[bold cyan]▸ {cat['category']}[/bold cyan]\n")
    
    table = Table(show_header=True, header_style="bold cyan")
    table.add_column("#", style="cyan", width=4)
    table.add_column("Herramienta", style="white")
    table.add_column("Estado", style="dim")
    table.add_column("Instalar con", style="dim")
    
    for idx, tool in enumerate(cat["tools"], 1):
        installed = check_installed(tool["cmd"])
        if installed:
            status = "[green] ✅ [/green]"
            install_cmd = "[dim]instalado[/dim]"
        else:
            status = "[red] ❌ [/red]"
            install_cmd = f"[yellow]{get_install_cmd(tool['name'])}[/yellow]"
        
        table.add_row(str(idx), tool["name"], status, install_cmd)
    
    console.print(table)


def run_tool_interactive(category, tool_idx):
    """Ejecuta herramienta de forma interactiva"""
    cat = TOOLS[category]
    tool = cat["tools"][tool_idx - 1]
    cmd = tool["cmd"]
    
    # Verificar instalación
    if not check_installed(cmd):
        console.print(f"\n[red]✗ {tool['name']} no está instalado[/red]")
        console.print(f"[cyan]Para instalar:[/cyan] [yellow]{get_install_cmd(tool['name'])}[/yellow]\n")
        console.print("[dim]Presiona Enter para continuar...[/dim]")
        input()
        return
    
    # Ejecutar con argumentos
    console.print(f"\n[green]▸ {tool['name']}[/green]")
    console.print(f"[dim]Comando: {cmd} <argumentos>[/dim]")
    console.print("[dim]Escribe 'exit' o Ctrl+C para salir[/dim]\n")
    
    # Loop interactivo
    while True:
        try:
            args = input(f"[cyan]$[/cyan] {cmd} ").strip()
            
            if args.lower() in ["exit", "quit", "q"]:
                break
            
            # Ejecutar comando con argumentos
            full_cmd = f"{cmd} {args}" if args else cmd
            
            result = subprocess.run(
                full_cmd,
                shell=True,
                stdin=sys.stdin,
                stdout=sys.stdout,
                stderr=subprocess.STDOUT
            )
            
            if result.returncode != 0:
                console.print(f"\n[yellow]El comando terminó con error: {result.returncode}[/yellow]")
                
        except KeyboardInterrupt:
            console.print("\n[yellow]Detenido[/yellow]")
            break
        except EOFError:
            break
        except Exception as e:
            console.print(f"[red]Error: {e}[/red]")
            break


def main():
    """Loop principal"""
    while True:
        show_menu()
        
        console.print("\n[bold]Categoría (#):[/bold] ", end="")
        category = input().strip()
        
        if category.lower() in ["q", "quit", "exit"]:
            console.print("[cyan]👋[/cyan]")
            break
        
        if category not in TOOLS:
            console.print(f"[red]✗ Categoría inválida[/red]")
            continue
        
        show_tools(category)
        
        console.print("\n[bold]Herramienta (#):[/bold] ", end="")
        sel = input().strip()
        
        if sel.lower() in ["b", "back"]:
            continue
        
        try:
            idx = int(sel)
            run_tool_interactive(category, idx)
        except ValueError:
            console.print("[red]✗ Número inválido[/red]")


if __name__ == "__main__":
    main()