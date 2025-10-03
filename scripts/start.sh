#!/bin/bash

# Script de inicialização do Redpanda para produção
set -e

echo "🚀 Iniciando Redpanda em modo produção..."

# Aguardar configurações de rede
sleep 5

# Configurar variáveis de ambiente
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

# Inicializar Redpanda
echo "🎯 Iniciando Redpanda..."

# Iniciar Redpanda em background
redpanda start &
REDPANDA_PID=$!

# Aguardar Redpanda estar pronto
echo "⏳ Aguardando Redpanda estar pronto..."
until rpk cluster info > /dev/null 2>&1; do
    echo "   Aguardando Redpanda..."
    sleep 2
done

echo "✅ Redpanda está pronto!"

# Configurar autenticação e usuários automaticamente
echo "🔐 Configurando autenticação e usuários..."

# Criar usuários se não existirem
echo "👤 Criando usuários..."

# Verificar se o usuário producer existe
if ! rpk acl user list | grep -q "producer"; then
    echo "   Criando usuário producer..."
    rpk acl user create producer --password ${PRODUCER_PASSWORD:-producer123}
else
    echo "   Usuário producer já existe"
fi

# Verificar se o usuário consumer existe
if ! rpk acl user list | grep -q "consumer"; then
    echo "   Criando usuário consumer..."
    rpk acl user create consumer --password ${CONSUMER_PASSWORD:-consumer123}
else
    echo "   Usuário consumer já existe"
fi

# Configurar ACLs para producer
echo "🔑 Configurando permissões para producer..."
rpk acl create --allow-principal User:producer --operation write --operation create --operation describe --topic "*" || true
rpk acl create --allow-principal User:producer --operation write --operation create --operation describe --group "*" || true

# Configurar ACLs para consumer
echo "🔑 Configurando permissões para consumer..."
rpk acl create --allow-principal User:consumer --operation read --operation describe --topic "*" || true
rpk acl create --allow-principal User:consumer --operation read --operation describe --group "*" || true

# Criar tópicos padrão se não existirem
echo "📝 Criando tópicos padrão..."

if ! rpk topic list | grep -q "logins"; then
    echo "   Criando tópico logins..."
    rpk topic create logins --partitions 3 --replicas 1
fi

if ! rpk topic list | grep -q "transactions"; then
    echo "   Criando tópico transactions..."
    rpk topic create transactions --partitions 3 --replicas 1
fi

if ! rpk topic list | grep -q "test-topic"; then
    echo "   Criando tópico test-topic..."
    rpk topic create test-topic --partitions 3 --replicas 1
fi

# Registrar schema se disponível
if [ -f "/etc/redpanda/transactions-schema.json" ]; then
    echo "📋 Registrando schema transactions..."
    rpk registry schema create transactions --schema /etc/redpanda/transactions-schema.json || true
fi

echo "✅ Configuração automática concluída!"
echo ""
echo "📋 Usuários criados:"
echo "   - producer (senha: ${PRODUCER_PASSWORD:-producer123})"
echo "   - consumer (senha: ${CONSUMER_PASSWORD:-consumer123})"
echo "   - admin (senha: ${REDPANDA_ADMIN_PASSWORD:-admin123})"
echo ""
echo "🔑 Permissões:"
echo "   - producer: WRITE, CREATE, DESCRIBE em todos os tópicos"
echo "   - consumer: READ, DESCRIBE em todos os tópicos"
echo "   - admin: Acesso total (superuser)"
echo ""
echo "🎉 Redpanda está pronto para uso!"

# Aguardar o processo principal do Redpanda
wait $REDPANDA_PID