# 🚀 Deploy no Railway - Guia Completo

## 🔧 **Problema Resolvido**

O erro `"too many positional options have been specified on the command line"` foi corrigido com:

- ✅ **Dockerfile.railway**: Versão simplificada para Railway
- ✅ **start-railway.sh**: Script sem argumentos extras
- ✅ **railway.json**: Configurado para usar os arquivos corretos

## 📋 **Arquivos para Railway**

### **1. Dockerfile.railway**
- Usa `bootstrap.simple.yml` (configuração simplificada)
- CMD: `/app/scripts/start-railway.sh`
- Sem argumentos extras que causam erro

### **2. start-railway.sh**
- Script simplificado para Railway
- Apenas `exec redpanda start` (sem argumentos)
- Configurações via variáveis de ambiente

### **3. railway.json**
- Aponta para `Dockerfile.railway`
- Start command: `/app/scripts/start-railway.sh`

## 🚀 **Como Fazer Deploy**

### **1. Preparar Arquivos**
```bash
# Certificar que está na pasta prod
cd prod

# Verificar arquivos necessários
ls -la Dockerfile.railway
ls -la scripts/start-railway.sh
ls -la railway.json
```

### **2. Fazer Push para Repositório**
```bash
# Adicionar arquivos novos
git add Dockerfile.railway scripts/start-railway.sh railway.json

# Commit
git commit -m "🚀 Add Railway-specific files

- Dockerfile.railway: Simplified for Railway
- start-railway.sh: Script without extra arguments
- railway.json: Updated configuration"

# Push
git push origin main
```

### **3. Deploy no Railway**
```bash
# Usar o script de deploy
./deploy.sh

# Ou manualmente:
# 1. Acesse railway.app
# 2. Conecte seu repositório
# 3. Railway detectará automaticamente o railway.json
# 4. Deploy será feito com Dockerfile.railway
```

## ⚙️ **Variáveis de Ambiente no Railway**

### **Configurar no Dashboard Railway:**
```bash
# Autenticação
REDPANDA_ADMIN_USER=admin
REDPANDA_ADMIN_PASSWORD=sua_senha_segura

# Usuários clientes
PRODUCER_USER=producer
PRODUCER_PASSWORD=senha_producer
CONSUMER_USER=consumer
CONSUMER_PASSWORD=senha_consumer

# Performance
REDPANDA_SMP=2
REDPANDA_MEMORY=2G
REDPANDA_OVERPROVISIONED=false

# Logs
REDPANDA_LOG_LEVEL=info
```

## 🔍 **Verificar Deploy**

### **1. Logs do Railway:**
- Acesse o dashboard do Railway
- Vá em "Deployments" → "View Logs"
- Deve mostrar: `Successfully started Redpanda!`

### **2. Testar Conectividade:**
```bash
# Usar as URLs do Railway
# Kafka API: wss://seu-projeto.railway.app:9092
# Schema Registry: https://seu-projeto.railway.app:8081
# Admin API: https://seu-projeto.railway.app:9644
```

### **3. Configurar Usuários (Após Deploy):**
```bash
# Via Railway CLI
railway run rpk acl user create producer --password senha_producer
railway run rpk acl user create consumer --password senha_consumer

# Ou via script
railway run /app/scripts/setup-auth.sh
```

## 🛠️ **Troubleshooting**

### **Se ainda der erro:**
1. **Verificar logs**: Railway dashboard → Logs
2. **Verificar variáveis**: Railway dashboard → Variables
3. **Redeploy**: Railway dashboard → Redeploy

### **Se não conectar:**
1. **Verificar portas**: Railway expõe automaticamente
2. **Verificar URLs**: Usar as URLs do Railway
3. **Verificar autenticação**: Usar credenciais corretas

## 📊 **Estrutura Final**

```
prod/
├── Dockerfile                    # Para uso local
├── Dockerfile.railway           # Para Railway (simplificado)
├── bootstrap.simple.yml         # Configuração simplificada
├── scripts/
│   ├── start.sh                 # Para uso local
│   ├── start-railway.sh         # Para Railway (simplificado)
│   └── setup-auth.sh            # Configuração de usuários
├── railway.json                 # Configuração Railway
└── env.example                  # Variáveis de ambiente
```

## ✅ **Checklist de Deploy**

- [ ] Arquivos `Dockerfile.railway` e `start-railway.sh` criados
- [ ] `railway.json` atualizado
- [ ] Push feito para repositório
- [ ] Variáveis de ambiente configuradas no Railway
- [ ] Deploy executado
- [ ] Logs verificados (sem erros)
- [ ] Conectividade testada
- [ ] Usuários configurados

**Agora o deploy no Railway deve funcionar sem o erro de argumentos!** 🎉
