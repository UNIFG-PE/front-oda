# Configuração Docker com PNPM

Este projeto utiliza Docker com PNPM para um ambiente de desenvolvimento e produção mais rápido e eficiente.

## Compatibilidade com Node.js

O PNPM mais recente requer Node.js 18+. Fornecemos duas opções:

1. **Node.js 18 (Recomendado)**: Usa a versão mais recente do PNPM
   ```bash
   ./scripts/setup/setup-node18.sh
   ```

2. **Node.js 16**: Usa PNPM 7.30.5 (compatível com Node.js 16)
   ```bash
   ./scripts/setup/setup-node16.sh
   ```

Escolha a opção que melhor se adapta ao seu ambiente.

## Benefícios desta Configuração

1. **PNPM é muito mais rápido que NPM**: Instalação de dependências até 2x mais rápida
2. **Compartilhamento de cache**: O volume `pnpm_cache` mantém as dependências entre builds
3. **Desenvolvimento rápido**: O volume para `node_modules` evita reinstalações constantes
4. **Multi-stage build**: Reduz o tamanho final da imagem de produção
5. **Deploy sem downtime**: Estratégia canary para atualizações seguras

## Arquivos de Configuração

- **Dockerfile**: Configurado para usar PNPM com multi-stage build
- **docker-compose.yml**: Define serviços para desenvolvimento, produção e canary
- **.npmrc**: Configurações do PNPM para melhor desempenho
- **Scripts de automação**: Para facilitar o desenvolvimento e deploy

## Como Usar

### Desenvolvimento

Para iniciar o ambiente de desenvolvimento:

```bash
# Usando docker-compose diretamente
docker-compose up app-dev

# Ou usando o script de conveniência
./dev.sh
```

A aplicação estará disponível em: http://localhost:3000

### Produção

Para construir e iniciar a versão de produção:

```bash
# Usando docker-compose diretamente
docker-compose build app-prod
docker-compose up -d app-prod

# Ou usando o script de conveniência
./build.sh
```

A aplicação estará disponível em: http://localhost:80

### Deploy Canary (Sem Downtime)

Para fazer um deploy canary (nova versão para testes):

```bash
./deploy-canary.sh
```

A versão canary estará disponível em: http://localhost:3001

### Promover Canary para Estável

Após testar a versão canary, você pode promovê-la para estável:

```bash
./promote-to-stable.sh
```

## Reconstruir Dependências

Se você precisar reconstruir as dependências:

```bash
# Remover o volume de node_modules
docker-compose down -v

# Reconstruir apenas as dependências
docker-compose build --no-cache app-dev

# Reiniciar o ambiente de desenvolvimento
docker-compose up app-dev
```

## Solução de Problemas

### Lentidão no npm install

Este problema foi resolvido usando PNPM, que é significativamente mais rápido que NPM.

### Problemas de Acesso à Porta

Se você não conseguir acessar a aplicação nas portas configuradas:

1. Verifique se as portas estão liberadas no firewall
2. Verifique se não há outros serviços usando as mesmas portas
3. Tente usar portas diferentes no docker-compose.yml

### Problemas com Volumes

Se você encontrar problemas com os volumes:

```bash
# Limpar volumes não utilizados
docker volume prune

# Forçar recriação dos volumes
docker-compose down -v
docker-compose up app-dev
```
