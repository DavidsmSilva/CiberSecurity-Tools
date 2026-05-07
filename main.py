#!/usr/bin/env python3
"""
CyberSecurity Tools - Launcher v2.1
CLI arguments, modo check, mejor manejo de errores
"""
import os
import sys
import subprocess
import shutil
import argparse
from pathlib import Path

try:
    import typer
    from rich.console import Console
    from rich.table import Table
    from rich import print
except ImportError:
    subprocess.run([sys.executable, "-m", "pip", "install", "typer", "rich"], check=True)
    import typer
    from rich.console import Console
    from rich.table import Table
    from rich import print

console = Console()

# ============================================================
# HERRAMIENTAS
# ============================================================

TOOLS = {
    "1": {"category": "Reconocimiento & Escaneo", "tools": [
        {"name": "nmap", "cmd": "nmap", "pkg": "nmap"},
        {"name": "netdiscover", "cmd": "netdiscover", "pkg": "netdiscover"},
        {"name": "masscan", "cmd": "masscan", "pkg": "masscan"},
        {"name": "naabu", "cmd": "naabu", "pkg": "github.com/projectdiscovery/naabu/v2/cmd/naabu"},
        {"name": "httpx", "cmd": "httpx", "pkg": "github.com/projectdiscovery/httpx/cmd/httpx"},
        {"name": "dnsx", "cmd": "dnsx", "pkg": "github.com/projectdiscovery/dnsx/cmd/dnsx"},
        {"name": "subfinder", "cmd": "subfinder", "pkg": "github.com/projectdiscovery/subfinder/v2/cmd/subfinder"},
        {"name": "whatweb", "cmd": "whatweb", "pkg": "whatweb"},
        {"name": "nikto", "cmd": "nikto", "pkg": "nikto"},
        {"name": "gobuster", "cmd": "gobuster", "pkg": "gobuster"},
    ]},
    "2": {"category": "Vulnerabilidades", "tools": [
        {"name": "nuclei", "cmd": "nuclei", "pkg": "github.com/projectdiscovery/nuclei/v3/cmd/nuclei"},
        {"name": "sqlmap", "cmd": "sqlmap", "pkg": "sqlmap"},
        {"name": "commix", "cmd": "commix", "pkg": "commix"},
    ]},
    "3": {"category": "Explotación", "tools": [
        {"name": "msfconsole", "cmd": "msfconsole", "pkg": "metasploit-framework"},
        {"name": "msfvenom", "cmd": "msfvenom", "pkg": "metasploit-framework"},
        {"name": "searchsploit", "cmd": "searchsploit", "pkg": "exploitdb"},
    ]},
    "4": {"category": "Web Pentesting", "tools": [
        {"name": "zaproxy", "cmd": "zap-x.sh", "pkg": "zaproxy"},
        {"name": "dirb", "cmd": "dirb", "pkg": "dirb"},
    ]},
    "5": {"category": "Contraseñas", "tools": [
        {"name": "hashcat", "cmd": "hashcat", "pkg": "hashcat"},
        {"name": "john", "cmd": "john", "pkg": "john"},
        {"name": "hydra", "cmd": "hydra", "pkg": "hydra"},
        {"name": "cewl", "cmd": "cewl", "pkg": "cewl"},
        {"name": "crunch", "cmd": "crunch", "pkg": "crunch"},
    ]},
    "6": {"category": "Red & Sniffing", "tools": [
        {"name": "wireshark", "cmd": "wireshark", "pkg": "wireshark"},
        {"name": "tcpdump", "cmd": "tcpdump", "pkg": "tcpdump"},
        {"name": "ettercap", "cmd": "ettercap", "pkg": "ettercap-graphical"},
        {"name": "bettercap", "cmd": "bettercap", "pkg": "bettercap"},
        {"name": "responder", "cmd": "responder", "pkg": "responder"},
    ]},
    "7": {"category": "MitM & ARP Spoofing", "tools": [
        {"name": "ettercap", "cmd": "ettercap", "pkg": "ettercap-graphical"},
        {"name": "bettercap", "cmd": "bettercap", "pkg": "bettercap"},
        {"name": "responder", "cmd": "responder", "pkg": "responder"},
        {"name": "arpspoof", "cmd": "arpspoof", "pkg": "dsniff"},
    ]},
    "8": {"category": "Post-Explotación", "tools": [
        {"name": "netcat", "cmd": "nc", "pkg": "netcat-traditional"},
        {"name": "socat", "cmd": "socat", "pkg": "socat"},
        {"name": "linpeas", "cmd": "/usr/local/bin/linpeas", "pkg": "curl -sL https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh -o /usr/local/bin/linpeas"},
    ]},
    "9": {"category": "Active Directory", "tools": [
        {"name": "enum4linux", "cmd": "enum4linux", "pkg": "enum4linux"},
        {"name": "ldapsearch", "cmd": "ldapsearch", "pkg": "ldap-utils"},
        {"name": "rpcclient", "cmd": "rpcclient", "pkg": "samba"},
    ]},
    "10": {"category": "Reversing & Forensics", "tools": [
        {"name": "ghidra", "cmd": "ghidra", "pkg": "ghidra"},
        {"name": "radare2", "cmd": "r2", "pkg": "radare2"},
        {"name": "binwalk", "cmd": "binwalk", "pkg": "binwalk"},
        {"name": "foremost", "cmd": "foremost", "pkg": "foremost"},
        {"name": "gdb", "cmd": "gdb", "pkg": "gdb"},
    ]},
    "11": {"category": "Utilidades", "tools": [
        {"name": "tmux", "cmd": "tmux", "pkg": "tmux"},
        {"name": "proxychains", "cmd": "proxychains4", "pkg": "proxychains"},
    ]},
}


def check_installed(cmd):
    """Verifica si una herramienta está instalada"""
    if cmd.startswith("/"):
        return Path(cmd).exists()
    return shutil.which(cmd) is not None


def get_install_cmd(pkg):
    """Devuelve comando de instalación para el paquete"""
    if pkg.startswith("github.com"):
        return f"go install {pkg}@latest"
    elif pkg.startswith("curl"):
        return pkg
    elif pkg.startswith("sudo"):
        return pkg
    else:
        return f"sudo apt install -y {pkg}"


def check_all_tools():
    """Verifica todas las herramientas y muestra estado"""
    console.print("\n[bold cyan]╔════════════════════════════════════════════════════════════════╗[/bold cyan]")
    console.print("[bold cyan]║        🔍 Verificación de Herramientas                  ║[/bold cyan]")
    console.print("[bold cyan]╚═════════════════���══════════════════════════════════════════════╝[/bold cyan]")
    console.print("")
    
    installed_count = 0
    missing_count = 0
    
    for cat_id, cat in TOOLS.items():
        console.print(f"\n[bold cyan]▸ {cat['category']}[/bold cyan]")
        
        table = Table(show_header=True, header_style="bold cyan")
        table.add_column("Herramienta", style="white")
        table.add_column("Estado", style="dim")
        table.add_column("Instalar", style="dim")
        
        for tool in cat["tools"]:
            installed = check_installed(tool["cmd"])
            if installed:
                installed_count += 1
                table.add_row(tool["name"], "[green]✅[/green]", "[dim]OK[/dim]")
            else:
                missing_count += 1
                table.add_row(tool["name"], "[red]❌[/red]", f"[yellow]{get_install_cmd(tool['pkg'])}[/yellow]")
        
        console.print(table)
    
    console.print("")
    console.print(f"[bold]Resumen:[/bold] [green]{installed_count}✅[/green] / {missing_count}❌")
    console.print("")
    
    if missing_count > 0:
        console.print("[yellow]Para instalar las herramientas faltantes:[/yellow]")
        console.print("[cyan]  sudo apt update && sudo apt install <paquete>[/cyan]")
    else:
        console.print("[green]✅ Todas las herramientas están instaladas[/green]")
    
    console.print("")


def show_categories():
    """Muestra categorías"""
    table = Table(show_header=True, header_style="bold cyan")
    table.add_column("#", style="cyan", width=4)
    table.add_column("Categoría", style="white")
    table.add_column("Tools", style="dim")
    
    for key, val in TOOLS.items():
        table.add_row(key, val["category"], str(len(val['tools'])))
    
    console.print(table)


def show_tools(category):
    """Muestra herramientas de una categoría"""
    cat = TOOLS[category]
    console.print(f"\n[bold cyan]▸ {cat['category']}[/bold cyan]\n")
    
    table = Table(show_header=True, header_style="bold cyan")
    table.add_column("#", style="cyan", width=4)
    table.add_column("Herramienta", style="white")
    table.add_column("Estado", style="dim")
    table.add_column("Instalar", style="dim")
    
    for idx, tool in enumerate(cat["tools"], 1):
        installed = check_installed(tool["cmd"])
        if installed:
            status = "[green]✅[/green]"
            install_cmd = "[dim]OK[/dim]"
        else:
            status = "[red]❌[/red]"
            install_cmd = f"[yellow]{get_install_cmd(tool['pkg'])}[/yellow]"
        
        table.add_row(str(idx), tool["name"], status, install_cmd)
    
    console.print(table)


def run_tool(category, tool_idx, args=None):
    """Ejecuta herramienta"""
    cat = TOOLS[category]
    tool = cat["tools"][tool_idx - 1]
    cmd = tool["cmd"]
    
    # Verificar instalación
    if not check_installed(cmd):
        console.print(f"\n[red]✗ {tool['name']} no está instalado[/red]")
        console.print(f"[cyan]Para instalar:[/cyan] [yellow]{get_install_cmd(tool['pkg'])}[/yellow]\n")
        return 1
    
    # Construir comando
    if args:
        full_cmd = [cmd] + args
    else:
        full_cmd = [cmd]
    
    console.print(f"\n[green]▸ {tool['name']}[/green] {' '.join(args) if args else ''}")
    
    try:
        # Ejecutar con subprocess para manejo correcto
        result = subprocess.run(
            full_cmd,
            stdin=sys.stdin,
            stdout=sys.stdout,
            stderr=subprocess.STDOUT
        )
        return result.returncode
    except KeyboardInterrupt:
        console.print("\n[yellow]Detenido por el usuario[/yellow]")
        return 130
    except Exception as e:
        console.print(f"[red]Error: {e}[/red]")
        return 1


def interactive_mode():
    """Modo interactivo"""
    while True:
        console.print("\n[bold cyan]╔════════════════════════════════════════════════════════════════╗[/bold cyan]")
        console.print("[bold cyan]║      🛡️  CyberSecurity Tools - Launcher v2.1                   ║[/bold cyan]")
        console.print("[bold cyan]╚════════════════════════════════════════════════════════════════╝[/bold cyan]")
        console.print("")
        
        show_categories()
        console.print("\n[dim]Selecciona categoría, 'c' para verificar, 'q' para salir[/dim]")
        
        choice = input("\n[bold]#[/bold] ").strip()
        
        if choice.lower() in ["q", "quit", "exit"]:
            console.print("[cyan]👋[/cyan]")
            break
        
        if choice.lower() == "c":
            check_all_tools()
            continue
        
        if choice not in TOOLS:
            console.print(f"[red]✗ Categoría inválida[/red]")
            continue
        
        show_tools(choice)
        
        sel = input("\n[bold]Herramienta (#):[/bold] ").strip()
        
        if sel.lower() in ["b", "back"]:
            continue
        
        try:
            idx = int(sel)
            args = input("[bold]Argumentos (ENTER para interactivo):[/bold] ").strip().split()
            run_tool(choice, idx, args if args else None)
        except ValueError:
            console.print("[red]✗ Número inválido[/red]")


def main():
    parser = argparse.ArgumentParser(
        prog="cibersec",
        description="🛡️ CyberSecurity Tools - Launcher",
        epilog="""Ejemplos:
  cibersec                    # Menú interactivo
  cibersec --check            # Verificar herramientas
  cibersec -c 1               # Ver categoría 1
  cibersec 1 1                # Ejecutar nmap directamente
  cibersec 1 1 -sV 192.168.1.1 # Ejecutar nmap con argumentos
  cibersec --list             # Listar categorías""",
        formatter_class=argparse.RawDescriptionHelpFormatter
    )
    
    parser.add_argument("category", nargs="?", help="Categoría (#)")
    parser.add_argument("tool", nargs="?", help="Herramienta (#)")
    parser.add_argument("args", nargs="*", help="Argumentos para la herramienta")
    parser.add_argument("-c", "--check", action="store_true", help="Verificar todas las herramientas")
    parser.add_argument("-l", "--list", action="store_true", help="Listar categorías")
    parser.add_argument("-v", "--version", action="store_true", help="Versión")
    
    args = parser.parse_args()
    
    # Version
    if args.version:
        console.print("[cyan]CyberSecurity Tools v2.1[/cyan]")
        return 0
    
    # Check
    if args.check:
        check_all_tools()
        return 0
    
    # List
    if args.list:
        show_categories()
        return 0
    
    # Categoría + herramienta especificada
    if args.category and args.tool:
        if args.category not in TOOLS:
            console.print(f"[red]✗ Categoría inválida: {args.category}[/red]")
            return 1
        
        try:
            idx = int(args.tool)
            return run_tool(args.category, idx, args.args)
        except ValueError:
            console.print(f"[red]✗ Número de herramienta inválido: {args.tool}[/red]")
            return 1
    
    # Interactivo
    interactive_mode()
    return 0


if __name__ == "__main__":
    sys.exit(main())