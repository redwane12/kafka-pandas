# 🔧 Correção Railway - Comando de Inicialização

## ❌ **Problema Identificado**

O Railway estava tentando executar o script como comando `rpk`:
```
Error: unknown command "/app/scripts/start-railway.sh" for "rpk"
```

## ✅ **Solução Aplicada**

### **1. Dockerfile.railway Corrigido**
```dockerfile
# Antes (INCORRETO)
CMD ["/app/scripts/start-railway.sh"]

# Depois (CORRETO)
CMD ["/bin/bash", "/app/scripts/start-railway.sh"]
```

### **2. railway.json Atualizado**
```json
{
  "deploy": {
    "startCommand": "/bin/bash /app/scripts/start-railway.sh",
    "healthcheckTimeout": 300,
    "restartPolicyType": "ON_FAILURE",
    "restartPolicyMaxRetries": 3
  }
}
```

## 🚀 **Como Aplicar a Correção**

### **1. Fazer Push das Correções**
```bash
cd prod

# Adicionar arquivos corrigidos
git add Dockerfile.railway railway.json

# Commit
git commit -m "🔧 Fix Railway startup command

- Dockerfile.railway: Use /bin/bash to execute script
- railway.json: Add explicit startCommand"

# Push
git push origin main
```

### **2. Redeploy no Railway**
- Acesse o dashboard do Railway
- Vá em "Deployments"
- Clique em "Redeploy" ou aguarde o deploy automático

### **3. Verificar Logs**
Após o redeploy, os logs devem mostrar:
```
🚀 Iniciando Redpanda no Railway...
📋 Configurações Railway:
  - RPC Server: 0.0.0.0:33145
  - Kafka API: 0.0.0.0:9092
  ...
🎯 Iniciando Redpanda...
```

## 🔍 **Verificação**

### **Logs Esperados:**
- ✅ `🚀 Iniciando Redpanda no Railway...`
- ✅ `📋 Configurações Railway:`
- ✅ `🎯 Iniciando Redpanda...`
- ✅ `Successfully started Redpanda!`

### **Logs de Erro (se ainda houver):**
- ❌ `Error: unknown command "/app/scripts/start-railway.sh" for "rpk"`
- ❌ `exec /app/scripts/start-railway.sh: exec format error`

## 📋 **Checklist de Correção**

- [ ] `Dockerfile.railway` atualizado com `/bin/bash`
- [ ] `railway.json` com `startCommand` explícito
- [ ] Push feito para repositório
- [ ] Redeploy executado no Railway
- [ ] Logs verificados (sem erros de comando)
- [ ] Redpanda iniciando corretamente

**Agora o Railway deve executar o script corretamente!** 🎯
