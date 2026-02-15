# 🐳 FIAP X - Infraestrutura Docker

Infraestrutura completa local com Docker Compose.

## 🚀 Como usar

```bash
# Subir tudo
docker-compose up -d

# Verificar status
docker-compose ps

# Logs
docker-compose logs -f

# Parar tudo
docker-compose down

# Parar e remover volumes
docker-compose down -v
```

## 🔗 URLs

- **MinIO Console:** http://localhost:9001 (minioadmin / minioadmin)
- **RabbitMQ Management:** http://localhost:15672 (guest / guest)
- **Keycloak Admin:** http://localhost:8081 (admin / admin)
- **MailHog UI:** http://localhost:8025
- **Prometheus:** http://localhost:9090
- **Grafana:** http://localhost:3000 (admin / admin)
- **PostgreSQL Videos:** localhost:5432
- **PostgreSQL Jobs:** localhost:5433
- **Redis:** localhost:6379
