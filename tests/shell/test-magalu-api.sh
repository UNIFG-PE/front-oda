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

echo -e "${BLUE}=== Diagnóstico de Conexão com Magalu Cloud ====${NC}"

# Verificar se conseguimos acessar a API do Magalu Cloud
echo -e "\n${GREEN}Testando conexão com a API do Magalu Cloud...${NC}"
curl -s -o /dev/null -w "%{http_code}" -X GET "https://$REGISTRY" -H "x-api-key: $MGC_API_KEY"
if [ $? -eq 0 ]; then
    echo -e "${GREEN}Conexão básica com $REGISTRY bem-sucedida${NC}"
else
    echo -e "${RED}Falha ao conectar com $REGISTRY${NC}"
fi

# Testar diferentes endpoints da API
echo -e "\n${GREEN}Testando diferentes endpoints da API...${NC}"

endpoints=(
    "/"
    "/v2"
    "/v2/"
    "/$REGION"
    "/$REGION/v2"
    "/v2/$REGION"
    "/v2/$REGION/repositories"
)

for endpoint in "${endpoints[@]}"; do
    echo -e "${YELLOW}Testando https://$REGISTRY$endpoint${NC}"
    status=$(curl -s -o /dev/null -w "%{http_code}" -X GET "https://$REGISTRY$endpoint" -H "x-api-key: $MGC_API_KEY")
    echo "Status: $status"
done

# Tentar obter informações sobre o repositório
echo -e "\n${GREEN}Tentando obter informações sobre repositórios...${NC}"
echo -e "${YELLOW}GET https://$REGISTRY/v2/$REGION/repositories${NC}"
curl -s -X GET "https://$REGISTRY/v2/$REGION/repositories" -H "x-api-key: $MGC_API_KEY" | jq . 2>/dev/null || echo "Resposta não é JSON válido"

# Verificar configuração do Docker
echo -e "\n${GREEN}Verificando configuração do Docker...${NC}"
docker info | grep -E "Registry|Insecure"

# Tentar login com --password-stdin
echo -e "\n${GREEN}Tentando login com --password-stdin...${NC}"
echo "$MGC_API_KEY" | docker login $REGISTRY -u oauth2 --password-stdin

# Verificar se o MGC CLI está instalado e tentar usá-lo
if command -v mgc &> /dev/null; then
    echo -e "\n${GREEN}MGC CLI está instalado. Tentando obter informações...${NC}"
    mgc config set region $REGION
    echo "$MGC_API_KEY" > ~/.mgc/api-key
    mgc container-registry registries list 2>/dev/null || echo "Falha ao listar repositórios via MGC CLI"
else
    echo -e "\n${YELLOW}MGC CLI não está instalado${NC}"
fi

echo -e "\n${BLUE}=== Diagnóstico Concluído ====${NC}"
echo -e "${YELLOW}Recomendações:${NC}"
echo "1. Verifique a documentação oficial do Magalu Cloud para o formato correto de autenticação"
echo "2. Verifique se sua API key tem permissões para acessar o registry de contêineres"
echo "3. Entre em contato com o suporte do Magalu Cloud para obter assistência específica"
