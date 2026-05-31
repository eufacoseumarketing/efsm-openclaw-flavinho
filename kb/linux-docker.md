# 🐋 Docker para HelpDesk

> Containers, Docker Compose, imagens, troubleshooting. Essencial pra infra PC Resolve.
> Atualizado: 31/05/2026

---

## 🟢 Conceitos

```
Container ≠ VM. Container compartilha o kernel do host, VM tem kernel próprio.

Imagem   → "Template" imutável (ex: nginx:latest)
Container → Instância rodando de uma imagem
Dockerfile → Receita pra criar imagem
Docker Compose → Orquestrar múltiplos containers
Volume  → Dados que sobrevivem ao container
```

---

## 🟢 Comandos Essenciais

```bash
# Gerenciar containers
docker ps                        # Containers rodando
docker ps -a                     # Todos (incluindo parados)
docker start nome
docker stop nome
docker restart nome
docker rm nome                   # Remover
docker rm -f nome                # Forçar remover

# Logs
docker logs nome                 # Ver logs
docker logs -f nome              # Seguir (Ctrl+C)
docker logs --tail 50 nome       # Últimas 50 linhas

# Entrar no container
docker exec -it nome bash        # Shell interativo
docker exec -it nome sh          # Se não tiver bash (Alpine)

# Imagens
docker images                    # Imagens baixadas
docker pull nginx:latest         # Baixar
docker rmi nginx:latest          # Remover

# Sistema
docker system prune -a           # Limpar TUDO não usado
docker stats                     # Uso de recursos (ao vivo)
docker inspect nome              # Detalhes do container
```

---

## 🔥 Docker Compose

```yaml
# docker-compose.yml (exemplo PC Resolve)
version: '3.8'
services:
  nginx:
    image: nginx:latest
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
      - ./ssl:/etc/nginx/ssl
    restart: unless-stopped
    
  mesh-api:
    build: ./mesh-api
    ports:
      - "3001:3001"
    environment:
      - MESH_ENCRYPTION_KEY=${MESH_KEY}
    restart: unless-stopped
```

```bash
docker compose up -d             # Iniciar (detached)
docker compose down              # Parar e remover
docker compose restart           # Reiniciar todos
docker compose logs -f           # Logs de todos
docker compose ps                # Status
docker compose up -d --build     # Rebuild + iniciar
```

---

## 🎯 Troubleshooting Docker

### Container não sobe

```bash
# Ver por que morreu
docker logs nome --tail 50       # Ver últimas 50 linhas
docker inspect nome | grep -A5 State  # Exit code? OOM?

# Erro de porta em uso
ss -tulanp | grep :3001          # Quem tá usando a porta?
```

### Container ocupa muito disco

```bash
docker system df                 # Uso de disco
docker system prune -a           # Limpar imagens, containers, volumes não usados
docker builder prune             # Limpar cache de build
```

### Preciso editar arquivo dentro do container

```bash
docker exec -it nome bash
# Se não tiver editor:
docker cp nome:/etc/nginx/nginx.conf .   # Copiar pra fora
# Editar localmente...
docker cp nginx.conf nome:/etc/nginx/nginx.conf  # Copiar de volta
docker restart nome
```

---

## 🛠️ Comandos Úteis pra PC Resolve

```bash
# Status da infra PC Resolve
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Reiniciar API após deploy
docker compose up -d --build mesh-api

# Ver logs da API em tempo real
docker logs -f pc-resolve-api

# Entrar no container pra debugar
docker exec -it pc-resolve-api sh
```
