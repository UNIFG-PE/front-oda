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
REGISTRY="api.magalu.cloud"
REGION="br-se1"
IMAGE_NAME="dev-oda-fsfg"

echo -e "${GREEN}Configurando ambiente...${NC}"

# Método direto de login (como usado no GitHub Actions)
echo -e "${GREEN}Tentando login no Docker...${NC}"
docker login $REGISTRY -u oauth2 -p "$MGC_API_KEY"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Login realizado com sucesso!${NC}"
    
    # Tenta criar o repositório via API REST (como no GitHub Actions)
    echo -e "${GREEN}Verificando/criando repositório no registry...${NC}"
    curl -X POST \
        -H "x-api-key: $MGC_API_KEY" \
        -H "Accept: application/json" \
        -H "Content-Type: application/json" \
        -d "{\"name\":\"$IMAGE_NAME\"}" \
        "https://$REGISTRY/v2/$REGION/repositories" \
        --silent
    
    echo -e "\n${GREEN}Listando repositórios disponíveis...${NC}"
    curl -X GET \
        -H "x-api-key: $MGC_API_KEY" \
        -H "Accept: application/json" \
        "https://$REGISTRY/v2/$REGION/repositories" \
        --silent | grep -o "\"name\":\"[^\"]*\"" | cut -d'"' -f4
else
    echo -e "${RED}Falha no login do Docker${NC}"
    echo -e "${YELLOW}Dicas de solução:${NC}"
    echo -e "1. Verifique se a API key está correta"
    echo -e "2. Verifique se o Docker está configurado corretamente"
    echo -e "3. Consulte a documentação do Magalu Cloud para o formato correto de autenticação"
    exit 1
fi

# Tenta verificar se consegue acessar o repositório
echo -e "\n${GREEN}Verificando acesso ao repositório...${NC}"
docker pull $REGISTRY/$REGION/$IMAGE_NAME:latest 2>/dev/null || echo -e "${YELLOW}Repositório existe mas não tem a tag 'latest' ou não é acessível${NC}"
