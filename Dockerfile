
# Dockerfile simplificado para Railway - Sem argumentos extras
FROM docker.redpanda.com/redpandadata/redpanda:v25.2.7

# Instalar dependências necessárias (usando root temporariamente)
USER root
RUN apt-get update && apt-get install -y \
    curl \
    jq \
    && rm -rf /var/lib/apt/lists/*

# Criar diretórios necessários
RUN mkdir -p /etc/redpanda /var/lib/redpanda/data

# Copiar arquivos de configuração
COPY bootstrap.simple.yml /etc/redpanda/bootstrap.yml
COPY transactions-schema.json /etc/redpanda/
COPY env.example .env

# Configurar usuário não-root (usuário já existe na imagem base)
RUN chown -R redpanda:redpanda /var/lib/redpanda /etc/redpanda

USER redpanda

# Expor portas
EXPOSE 9092 8081 8082 9644

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD rpk cluster info || exit 1

# Usar o comando start do rpk (comando correto)
CMD ["redpanda start"]
