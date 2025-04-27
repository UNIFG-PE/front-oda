#!/bin/bash

# Cores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== Configurando ambiente para Node.js 16 ====${NC}"

# Copiar o Dockerfile para Node.js 16
cp Dockerfile.node16 Dockerfile

echo -e "${GREEN}Dockerfile configurado para usar Node.js 16 com PNPM 7.30.5${NC}"
echo -e "${YELLOW}Agora você pode executar:${NC}"
echo -e "  docker-compose build --no-cache"
echo -e "  docker-compose up app-dev"
