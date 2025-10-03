#!/bin/bash
set -e

echo "🚀 Iniciando Redpanda Quickstart Production..."

# Configurar variáveis de ambiente se não existirem
export REDPANDA_RPC_SERVER="${REDPANDA_RPC_SERVER:-0.0.0.0:33145}"
export REDPANDA_KAFKA_API="${REDPANDA_KAFKA_API:-0.0.0.0:9092}"
export REDPANDA_PANDAPROXY_API="${REDPANDA_PANDAPROXY_API:-0.0.0.0:8082}"
export REDPANDA_SCHEMA_REGISTRY_API="${REDPANDA_SCHEMA_REGISTRY_API:-0.0.0.0:8081}"

# Configurar endereços de anúncio
export REDPANDA_ADVERTISE_RPC_SERVER="${REDPANDA_ADVERTISE_RPC_SERVER:-redpanda:33145}"
export REDPANDA_ADVERTISE_KAFKA_API="${REDPANDA_ADVERTISE_KAFKA_API:-redpanda:9092}"
export REDPANDA_ADVERTISE_PANDAPROXY_API="${REDPANDA_ADVERTISE_PANDAPROXY_API:-redpanda:8082}"
export REDPANDA_ADVERTISE_SCHEMA_REGISTRY_API="${REDPANDA_ADVERTISE_SCHEMA_REGISTRY_API:-redpanda:8081}"

# Configurar performance
export REDPANDA_SMP="${REDPANDA_SMP:-2}"
export REDPANDA_MEMORY="${REDPANDA_MEMORY:-2G}"
export REDPANDA_RESERVE_MEMORY="${REDPANDA_RESERVE_MEMORY:-0M}"
export REDPANDA_OVERPROVISIONED="${REDPANDA_OVERPROVISIONED:-false}"

# Configurar logs
export REDPANDA_LOG_LEVEL="${REDPANDA_LOG_LEVEL:-info}"

echo "📋 Configurações:"
echo "  - RPC Server: $REDPANDA_RPC_SERVER"
echo "  - Kafka API: $REDPANDA_KAFKA_API"
echo "  - Pandaproxy API: $REDPANDA_PANDAPROXY_API"
echo "  - Schema Registry API: $REDPANDA_SCHEMA_REGISTRY_API"
echo "  - SMP: $REDPANDA_SMP"
echo "  - Memory: $REDPANDA_MEMORY"
echo "  - Log Level: $REDPANDA_LOG_LEVEL"

# Iniciar Redpanda em background
echo "🎯 Iniciando Redpanda..."
redpanda start &
REDPANDA_PID=$!

# Aguardar Redpanda estar pronto
echo "⏳ Aguardando Redpanda estar pronto..."
until rpk cluster info > /dev/null 2>&1; do
    echo "   Aguardando Redpanda..."
    sleep 2
done

echo "✅ Redpanda está pronto!"

# Executar configuração de usuários em background
echo "🔐 Configurando usuários e ACLs em background..."
/app/scripts/init.sh &

# Aguardar o processo principal do Redpanda
wait $REDPANDA_PID
