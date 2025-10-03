# 🎯 Dockerfile Final - O Que Funciona

## ✅ **DOCKERFILE ADAPTADO PARA O QUE FUNCIONA:**

### **Estrutura Final:**
```dockerfile
# Multi-stage build para Redpanda Quickstart Production
FROM docker.redpanda.com/redpandadata/redpanda:v25.2.7 as redpanda-base

# Stage 1: Build do transform (usando o WASM já compilado)
FROM alpine:latest as transform-builder
WORKDIR /app
COPY transform/regex.wasm .

# Stage 2: Production image
FROM docker.redpanda.com/redpandadata/redpanda:v25.2.7

# Instalar dependências necessárias (usando root temporariamente)
USER root
RUN apt-get update && apt-get install -y \
    curl \
    jq \
    && rm -rf /var/lib/apt/lists/*

# Criar diretórios necessários
RUN mkdir -p /etc/redpanda /var/lib/redpanda/data /app/scripts

# Copiar arquivos de configuração
COPY bootstrap.prod.yml /etc/redpanda/bootstrap.yml
COPY transactions-schema.json /etc/redpanda/
COPY --from=transform-builder /app/regex.wasm /etc/redpanda/

# Copiar scripts de inicialização
COPY scripts/ /app/scripts/
RUN chmod +x /app/scripts/*.sh

# Configurar usuário não-root (usuário já existe na imagem base)
RUN chown -R redpanda:redpanda /var/lib/redpanda /etc/redpanda /app

USER redpanda

# Expor portas
EXPOSE 9092 8081 8082 9644

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD rpk cluster info || exit 1

# Script de inicialização
CMD ["redpanda", "start"]
```

## 🚀 **COMO USAR (FUNCIONA 100%):**

### **1. Build da Imagem:**
```bash
docker build -t redpanda-prod:latest .
```

### **2. Executar Container:**
```bash
docker run -d --name redpanda-prod \
  -p 9092:9092 -p 8081:8081 -p 8082:8082 -p 9644:9644 \
  -e REDPANDA_ADMIN_USER=admin \
  -e REDPANDA_ADMIN_PASSWORD=admin123 \
  -e PRODUCER_USER=producer \
  -e PRODUCER_PASSWORD=producer123 \
  -e CONSUMER_USER=consumer \
  -e CONSUMER_PASSWORD=consumer123 \
  redpanda-prod:latest
```

### **3. Configurar Usuários (Manual - 1 comando):**
```bash
# Aguardar Redpanda inicializar (30-60 segundos)
docker exec redpanda-prod /app/scripts/setup-auth.sh
```

### **4. Testar Conectividade:**
```bash
# Testar producer
echo '{"user_id": 1, "email": "test@example.com", "name": "Teste"}' | \
docker run --rm -i --network host \
-v ./client-configs/rpk-profile.yaml:/tmp/profile.yaml \
docker.redpanda.com/redpandadata/redpanda:v25.2.7 --config /tmp/profile.yaml topic produce test-topic

# Testar consumer
docker run --rm --network host \
-v ./client-configs/rpk-profile.yaml:/tmp/profile.yaml \
docker.redpanda.com/redpandadata/redpanda:v25.2.7 --config /tmp/profile.yaml topic consume test-topic --num 1
```

## 📋 **O QUE O DOCKERFILE FAZ AUTOMATICAMENTE:**

### ✅ **Configuração Base:**
- Redpanda v25.2.7
- Dependências (curl, jq)
- Diretórios necessários
- Permissões corretas

### ✅ **Arquivos Incluídos:**
- bootstrap.prod.yml (configuração Redpanda)
- transactions-schema.json (schema JSON)
- regex.wasm (data transform)
- Scripts de configuração

### ✅ **Rede:**
- Portas 9092, 8081, 8082, 9644 expostas
- Health check configurado

### ✅ **Inicialização:**
- Redpanda inicia automaticamente
- Fica funcionando e acessível

## ⚠️ **O QUE PRECISA SER MANUAL (1 COMANDO):**

### **Configuração de Usuários:**
```bash
docker exec redpanda-prod /app/scripts/setup-auth.sh
```

**Este comando cria:**
- Usuários: producer, consumer, admin
- ACLs: Permissões de acesso
- Tópicos: logins, transactions, test-topic
- Schema: Registro do schema transactions

## 🎯 **RESUMO FINAL:**

| Funcionalidade | Status | Detalhes |
|----------------|--------|----------|
| **Dockerfile** | ✅ Funciona | Build e execução perfeitos |
| **Redpanda** | ✅ Funciona | Inicia automaticamente |
| **Portas** | ✅ Funciona | Todas expostas e acessíveis |
| **Configuração** | ✅ Funciona | Bootstrap aplicado |
| **Usuários** | ⚠️ Manual | 1 comando: setup-auth.sh |
| **Conectividade** | ✅ Funciona | Clientes externos conectam |

**O Dockerfile está adaptado para o que realmente funciona!** 🚀
