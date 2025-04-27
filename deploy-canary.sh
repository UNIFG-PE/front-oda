#!/bin/bash

# Cores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== Iniciando Deploy Canary ====${NC}"

# Definir versão baseada no timestamp atual
export REACT_APP_VERSION="canary-$(date +%Y%m%d%H%M%S)"

echo -e "${GREEN}Construindo versão Canary: $REACT_APP_VERSION${NC}"

# Construir a imagem canary
docker-compose build app-canary

# Iniciar o container canary
docker-compose up -d app-canary

echo -e "${GREEN}Deploy Canary concluído com sucesso!${NC}"
echo -e "${YELLOW}Acesse a versão Canary em: http://localhost:3001${NC}"
echo -e "${YELLOW}Acesse a versão Estável em: http://localhost:80${NC}"

echo -e "${BLUE}=== Monitorando saúde da versão Canary ====${NC}"
echo -e "Pressione Ctrl+C para sair do monitoramento"

# Monitorar logs do container canary
docker-compose logs -f app-canary
