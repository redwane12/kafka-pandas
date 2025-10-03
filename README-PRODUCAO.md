# 🚀 Redpanda Quickstart - Configuração para Produção

Este projeto foi configurado para produção na Railway com autenticação robusta e alta disponibilidade.

## 📋 Pré-requisitos

- Conta na [Railway](https://railway.app)
- Docker instalado localmente (para testes)
- Cliente Kafka (opcional, para testes)

## 🚀 Deploy na Railway

### 1. Preparação do Projeto

```bash
# Clone o repositório
git clone <seu-repositorio>
cd redpanda-quickstart

# Configure as variáveis de ambiente
cp env.example .env
# Edite o arquivo .env com suas configurações
```

### 2. Configuração das Variáveis de Ambiente

Configure as seguintes variáveis no Railway:

#### 🔐 Autenticação (OBRIGATÓRIAS)
```
REDPANDA_ADMIN_USER=admin
REDPANDA_ADMIN_PASSWORD=sua_senha_admin_super_segura
PRODUCER_USER=producer
PRODUCER_PASSWORD=sua_senha_producer_segura
CONSUMER_USER=consumer
CONSUMER_PASSWORD=sua_senha_consumer_segura
```

#### 🌐 Rede (Railway configurará automaticamente)
```
REDPANDA_KAFKA_PORT=9092
REDPANDA_SCHEMA_REGISTRY_PORT=8081
REDPANDA_PANDAPROXY_PORT=8082
REDPANDA_METRICS_PORT=9644
CONSOLE_PORT=8080
```

### 3. Deploy

1. Conecte seu repositório ao Railway
2. Configure as variáveis de ambiente
3. Faça o deploy

## 🔌 Conectando Clientes

### Configurações de Conexão

Após o deploy, você receberá os seguintes endpoints:

- **Kafka API**: `wss://seu-projeto.railway.app:9092`
- **Schema Registry**: `https://seu-projeto.railway.app:8081`
- **Pandaproxy**: `https://seu-projeto.railway.app:8082`
- **Console**: `https://seu-projeto.railway.app:8080`

### 🔧 Configuração para Producers

```json
{
  "bootstrap_servers": ["wss://seu-projeto.railway.app:9092"],
  "security_protocol": "SASL_SSL",
  "sasl_mechanism": "SCRAM-SHA-256",
  "sasl_plain_username": "producer",
  "sasl_plain_password": "sua_senha_producer_segura",
  "client_id": "meu-producer",
  "acks": "all",
  "retries": 3,
  "compression_type": "snappy"
}
```

### 🔧 Configuração para Consumers

```json
{
  "bootstrap_servers": ["wss://seu-projeto.railway.app:9092"],
  "security_protocol": "SASL_SSL",
  "sasl_mechanism": "SCRAM-SHA-256",
  "sasl_plain_username": "consumer",
  "sasl_plain_password": "sua_senha_consumer_segura",
  "group_id": "meu-consumer-group",
  "auto_offset_reset": "earliest",
  "enable_auto_commit": true
}
```

## 📊 Tópicos Disponíveis

O sistema cria automaticamente os seguintes tópicos:

- **`logins`**: Dados de login de usuários
- **`transactions`**: Transações de compra
- **`edu-filtered-domains`**: Emails filtrados com domínio .edu

## 🛠️ Comandos Úteis

### Usando RPK (Redpanda CLI)

```bash
# Configurar perfil
export REDPANDA_KAFKA_ENDPOINT="wss://seu-projeto.railway.app:9092"
export CONSUMER_USER="consumer"
export CONSUMER_PASSWORD="sua_senha_consumer_segura"

# Listar tópicos
rpk topic list

# Consumir mensagens
rpk topic consume logins --num 10

# Produzir mensagem
echo '{"user_id": 1, "email": "test@example.edu"}' | rpk topic produce logins
```

### Health Check

```bash
# Verificar status do cluster
rpk cluster info

# Verificar usuários
rpk acl user list

# Verificar transforms
rpk transform list
```

## 🔒 Segurança

### Autenticação
- **SASL/SCRAM-SHA-256** para autenticação
- Usuários separados para producers e consumers
- Senhas fortes obrigatórias

### Autorização
- Producers: permissões de escrita e criação
- Consumers: permissões de leitura
- Admin: acesso total ao cluster

### Rede
- **TLS/SSL** habilitado para todas as conexões
- Portas expostas apenas as necessárias
- Firewall configurado automaticamente

## 📈 Monitoramento

### Console Web
Acesse `https://seu-projeto.railway.app:8080` para:
- Monitorar tópicos e mensagens
- Gerenciar usuários e permissões
- Visualizar métricas do cluster
- Gerenciar schemas

### Métricas
- **Prometheus**: `https://seu-projeto.railway.app:9644/metrics`
- **Health Check**: `https://seu-projeto.railway.app:9644/health`

## 🚨 Troubleshooting

### Problemas Comuns

1. **Erro de Conexão**
   - Verifique se as variáveis de ambiente estão corretas
   - Confirme se o serviço está rodando no Railway

2. **Erro de Autenticação**
   - Verifique usuário e senha
   - Confirme se o usuário tem as permissões necessárias

3. **Erro de Schema**
   - Verifique se o Schema Registry está acessível
   - Confirme se o schema está registrado

### Logs

```bash
# Ver logs do serviço
railway logs

# Ver logs específicos
railway logs --service redpanda
```

## 🔄 Atualizações

### Atualizar Configurações
1. Modifique as variáveis de ambiente no Railway
2. Reinicie o serviço
3. Execute o script de configuração se necessário

### Atualizar Código
1. Faça push das alterações
2. Railway fará o rebuild automático
3. Verifique se tudo está funcionando

## 📞 Suporte

- **Documentação Redpanda**: https://docs.redpanda.com
- **Railway Docs**: https://docs.railway.app
- **Issues**: Abra uma issue no repositório

## 📝 Licença

Este projeto segue a licença do Redpanda Quickstart original.
