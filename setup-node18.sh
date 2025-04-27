#!/bin/bash

# Cores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== Configurando ambiente para Node.js 18 ====${NC}"

# Verificar se o Dockerfile atual já está usando Node.js 18
if grep -q "FROM node:18" Dockerfile; then
  echo -e "${GREEN}Dockerfile já está configurado para usar Node.js 18${NC}"
else
  # Substituir a versão do Node.js no Dockerfile
  sed -i.bak 's/FROM node:16-alpine/FROM node:18-alpine/g' Dockerfile
  rm -f Dockerfile.bak
  echo -e "${GREEN}Dockerfile atualizado para usar Node.js 18${NC}"
fi

echo -e "${YELLOW}Agora você pode executar:${NC}"
echo -e "  docker-compose build --no-cache"
echo -e "  docker-compose up app-dev"
