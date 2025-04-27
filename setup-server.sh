#!/bin/bash

# Cores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Verificar se está rodando como root
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}Por favor, execute como root (sudo)${NC}"
  exit 1
fi

echo -e "${BLUE}=== Configurando servidor para deploy sem downtime ===${NC}"

# Instalar Docker se não estiver instalado
if ! command -v docker &> /dev/null; then
    echo -e "${GREEN}Instalando Docker...${NC}"
    apt-get update
    apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    apt-get update
    apt-get install -y docker-ce
    systemctl enable docker
    systemctl start docker
fi

# Instalar Nginx se não estiver instalado
if ! command -v nginx &> /dev/null; then
    echo -e "${GREEN}Instalando Nginx...${NC}"
    apt-get update
    apt-get install -y nginx
    systemctl enable nginx
    systemctl start nginx
fi

# Configurar Nginx como proxy reverso
echo -e "${GREEN}Configurando Nginx como proxy reverso...${NC}"
cat > /etc/nginx/conf.d/app.conf << EOF
server {
    listen 80;
    server_name _;
    
    location / {
        proxy_pass http://localhost:80;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}
EOF

# Recarregar Nginx
nginx -s reload

# Criar diretório para scripts de deploy
mkdir -p /opt/deploy-scripts

echo -e "${GREEN}Configuração concluída!${NC}"
echo -e "${YELLOW}Próximos passos:${NC}"
echo "1. Configure as secrets no GitHub:"
echo "   - MAGALU_API_KEY: Sua API key do Magalu Cloud"
echo "   - SSH_PRIVATE_KEY: Chave SSH privada para acessar o servidor"
echo "   - SERVER_USER: Usuário do servidor"
echo "   - SERVER_IP: IP do servidor"
echo "2. Faça um push para a branch main para iniciar o deploy"
