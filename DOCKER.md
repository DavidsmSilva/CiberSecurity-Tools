# Docker + Laboratorios

## Instalación

```bash
cd CiberSecurity-Tools
chmod +x docker-install.sh
sudo ./docker-install.sh
```

## Uso

```bash
cd /opt/labs
docker-compose up -d
```

## Acceder

| Laboratorio | URL | Usuario | Password |
|-------------|-----|---------|----------|
| DVWA | http://localhost:8080 | admin | password |

## Comandos Docker

```bash
# Ver contenedores
docker ps

# Detener
docker-compose down

# Iniciar
docker-compose up -d

# Ver logs
docker-compose logs -f

# Eliminar todo
docker-compose down -v
```

---

## Notas

- Requiere Docker instalado
- DVWA es para práctica de web vulnerabilities
- No exponer a Internet sin configurar