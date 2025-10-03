# 🔧 Railway vs Local - Diferenças de Comando

## ❌ **Problema Identificado**

O Railway executa comandos de forma diferente do ambiente local:

### **Local (Funciona):**
```bash
docker run ... redpanda-prod-final
# Executa: redpanda start
```

### **Railway (Erro):**
```bash
# Railway executa: rpk redpanda start
# Resultado: Error: unknown command "rpk" for "rpk"
```

## ✅ **Solução Aplicada**

### **Dockerfile (Para Local):**
```dockerfile
# Funciona localmente
CMD ["redpanda", "start"]
```

### **Dockerfile.railway (Para Railway):**
```dockerfile
# Funciona no Railway
CMD ["redpanda"]
```

### **railway.json:**
```json
{
  "build": {
    "dockerfilePath": "Dockerfile.railway"
  }
}
```

## 🚀 **Como Usar**

### **Para Desenvolvimento Local:**
```bash
# Usar Dockerfile normal
docker build -t redpanda-local -f Dockerfile .
docker run -d --name redpanda-local -p 9092:9092 redpanda-local
```

### **Para Deploy no Railway:**
```bash
# Usar Dockerfile.railway
# Railway detecta automaticamente via railway.json
git push origin main
```

## 📋 **Estrutura de Arquivos**

```
prod/
├── Dockerfile              # Para uso local
├── Dockerfile.railway      # Para Railway
├── railway.json            # Configuração Railway
├── bootstrap.simple.yml    # Configuração Redpanda
└── env.example             # Variáveis de ambiente
```

## 🔍 **Diferenças Técnicas**

### **Local:**
- Docker executa `CMD` diretamente
- `CMD ["redpanda", "start"]` funciona

### **Railway:**
- Railway executa via `rpk` wrapper
- `CMD ["redpanda"]` funciona
- `CMD ["redpanda", "start"]` falha

## ✅ **Checklist**

- [ ] `Dockerfile` - Para desenvolvimento local
- [ ] `Dockerfile.railway` - Para Railway
- [ ] `railway.json` - Configuração Railway
- [ ] Teste local funcionando
- [ ] Deploy Railway funcionando

**Agora você tem duas versões: uma para local e outra para Railway!** 🎉
