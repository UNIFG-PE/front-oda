# Deploy Contínuo Sem Downtime

Este projeto está configurado para realizar deploy contínuo sem downtime no Magalu Cloud sempre que houver um push na branch `main`.

## Como funciona

1. Quando um push é feito na branch `main`, o GitHub Actions é acionado
2. O código é testado e uma nova imagem Docker é construída
3. A imagem é enviada para o registry do Magalu Cloud
4. Um script de deploy é executado no servidor para atualizar a aplicação sem downtime

## Configuração Inicial

### 1. Configurar o servidor

Execute o script `setup-server.sh` no servidor para instalar e configurar o Docker e o Nginx:

```bash
chmod +x setup-server.sh
sudo ./setup-server.sh
```

### 2. Configurar secrets no GitHub

Adicione as seguintes secrets no seu repositório GitHub:

- `MAGALU_API_KEY`: Sua API key do Magalu Cloud
- `SSH_PRIVATE_KEY`: Chave SSH privada para acessar o servidor
- `SERVER_USER`: Usuário do servidor
- `SERVER_IP`: IP do servidor

### 3. Gerar chave SSH (se necessário)

Se você não tiver uma chave SSH, gere uma:

```bash
ssh-keygen -t rsa -b 4096 -C "seu-email@exemplo.com"
```

Adicione a chave pública ao arquivo `~/.ssh/authorized_keys` no servidor:

```bash
cat ~/.ssh/id_rsa.pub | ssh usuario@ip-do-servidor "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
```

## Estratégia de Deploy Sem Downtime

O deploy sem downtime é realizado usando a seguinte estratégia:

1. Um novo container é iniciado com a nova versão da aplicação
2. O Nginx é configurado para redirecionar o tráfego para o novo container
3. O container antigo é removido
4. O novo container é renomeado para manter a consistência

## Solução de Problemas

### Verificar logs do container

```bash
docker logs app-container
```

### Verificar status do Nginx

```bash
systemctl status nginx
```

### Reiniciar o deploy manualmente

```bash
sudo /opt/deploy-scripts/deploy.sh
```
