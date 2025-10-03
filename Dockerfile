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
