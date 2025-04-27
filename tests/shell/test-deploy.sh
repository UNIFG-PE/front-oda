#!/bin/bash

# Cores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}Iniciando teste de deployment...${NC}"

# 1. Commit e push
git add .
git commit -m "test: testing canary deployment"
git push origin main

# 2. Monitorar o GitHub Actions
echo -e "${GREEN}Aguardando início do workflow...${NC}"
sleep 10

# 3. Verificar status do workflow (necessita gh cli)
gh run list --limit 1

# 4. Monitorar os endpoints
echo -e "${GREEN}Monitorando endpoints...${NC}"
echo "Canary endpoint (20% do tráfego):"
curl -I http://201.54.11.145:3001

echo -e "\nStable endpoint (80% do tráfego):"
curl -I http://201.54.12.157:3001

# 5. Verificar logs do Docker
echo -e "${GREEN}Logs do container canary:${NC}"
ssh -i canary.key ubuntu@201.54.11.145 "docker logs react-app-canary --tail 10"

echo -e "${GREEN}Logs do container stable:${NC}"
ssh -i stable.key ubuntu@201.54.12.157 "docker logs react-app-stable --tail 10"