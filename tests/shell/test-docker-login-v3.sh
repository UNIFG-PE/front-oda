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
REGISTRY="api.magalu.cloud"
REGION="br-se1"
IMAGE_NAME="dev-oda-fsfg"

echo -e "${BLUE}=== Tentando login no Docker com base no formato da API ====${NC}"

# Tentar login com o formato correto da URL
echo -e "\n${GREEN}Tentando login com o formato correto da URL...${NC}"
echo "$MGC_API_KEY" | docker login $REGISTRY/$REGION -u oauth2 --password-stdin

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Login realizado com sucesso!${NC}"
    
    # Verificar se conseguimos acessar o repositório
    echo -e "\n${GREEN}Verificando acesso ao repositório...${NC}"
    docker pull $REGISTRY/$REGION/$IMAGE_NAME:latest 2>/dev/null || echo -e "${YELLOW}Repositório existe mas não tem a tag 'latest' ou não é acessível${NC}"
else
    echo -e "${RED}Falha no login do Docker${NC}"
fi

# Tentar obter informações sobre o container registry via API
echo -e "\n${GREEN}Tentando obter informações sobre o container registry via API...${NC}"
curl -s -X GET "https://$REGISTRY/$REGION/container-registry/v1/registries" \
  -H "x-api-key: $MGC_API_KEY" \
  -H "Accept: application/json" | jq . 2>/dev/null || echo "Resposta não é JSON válido"

# Tentar criar o repositório via API
echo -e "\n${GREEN}Tentando criar o repositório via API...${NC}"
curl -s -X POST "https://$REGISTRY/$REGION/container-registry/v1/registries" \
  -H "x-api-key: $MGC_API_KEY" \
  -H "Accept: application/json" \
  -H "Content-Type: application/json" \
  -d "{\"name\":\"$IMAGE_NAME\"}" | jq . 2>/dev/null || echo "Resposta não é JSON válido"

echo -e "\n${BLUE}=== Teste Concluído ====${NC}"
echo -e "${YELLOW}Se o login falhou, tente:${NC}"
echo "1. Verificar se o serviço de container registry está ativado na sua conta do Magalu Cloud"
echo "2. Verificar se sua API key tem permissões para acessar o container registry"
echo "3. Entrar em contato com o suporte do Magalu Cloud para obter o endpoint correto para o container registry"
