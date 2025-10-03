# 🚀 Quick Start - Redpanda Produção

## ⚡ Deploy Rápido na Railway

### 1. Preparação

```bash
# Entrar na pasta de produção
cd prod/

# Configurar variáveis de ambiente
cp env.example .env
```

### 2. Configurar Variáveis (OBRIGATÓRIO)

Edite o arquivo `.env` com suas configurações:

```bash
# Autenticação (OBRIGATÓRIO)
REDPANDA_ADMIN_USER=admin
REDPANDA_ADMIN_PASSWORD=sua_senha_admin_super_segura
PRODUCER_USER=producer
PRODUCER_PASSWORD=sua_senha_producer_segura
CONSUMER_USER=consumer
CONSUMER_PASSWORD=sua_senha_consumer_segura
```

### 3. Deploy

```bash
# Opção 1: Script interativo
./deploy.sh

# Opção 2: Deploy direto na Railway
railway up
```

### 4. Configurar Usuários e Tópicos

```bash
# Após o deploy, configurar usuários
railway run ./scripts/setup-users.sh
```

## 🐳 Desenvolvimento Local

```bash
# Build da imagem
./build.sh

# Executar localmente
docker-compose -f docker-compose.prod.yml up -d

# Acessar console
open http://localhost:8080
```

## 🔌 Conectar Clientes

### URLs Após Deploy

- **Kafka**: `wss://seu-projeto.railway.app:9092`
- **Schema Registry**: `https://seu-projeto.railway.app:8081`
- **Console**: `https://seu-projeto.railway.app:8080`

### Configuração de Cliente

Use os arquivos em `client-configs/`:

```json
{
  "bootstrap_servers": ["wss://seu-projeto.railway.app:9092"],
  "security_protocol": "SASL_SSL",
  "sasl_mechanism": "SCRAM-SHA-256",
  "sasl_plain_username": "producer",
  "sasl_plain_password": "sua_senha_producer_segura"
}
```

## 📊 Tópicos Disponíveis

- `logins` - Dados de login de usuários
- `transactions` - Transações de compra
- `edu-filtered-domains` - Emails filtrados (.edu)

## 🛠️ Comandos Úteis

```bash
# Health check
./scripts/health-check.sh

# Ver logs
railway logs

# Status do serviço
railway status

# Listar tópicos
railway run rpk topic list

# Consumir mensagens
railway run rpk topic consume logins --num 10
```

## 🚨 Troubleshooting

### Problema: Erro de Conexão
- Verifique se as variáveis de ambiente estão corretas
- Confirme se o serviço está rodando: `railway status`

### Problema: Erro de Autenticação
- Verifique usuário e senha no arquivo `.env`
- Confirme se os usuários foram criados: `railway run ./scripts/setup-users.sh`

### Problema: Tópicos não aparecem
- Execute o script de configuração: `railway run ./scripts/setup-users.sh`
- Verifique logs: `railway logs`

## 📚 Próximos Passos

1. **Configure seus clientes** usando as credenciais do `.env`
2. **Acesse o Console** para monitorar mensagens
3. **Configure alertas** no Railway Dashboard
4. **Implemente seus producers/consumers** usando as configurações em `client-configs/`

## 🔗 Links Úteis

- [Documentação Completa](README-PRODUCAO.md)
- [Railway Dashboard](https://railway.app/dashboard)
- [Redpanda Docs](https://docs.redpanda.com)
