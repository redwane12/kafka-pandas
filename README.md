# 🚀 Redpanda Quickstart - Produção

## 📋 Visão Geral

Este projeto contém uma configuração completa de produção para o Redpanda, otimizada para deploy na Railway com autenticação SASL e configurações de segurança.

## 🏗️ Estrutura do Projeto

```
prod/
├── Dockerfile                    # Imagem de produção
├── bootstrap.prod.yml            # Configuração do Redpanda
├── transactions-schema.json      # Schema JSON para validação
├── env.example                   # Variáveis de ambiente
├── railway.json                  # Configuração Railway
├── deploy.sh                     # Script de deploy
├── scripts/
│   ├── start.sh                  # Script de inicialização
│   ├── setup-auth.sh             # Configuração de usuários
│   └── deploy-railway.sh         # Deploy na Railway
├── client-configs/               # Configurações para clientes
│   ├── producer-config.json
│   ├── consumer-config.json
│   └── rpk-profile.yaml
└── transform/                    # Data transforms (WASM)
    ├── regex.wasm
    ├── transform.go
    └── transform.yaml
```

## 🚀 Quick Start

### 1. **Configurar Variáveis de Ambiente**
```bash
cp env.example .env
# Editar .env se necessário (valores padrão já estão configurados)
```

### 2. **Build da Imagem**
```bash
docker build -t redpanda-prod:latest .
```

### 3. **Executar Localmente**
```bash
docker run -d --name redpanda-prod \
  -p 9092:9092 -p 8081:8081 -p 8082:8082 -p 9644:9644 \
  --env-file .env \
  redpanda-prod:latest
```

### 4. **Configurar Usuários (Manual)**
```bash
# Aguardar Redpanda inicializar (30-60 segundos)
docker exec redpanda-prod /app/scripts/setup-auth.sh
```

### 5. **Deploy na Railway**
```bash
./deploy.sh
# Escolher opção 2: Deploy na Railway
```

## 🔐 Autenticação

### **Usuários Padrão:**
- **admin**: admin123 (superuser)
- **producer**: producer123 (WRITE, CREATE, DESCRIBE)
- **consumer**: consumer123 (READ, DESCRIBE)

### **Portas:**
- **9092**: Kafka API (SASL)
- **8081**: Schema Registry
- **8082**: Pandaproxy
- **9644**: Admin API

## 📊 Funcionalidades

- ✅ **SASL Authentication**: SCRAM-SHA-256
- ✅ **Schema Registry**: Validação JSON Schema
- ✅ **Data Transforms**: WASM transforms incluídos
- ✅ **Tiered Storage**: Configurável (S3/MinIO)
- ✅ **Métricas**: Prometheus metrics
- ✅ **Health Checks**: Monitoramento automático

## 🔧 Configuração

### **Variáveis de Ambiente Principais:**
```bash
REDPANDA_ADMIN_USER=admin
REDPANDA_ADMIN_PASSWORD=admin123
PRODUCER_USER=producer
PRODUCER_PASSWORD=producer123
CONSUMER_USER=consumer
CONSUMER_PASSWORD=consumer123
```

### **Configurações de Performance:**
```bash
REDPANDA_SMP=2
REDPANDA_MEMORY=2G
REDPANDA_OVERPROVISIONED=false
```

## 📚 Documentação

- [README-PRODUCAO.md](README-PRODUCAO.md) - Documentação detalhada
- [QUICK-START.md](QUICK-START.md) - Guia rápido de uso

## 🆘 Suporte

Para problemas ou dúvidas, consulte a documentação oficial do Redpanda ou abra uma issue no repositório.
# kafka-pandas
