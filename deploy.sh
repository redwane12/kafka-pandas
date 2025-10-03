#!/bin/bash

# Script principal de deploy para produção
set -e

echo "🚀 Redpanda Production Deploy"
echo "=============================="

# Verificar se estamos na pasta correta
if [ ! -f "Dockerfile" ]; then
    echo "❌ Execute este script a partir da pasta prod/"
    exit 1
fi

# Menu de opções
echo ""
echo "Escolha uma opção:"
echo "1) Build local"
echo "2) Deploy na Railway"
echo "3) Executar localmente com Docker Compose"
echo "4) Configurar usuários e tópicos"
echo "5) Health check"
echo ""

read -p "Digite sua opção (1-5): " option

case $option in
    1)
        echo "🔨 Building local image..."
        ./build.sh
        ;;
    2)
        echo "🚀 Deploy na Railway..."
        ./scripts/deploy-railway.sh
        ;;
    3)
        echo "🐳 Executando localmente..."
        docker-compose -f docker-compose.prod.yml up -d
        echo "✅ Serviço iniciado!"
        echo "🌐 Console: http://localhost:8080"
        echo "📊 Kafka: localhost:9092"
        ;;
    4)
        echo "👥 Configurando usuários e tópicos..."
        docker-compose -f docker-compose.prod.yml exec redpanda ./scripts/setup-users.sh
        ;;
    5)
        echo "🏥 Health check..."
        docker-compose -f docker-compose.prod.yml exec redpanda ./scripts/health-check.sh
        ;;
    *)
        echo "❌ Opção inválida"
        exit 1
        ;;
esac

echo ""
echo "✅ Operação concluída!"
