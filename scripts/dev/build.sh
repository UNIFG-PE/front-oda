#!/bin/bash

# Construir a imagem de produção
docker-compose build app-prod

# Iniciar o container de produção
docker-compose up -d app-prod