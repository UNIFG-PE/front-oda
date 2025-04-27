#!/bin/bash

# Cores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}=== Promovendo versão Canary para Estável ====${NC}"

# Verificar se a versão canary está rodando
if ! docker-compose ps | grep -q app-canary; then
  echo -e "${RED}Erro: Versão Canary não está rodando!${NC}"
  echo -e "${YELLOW}Execute primeiro: ./deploy-canary.sh${NC}"
  exit 1
fi

echo -e "${YELLOW}Atenção: Esta ação vai substituir a versão estável pela versão canary atual.${NC}"
read -p "Deseja continuar? (s/n): " confirm

if [ "$confirm" != "s" ]; then
  echo -e "${YELLOW}Operação cancelada pelo usuário.${NC}"
  exit 0
fi

# Obter a versão atual do canary
CANARY_VERSION=$(docker-compose exec app-canary env | grep REACT_APP_VERSION | cut -d= -f2)

echo -e "${GREEN}Promovendo versão $CANARY_VERSION para estável...${NC}"

# Definir a versão para o build estável
export REACT_APP_VERSION="$CANARY_VERSION-stable"

# Construir a imagem estável
docker-compose build app-prod

# Parar o container estável atual (se existir)
docker-compose stop app-prod

# Iniciar o novo container estável
docker-compose up -d app-prod

echo -e "${GREEN}Promoção concluída com sucesso!${NC}"
echo -e "${YELLOW}A versão Canary foi promovida para Estável.${NC}"
echo -e "${YELLOW}Acesse a versão Estável em: http://localhost:80${NC}"
