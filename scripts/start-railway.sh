#!/bin/bash
set -e

echo "🚀 Iniciando Redpanda no Railway..."

# Configurar variáveis de ambiente se não existirem
export REDPANDA_RPC_SERVER="${REDPANDA_RPC_SERVER:-0.0.0.0:33145}"
export REDPANDA_KAFKA_API="${REDPANDA_KAFKA_API:-0.0.0.0:9092}"
export REDPANDA_PANDAPROXY_API="${REDPANDA_PANDAPROXY_API:-0.0.0.0:8082}"
export REDPANDA_SCHEMA_REGISTRY_API="${REDPANDA_SCHEMA_REGISTRY_API:-0.0.0.0:8081}"

# Configurar endereços de anúncio (Railway)
export REDPANDA_ADVERTISE_RPC_SERVER="${REDPANDA_ADVERTISE_RPC_SERVER:-0.0.0.0:33145}"
export REDPANDA_ADVERTISE_KAFKA_API="${REDPANDA_ADVERTISE_KAFKA_API:-0.0.0.0:9092}"
export REDPANDA_ADVERTISE_PANDAPROXY_API="${REDPANDA_ADVERTISE_PANDAPROXY_API:-0.0.0.0:8082}"
export REDPANDA_ADVERTISE_SCHEMA_REGISTRY_API="${REDPANDA_ADVERTISE_SCHEMA_REGISTRY_API:-0.0.0.0:8081}"

# Configurar performance
export REDPANDA_SMP="${REDPANDA_SMP:-2}"
export REDPANDA_MEMORY="${REDPANDA_MEMORY:-2G}"
export REDPANDA_RESERVE_MEMORY="${REDPANDA_RESERVE_MEMORY:-0M}"
export REDPANDA_OVERPROVISIONED="${REDPANDA_OVERPROVISIONED:-false}"

# Configurar logs
export REDPANDA_LOG_LEVEL="${REDPANDA_LOG_LEVEL:-info}"

echo "📋 Configurações Railway:"
echo "  - RPC Server: $REDPANDA_RPC_SERVER"
echo "  - Kafka API: $REDPANDA_KAFKA_API"
echo "  - Pandaproxy API: $REDPANDA_PANDAPROXY_API"
echo "  - Schema Registry API: $REDPANDA_SCHEMA_REGISTRY_API"
echo "  - SMP: $REDPANDA_SMP"
echo "  - Memory: $REDPANDA_MEMORY"
echo "  - Log Level: $REDPANDA_LOG_LEVEL"

# Iniciar Redpanda diretamente (sem argumentos extras)
echo "🎯 Iniciando Redpanda..."
exec redpanda start
