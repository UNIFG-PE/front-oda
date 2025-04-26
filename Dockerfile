# Use uma imagem do Node.js
FROM node:16-alpine

# Defina o diretório de trabalho no container
WORKDIR /app

# Copie os arquivos do package.json e package-lock.json
COPY package*.json ./

# Instale as dependências
RUN npm install

# Copie o restante do código da aplicação para o container
COPY . .

# Construa a aplicação para produção
RUN npm run build

# Use um servidor para servir os arquivos estáticos (como serve)
RUN npm install -g serve

# Exponha a porta que o servidor irá usar
EXPOSE 3000

# Comando para rodar o servidor
CMD ["serve", "-s", "build", "-l", "3000"]