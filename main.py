#!/usr/bin/env python3
"""
CyberSecurity Tools - Launcher v1.6
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
# HERRAMIENTAS (solo lasInstaladas)
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
    ]},
    "9": {"category": "Active Directory", "tools": [
        {"name": "crackmapexec", "cmd": "crackmapexec"},
        {"name": "enum4linux", "cmd": "enum4linux"},
    ]},
    "10": {"category": "CTF & Reverse", "tools": [
        {"name": "ghidra", "cmd": "ghidra"},
        {"name": "radare2", "cmd": "r2"},
        {"name": "binwalk", "cmd": "binwalk"},
        {"name": "foremost", "cmd": "foremost"},
    ]},
    "11": {"category": "Utilidades", "tools": [
        {"name": "tmux", "cmd": "tmux"},
        {"name": "proxychains", "cmd": "proxychains4"},
    ]},
    "12": {"category": "Wireless Security", "tools": [
        {"name": "aircrack-ng", "cmd": "aircrack-ng"},
        {"name": "wifite", "cmd": "wifite"},
        {"name": "reaver", "cmd": "reaver"},
    ]},
}


def check_installed(cmd):
    """Verifica si una herramienta está instalada"""
    # EsPath directo?
    if cmd.startswith("/"):
        return Path(cmd).exists()
    
    # Buscar en PATH
    result = subprocess.run(
        ["which", cmd],
        capture_output=True,
        text=True
    )
    return result.returncode == 0


def show_menu():
    console.print("\n")
    console.print("[bold cyan]╔════════════════════════════════════════════════════════════════╗[/bold cyan]")
    console.print("[bold cyan]║      🛡️  CyberSecurity Tools - Launcher v1.6                    ║[/bold cyan]")
    console.print("[bold cyan]╚════════════════════════════════════════════════════════════════╝[/bold cyan]")
    console.print("")
    
    table = Table(show_header=True, header_style="bold cyan")
    table.add_column("#", style="cyan", width=4)
    table.add_column("Categoría", style="white")
    table.add_column("Tools", style="dim")
    
    for key, val in TOOLS.items():
        table.add_row(key, val["category"], f"{len(val['tools'])}")
    
    console.print(table)


def show_tools(category):
    cat = TOOLS[category]
    console.print(f"\n[bold cyan]▸ {cat['category']}[/bold cyan]\n")
    
    table = Table(show_header=True, header_style="bold cyan")
    table.add_column("#", style="cyan", width=4)
    table.add_column("Herramienta", style="white")
    table.add_column("Estado", style="dim")
    
    for idx, tool in enumerate(cat["tools"], 1):
        installed = check_installed(tool["cmd"])
        status = "[green]✅[/green]" if installed else "[red]❌[/red]"
        table.add_row(str(idx), tool["name"], status)
    
    console.print(table)


def run_tool(category, tool_idx):
    cat = TOOLS[category]
    tool = cat["tools"][tool_idx - 1]
    cmd = tool["cmd"]
    
    # Verificar si está instalada
    if not check_installed(cmd):
        console.print(f"\n[red]✗ {tool['name']} no está instalado[/red]")
        console.print(f"[yellow]Para instalar: sudo apt install {tool['name']}[/yellow]\n")
        return
    
    # Ejecutar directamente
    console.print(f"\n[green]▸ {tool['name']}[/green]")
    console.print("[dim]Escribe parámetros y presiona Enter[/dim]")
    console.print("[dim]Escribe 'exit' para salir[/dim]\n")
    
    # Ejecutar de forma interactiva
    try:
        os.system(cmd)
    except KeyboardInterrupt:
        console.print("\n[yellow]Detenido[/yellow]")
    except Exception as e:
        console.print(f"[red]Error: {e}[/red]")


def main():
    while True:
        show_menu()
        
        console.print("[bold]Categoría:[/bold] ", end="")
        category = input().strip()
        
        if category.lower() in ["q", "quit", "exit"]:
            console.print("[cyan]👋[/cyan]")
            break
        
        if category not in TOOLS:
            console.print(f"[red]Inválido: {category}[/red]")
            continue
        
        show_tools(category)
        
        console.print("[bold]Herramienta (#):[/bold] ", end="")
        sel = input().strip()
        
        if sel.lower() in ["b", "back"]:
            continue
        
        try:
            idx = int(sel)
            run_tool(category, idx)
        except ValueError:
            console.print("[red]Número inválido[/red]")


if __name__ == "__main__":
    main()