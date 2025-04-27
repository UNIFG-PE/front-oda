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
API_ENDPOINT="api.magalu.cloud"
REGISTRY="container-registry.br-se1.magalu.cloud"
REGION="br-se1"
IMAGE_NAME="dev-oda-fsfg"

echo -e "${BLUE}=== Tentando criar repositório e fazer login ====${NC}"

# Tentar criar o repositório via API
echo -e "\n${GREEN}Tentando criar o repositório via API...${NC}"
curl -s -X POST "https://$API_ENDPOINT/$REGION/container-registry/v1/registries" \
  -H "x-api-key: $MGC_API_KEY" \
  -H "Accept: application/json" \
  -H "Content-Type: application/json" \
  -d "{\"name\":\"$IMAGE_NAME\"}"

echo -e "\n${GREEN}Listando repositórios disponíveis...${NC}"
curl -s -X GET "https://$API_ENDPOINT/$REGION/container-registry/v1/registries" \
  -H "x-api-key: $MGC_API_KEY" \
  -H "Accept: application/json"

# Tentar login no Docker com a API key como usuário e senha
echo -e "\n${GREEN}Tentando login no Docker...${NC}"
echo "$MGC_API_KEY" | docker login $REGISTRY -u "$MGC_API_KEY" --password-stdin

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Login realizado com sucesso!${NC}"
else
    echo -e "${RED}Falha no login do Docker${NC}"
    echo -e "${YELLOW}Recomendações finais:${NC}"
    echo "1. Entre em contato com o suporte do Magalu Cloud para confirmar:"
    echo "   - Se o serviço de container registry está ativado na sua conta"
    echo "   - Quais permissões são necessárias para a API key"
    echo "   - O método correto de autenticação para o container registry"
    echo "2. Verifique no painel de controle do Magalu Cloud se há alguma seção específica para o container registry"
fi

echo -e "\n${BLUE}=== Teste Concluído ====${NC}"
