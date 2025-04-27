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
REGION="br-se1"
IMAGE_NAME="dev-oda-fsfg"

echo -e "${BLUE}=== Testando MGC CLI com API key direta ====${NC}"

# Verificar se o MGC CLI está instalado
if ! command -v mgc &> /dev/null; then
    echo -e "${RED}Erro: MGC CLI não está instalado${NC}"
    echo "Instale seguindo as instruções em: https://docs.magalu.cloud/docs/cli/overview"
    exit 1
fi

# Configurar a região
echo -e "\n${GREEN}Configurando região...${NC}"
mgc config set region $REGION

# Listar VMs para verificar se a API key funciona
echo -e "\n${GREEN}Listando VMs para verificar se a API key funciona...${NC}"
mgc vm instances list --api-key="$MGC_API_KEY"

# Tentar listar repositórios do container registry
echo -e "\n${GREEN}Tentando listar repositórios do container registry...${NC}"
mgc container-registry registries list --api-key="$MGC_API_KEY"

# Tentar criar um repositório
echo -e "\n${GREEN}Tentando criar um repositório...${NC}"
mgc container-registry registries create --name $IMAGE_NAME --api-key="$MGC_API_KEY"

# Tentar obter credenciais do registry
echo -e "\n${GREEN}Tentando obter credenciais do registry...${NC}"
mgc container-registry credentials get --api-key="$MGC_API_KEY"

echo -e "\n${BLUE}=== Teste Concluído ====${NC}"
echo -e "${YELLOW}Se os comandos acima falharem, entre em contato com o suporte do Magalu Cloud para confirmar:${NC}"
echo "1. Se o serviço de container registry está ativado na sua conta"
echo "2. Quais permissões são necessárias para a API key"
echo "3. Como acessar o container registry usando o MGC CLI"
