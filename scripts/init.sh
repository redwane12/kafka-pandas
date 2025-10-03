#!/bin/bash
set -e

echo "🚀 Iniciando Redpanda com configuração automática..."

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
