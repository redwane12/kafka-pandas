# 🚀 Deploy para Repositório GitHub

## 📋 Pré-requisitos

1. **Conta GitHub** criada
2. **Token clássico** gerado
3. **Git** instalado no sistema
4. **Projeto** na pasta `prod/`

## 🔑 1. Gerar Token Clássico no GitHub

### **Passos:**
1. Acesse: https://github.com/settings/tokens
2. Clique em **"Generate new token"** → **"Generate new token (classic)"**
3. Configure:
   - **Note**: `Redpanda Quickstart Production`
   - **Expiration**: `90 days` (ou sua preferência)
   - **Scopes**: Marque `repo` (acesso completo aos repositórios)
4. Clique em **"Generate token"**
5. **COPIE O TOKEN** (você só verá uma vez!)

## 🗂️ 2. Preparar o Repositório

### **Criar repositório no GitHub:**
1. Acesse: https://github.com/new
2. **Repository name**: `redpanda-quickstart-prod`
3. **Description**: `Redpanda Quickstart - Production Ready with Docker`
4. **Visibility**: `Public` ou `Private` (sua escolha)
5. **Initialize**: ❌ NÃO marque nenhuma opção
6. Clique em **"Create repository"**

## 🚀 3. Configurar Git Local

### **Comandos para executar:**

```bash
# Navegar para a pasta prod
cd C:\Users\DELL\Documents\nginx\redpanda-quickstart\docker-compose\prod

# Inicializar repositório Git
git init

# Configurar usuário (substitua pelos seus dados)
git config user.name "Seu Nome"
git config user.email "seu.email@example.com"

# Adicionar arquivos
git add .

# Commit inicial
git commit -m "🚀 Initial commit: Redpanda Quickstart Production

- Dockerfile otimizado para produção
- Configuração SASL e autenticação
- Scripts de inicialização automática
- Schema Registry e Data Transforms
- Configurações para Railway deploy
- Documentação completa"

# Adicionar repositório remoto (substitua SEU_USUARIO)
git remote add origin https://github.com/SEU_USUARIO/redpanda-quickstart-prod.git

# Fazer push (usar token como senha)
git push -u origin main
```

## 🔐 4. Usar Token no Push

### **Quando pedir credenciais:**
- **Username**: `SEU_USUARIO_GITHUB`
- **Password**: `SEU_TOKEN_CLASSICO` (não sua senha!)

### **Exemplo:**
```
Username for 'https://github.com': seuusuario
Password for 'https://github.com/seuusuario/redpanda-quickstart-prod.git': ghp_xxxxxxxxxxxxxxxxxxxx
```

## 📁 5. Estrutura do Repositório

### **Arquivos que serão enviados:**
```
redpanda-quickstart-prod/
├── Dockerfile                    # Imagem de produção
├── bootstrap.prod.yml            # Configuração Redpanda
├── transactions-schema.json      # Schema JSON
├── env.example                   # Variáveis de ambiente
├── railway.json                  # Configuração Railway
├── deploy.sh                     # Script de deploy
├── README.md                     # Documentação principal
├── README-PRODUCAO.md            # Documentação detalhada
├── QUICK-START.md                # Guia rápido
├── DOCKERFILE-FINAL.md           # Documentação do Dockerfile
├── .gitignore                    # Arquivos ignorados
├── scripts/
│   ├── start.sh                  # Script de inicialização
│   ├── setup-auth.sh             # Configuração de usuários
│   ├── deploy-railway.sh         # Deploy Railway
│   ├── entrypoint.sh             # Entrypoint personalizado
│   └── init.sh                   # Script de inicialização
├── client-configs/               # Configurações para clientes
│   ├── producer-config.json
│   ├── consumer-config.json
│   └── rpk-profile.yaml
└── transform/                    # Data transforms (WASM)
    ├── regex.wasm
    ├── transform.go
    └── transform.yaml
```

## 🎯 6. Comandos Rápidos

### **Para fazer push de atualizações:**
```bash
# Adicionar mudanças
git add .

# Commit com mensagem
git commit -m "📝 Update: descrição da mudança"

# Push para o repositório
git push origin main
```

### **Para clonar o repositório:**
```bash
git clone https://github.com/SEU_USUARIO/redpanda-quickstart-prod.git
cd redpanda-quickstart-prod
```

## 🔒 7. Segurança

### **⚠️ IMPORTANTE:**
- **NUNCA** commite arquivos `.env` com senhas reais
- **SEMPRE** use `env.example` como template
- **MANTENHA** o token seguro e não compartilhe
- **ROTACIONE** o token periodicamente

### **Arquivos no .gitignore:**
```
.env
.env.local
.env.production
*.log
data/
redpanda-data/
```

## 🚀 8. Próximos Passos

### **Após o push:**
1. **Verificar** se todos os arquivos foram enviados
2. **Testar** clonando o repositório
3. **Configurar** GitHub Actions (opcional)
4. **Documentar** no README principal

## 📞 9. Suporte

### **Se der erro:**
- Verifique se o token tem permissão `repo`
- Confirme se o repositório existe
- Verifique se o usuário está correto
- Teste com `git remote -v`

**Agora você pode compartilhar seu projeto Redpanda com o mundo!** 🌍
