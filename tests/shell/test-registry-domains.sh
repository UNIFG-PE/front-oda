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

echo -e "${BLUE}=== Testando diferentes domínios para o registry ====${NC}"

# Lista de possíveis domínios para testar
domains=(
    "api.magalu.cloud"
    "registry.magalu.cloud"
    "container-registry.magalu.cloud"
    "cr.magalu.cloud"
    "docker.magalu.cloud"
    "registry.br-se1.magalu.cloud"
    "container-registry.br-se1.magalu.cloud"
)

# Testar cada domínio
for domain in "${domains[@]}"; do
    echo -e "\n${GREEN}Testando domínio: $domain${NC}"
    
    # Testar conexão básica
    status=$(curl -s -o /dev/null -w "%{http_code}" -X GET "https://$domain" -H "x-api-key: $MGC_API_KEY")
    echo "Status HTTP: $status"
    
    # Tentar login no Docker
    echo -e "${YELLOW}Tentando login no Docker com $domain...${NC}"
    echo "$MGC_API_KEY" | docker login $domain -u oauth2 --password-stdin
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Login bem-sucedido com $domain!${NC}"
        echo -e "${BLUE}=== SUCESSO! Domínio correto encontrado: $domain ====${NC}"
        break
    else
        echo -e "${RED}Falha no login com $domain${NC}"
    fi
done

echo -e "\n${BLUE}=== Teste Concluído ====${NC}"
echo -e "${YELLOW}Recomendações:${NC}"
echo "1. Verifique se o serviço de container registry está ativado na sua conta do Magalu Cloud"
echo "2. Entre em contato com o suporte do Magalu Cloud para confirmar o endpoint correto para o container registry"
echo "3. Verifique se sua API key tem permissões para acessar o container registry"
echo "4. Consulte a documentação oficial do Magalu Cloud para instruções específicas sobre como usar o container registry"
