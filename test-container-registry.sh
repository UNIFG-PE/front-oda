#!/bin/bash

# Cores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Verifica se a API key foi fornecida
if [ -z "$MGC_API_KEY" ]; then
    echo -e "${RED}Erro: MGC_API_KEY não está definida${NC}"
    echo "Execute: export MGC_API_KEY=sua_api_key"
    exit 1
fi

# Configurações
REGISTRY="container-registry.br-se1.magalu.cloud"
REGION="br-se1"
IMAGE_NAME="dev-oda-fsfg"

echo -e "${BLUE}=== Testando autenticação no container registry ====${NC}"

# Função para tentar login com diferentes combinações
try_login() {
    local registry=$1
    local username=$2
    local password=$3
    local desc=$4
    
    echo -e "\n${YELLOW}Tentando login em $registry com usuário $username ($desc)...${NC}"
    echo "$password" | docker login $registry -u "$username" --password-stdin
    return $?
}

# Tentativas de login com diferentes combinações
LOGIN_SUCCESS=0

# Tentativa 1: Login com oauth2
try_login "$REGISTRY" "oauth2" "$MGC_API_KEY" "método oauth2"
if [ $? -eq 0 ]; then
    LOGIN_SUCCESS=1
    echo -e "${GREEN}Login bem-sucedido com método 1!${NC}"
fi

# Tentativa 2: Login com a API key como usuário
if [ $LOGIN_SUCCESS -eq 0 ]; then
    try_login "$REGISTRY" "$MGC_API_KEY" "$MGC_API_KEY" "API key como usuário e senha"
    if [ $? -eq 0 ]; then
        LOGIN_SUCCESS=1
        echo -e "${GREEN}Login bem-sucedido com método 2!${NC}"
    fi
fi

# Tentativa 3: Login com usuário vazio
if [ $LOGIN_SUCCESS -eq 0 ]; then
    try_login "$REGISTRY" "" "$MGC_API_KEY" "usuário vazio"
    if [ $? -eq 0 ]; then
        LOGIN_SUCCESS=1
        echo -e "${GREEN}Login bem-sucedido com método 3!${NC}"
    fi
fi

# Tentativa 4: Login com usuário 'mgc'
if [ $LOGIN_SUCCESS -eq 0 ]; then
    try_login "$REGISTRY" "mgc" "$MGC_API_KEY" "usuário 'mgc'"
    if [ $? -eq 0 ]; then
        LOGIN_SUCCESS=1
        echo -e "${GREEN}Login bem-sucedido com método 4!${NC}"
    fi
fi

# Verificar se conseguimos fazer login
if [ $LOGIN_SUCCESS -eq 1 ]; then
    echo -e "\n${GREEN}Login realizado com sucesso!${NC}"
    
    # Tentar listar as imagens
    echo -e "\n${GREEN}Tentando listar as imagens...${NC}"
    docker images | grep $REGISTRY
    
    # Tentar pull de uma imagem
    echo -e "\n${GREEN}Tentando pull de uma imagem...${NC}"
    docker pull $REGISTRY/$IMAGE_NAME:latest 2>/dev/null || echo -e "${YELLOW}Imagem não encontrada ou não acessível${NC}"
else
    echo -e "\n${RED}Falha em todas as tentativas de login${NC}"
    
    # Tentar obter mais informações sobre o registry
    echo -e "\n${GREEN}Tentando obter mais informações sobre o registry...${NC}"
    curl -s -X GET "https://$REGISTRY/v2/" -H "Authorization: Bearer $MGC_API_KEY" || echo "Falha ao acessar o endpoint /v2/"
    
    echo -e "\n${YELLOW}Recomendações:${NC}"
    echo "1. Entre em contato com o suporte do Magalu Cloud para confirmar o método correto de autenticação"
    echo "2. Verifique se sua API key tem permissões para acessar o container registry"
    echo "3. Verifique se o serviço de container registry está ativado na sua conta"
fi

echo -e "\n${BLUE}=== Teste Concluído ====${NC}"
