#!/bin/bash

# Script para deploy automático na Railway
set -e

echo "🚀 Deploy do Redpanda na Railway..."

# Verificar se Railway CLI está instalado
if ! command -v railway &> /dev/null; then
    echo "❌ Railway CLI não encontrado. Instale com:"
    echo "   npm install -g @railway/cli"
    echo "   ou"
    echo "   curl -fsSL https://railway.app/install.sh | sh"
    exit 1
fi

# Verificar se está logado
if ! railway whoami &> /dev/null; then
    echo "🔐 Faça login na Railway:"
    railway login
fi

# Verificar se estamos na pasta correta
if [ ! -f "../railway.json" ]; then
    echo "❌ Execute este script a partir da pasta prod/scripts/"
    exit 1
fi

# Verificar variáveis de ambiente
echo "🔍 Verificando variáveis de ambiente..."
required_vars=("REDPANDA_ADMIN_USER" "REDPANDA_ADMIN_PASSWORD" "PRODUCER_USER" "PRODUCER_PASSWORD" "CONSUMER_USER" "CONSUMER_PASSWORD")

for var in "${required_vars[@]}"; do
    if [ -z "${!var}" ]; then
        echo "❌ Variável $var não está definida"
        echo "   Configure no Railway Dashboard ou no arquivo .env"
        exit 1
    fi
done

echo "✅ Variáveis de ambiente configuradas"

# Fazer deploy
echo "🚀 Iniciando deploy..."
cd ..
railway up

# Aguardar deploy
echo "⏳ Aguardando deploy..."
sleep 30

# Verificar status
echo "🔍 Verificando status do serviço..."
railway status

# Obter URLs
echo "🌐 URLs do serviço:"
railway domain

echo "✅ Deploy concluído!"
echo ""
echo "📋 Próximos passos:"
echo "1. Configure as variáveis de ambiente no Railway Dashboard"
echo "2. Acesse o Console em: https://seu-projeto.railway.app:8080"
echo "3. Configure seus clientes usando as credenciais fornecidas"
echo ""
echo "🔧 Para configurar usuários e tópicos:"
echo "   railway run ./scripts/setup-users.sh"
