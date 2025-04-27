#!/bin/bash

# Cores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Verifica se a API key foi fornecida
if [ -z "$MGC_API_KEY" ]; then
    echo -e "${RED}Erro: MGC_API_KEY não está definida${NC}"
    echo "Execute: export MGC_API_KEY=sua_api_key"
    exit 1
fi

# Configurações
REGION="br-se1"
IMAGE_NAME="dev-oda-fsfg"
REGISTRY="api.magalu.cloud"

# Verifica se o MGC CLI está instalado
if ! command -v mgc &> /dev/null; then
    echo -e "${RED}Erro: MGC CLI não está instalado${NC}"
    echo "Instale seguindo as instruções em: https://docs.magalu.cloud/docs/cli/overview"
    exit 1
fi

# Cria diretório .mgc se não existir
mkdir -p ~/.mgc

# Configura a região e API key
echo -e "${GREEN}Configurando região e API key...${NC}"
mgc config set region $REGION
echo "$MGC_API_KEY" > ~/.mgc/api-key

# Tenta criar o repositório (ignora erro se já existe)
echo -e "${GREEN}Verificando/criando repositório no registry...${NC}"
mgc container-registry registries create --name $IMAGE_NAME 2>/dev/null || true

# Obtendo credenciais do registry
echo -e "${GREEN}Obtendo credenciais do registry...${NC}"

# Login no Docker usando diferentes métodos
echo -e "${GREEN}Realizando login no Docker...${NC}"

# Função para tentar login com diferentes combinações
try_login() {
    local registry=$1
    local username=$2
    local password=$3
    local desc=$4

    echo -e "${YELLOW}Tentando login em $registry com usuário $username ($desc)...${NC}"
    echo "$password" | docker login $registry -u "$username" --password-stdin
    return $?
}

# Tentativas de login com diferentes combinações
LOGIN_SUCCESS=0

# Tentativa 1: Login direto no registry base com oauth2
try_login "$REGISTRY" "oauth2" "$MGC_API_KEY" "método padrão"
if [ $? -eq 0 ]; then
    LOGIN_SUCCESS=1
    echo -e "${GREEN}Login bem-sucedido com método 1!${NC}"
fi

# Tentativa 2: Login com a região específica
if [ $LOGIN_SUCCESS -eq 0 ]; then
    try_login "$REGISTRY/$REGION" "oauth2" "$MGC_API_KEY" "com região"
    if [ $? -eq 0 ]; then
        LOGIN_SUCCESS=1
        echo -e "${GREEN}Login bem-sucedido com método 2!${NC}"
    fi
fi

# Tentativa 3: Login usando o próprio API key como usuário
if [ $LOGIN_SUCCESS -eq 0 ]; then
    try_login "$REGISTRY" "$MGC_API_KEY" "$MGC_API_KEY" "API key como usuário"
    if [ $? -eq 0 ]; then
        LOGIN_SUCCESS=1
        echo -e "${GREEN}Login bem-sucedido com método 3!${NC}"
    fi
fi

# Tentativa 4: Login com a região e API key como usuário
if [ $LOGIN_SUCCESS -eq 0 ]; then
    try_login "$REGISTRY/$REGION" "$MGC_API_KEY" "$MGC_API_KEY" "região e API key como usuário"
    if [ $? -eq 0 ]; then
        LOGIN_SUCCESS=1
        echo -e "${GREEN}Login bem-sucedido com método 4!${NC}"
    fi
fi

# Tentativa 5: Login com formato do GitHub Actions
if [ $LOGIN_SUCCESS -eq 0 ]; then
    try_login "$REGISTRY" "$MGC_API_KEY" "$MGC_API_KEY" "formato do GitHub Actions"
    if [ $? -eq 0 ]; then
        LOGIN_SUCCESS=1
        echo -e "${GREEN}Login bem-sucedido com método 5!${NC}"
    fi
fi

# Tentativa 6: Login com formato alternativo
if [ $LOGIN_SUCCESS -eq 0 ]; then
    try_login "$REGISTRY/$REGION/$IMAGE_NAME" "oauth2" "$MGC_API_KEY" "com região e repositório"
    if [ $? -eq 0 ]; then
        LOGIN_SUCCESS=1
        echo -e "${GREEN}Login bem-sucedido com método 6!${NC}"
    fi
fi

if [ $LOGIN_SUCCESS -eq 1 ]; then
    echo -e "${GREEN}Login realizado com sucesso!${NC}"

    # Lista os repositórios disponíveis
    echo -e "\n${GREEN}Listando repositórios disponíveis...${NC}"
    mgc container-registry registries list --api-key $MGC_API_KEY
else
    echo -e "${RED}Falha em todas as tentativas de login do Docker${NC}"
    echo -e "${YELLOW}Dicas de solução:${NC}"
    echo -e "1. Verifique se a API key está correta"
    echo -e "2. Verifique se a região está correta (atualmente: $REGION)"
    echo -e "3. Consulte a documentação do Magalu Cloud para o formato correto de autenticação"
    echo -e "4. Verifique se o repositório $IMAGE_NAME existe no registry"
    exit 1
fi

# Dockerfile
FROM node:16-alpine AS base

# Instalar PNPM
RUN npm install -g pnpm

# Configurar PNPM para ser mais rápido
RUN pnpm config set registry https://registry.npmmirror.com/ && \
    pnpm config set auto-install-peers true && \
    pnpm config set strict-peer-dependencies false

# Estágio de dependências
FROM base AS deps
WORKDIR /app

# Copiar apenas os arquivos necessários para instalação
COPY package.json pnpm-lock.yaml* ./

# Instalar dependências usando PNPM
RUN pnpm install --frozen-lockfile

# Estágio de build
FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN pnpm run build

# Estágio de produção
FROM nginx:alpine
COPY --from=builder /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
