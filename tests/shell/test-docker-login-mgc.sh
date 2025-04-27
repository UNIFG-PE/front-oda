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

echo -e "${BLUE}=== Tentando login no Docker usando MGC CLI ====${NC}"

# Verificar se o MGC CLI está instalado
if ! command -v mgc &> /dev/null; then
    echo -e "${RED}Erro: MGC CLI não está instalado${NC}"
    echo "Instale seguindo as instruções em: https://docs.magalu.cloud/docs/cli/overview"
    exit 1
fi

# Configurar a região
echo -e "\n${GREEN}Configurando região...${NC}"
mgc config set region $REGION

# Tentar obter credenciais do registry
echo -e "\n${GREEN}Tentando obter credenciais do registry...${NC}"
CREDENTIALS=$(mgc container-registry credentials get --api-key="$MGC_API_KEY" 2>/dev/null)

if [ $? -eq 0 ] && [ ! -z "$CREDENTIALS" ]; then
    echo -e "${GREEN}Credenciais obtidas com sucesso!${NC}"
    
    # Extrair usuário e senha das credenciais (ajuste conforme o formato real)
    # Este é um exemplo, você precisará ajustar conforme o formato real das credenciais
    USERNAME=$(echo $CREDENTIALS | grep -o '"username":"[^"]*"' | cut -d'"' -f4)
    PASSWORD=$(echo $CREDENTIALS | grep -o '"password":"[^"]*"' | cut -d'"' -f4)
    
    if [ ! -z "$USERNAME" ] && [ ! -z "$PASSWORD" ]; then
        echo -e "\n${GREEN}Tentando login no Docker com as credenciais obtidas...${NC}"
        echo "$PASSWORD" | docker login $REGISTRY -u "$USERNAME" --password-stdin
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}Login realizado com sucesso!${NC}"
        else
            echo -e "${RED}Falha no login do Docker com as credenciais obtidas${NC}"
        fi
    else
        echo -e "${RED}Não foi possível extrair usuário e senha das credenciais${NC}"
        echo -e "${YELLOW}Formato das credenciais:${NC}"
        echo $CREDENTIALS
    fi
else
    echo -e "${RED}Não foi possível obter credenciais do registry${NC}"
    
    # Tentar criar um repositório primeiro
    echo -e "\n${GREEN}Tentando criar um repositório...${NC}"
    mgc container-registry registries create --name $IMAGE_NAME --api-key="$MGC_API_KEY"
    
    # Tentar login direto com a API key
    echo -e "\n${GREEN}Tentando login direto com a API key...${NC}"
    echo "$MGC_API_KEY" | docker login $REGISTRY -u "oauth2" --password-stdin
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Login realizado com sucesso!${NC}"
    else
        echo -e "${RED}Falha no login do Docker${NC}"
        echo -e "${YELLOW}Recomendações finais:${NC}"
        echo "1. Entre em contato com o suporte do Magalu Cloud para confirmar:"
        echo "   - Se o serviço de container registry está ativado na sua conta"
        echo "   - Como obter credenciais válidas para o container registry"
        echo "   - O método correto de autenticação para o container registry"
    fi
fi

echo -e "\n${BLUE}=== Teste Concluído ====${NC}"
