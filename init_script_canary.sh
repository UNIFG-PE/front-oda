#!/bin/bash
echo "1aec85e6-67d1-491c-9798-56a34c1d24f2" | docker login api.magalu.cloud --username "1aec85e6-67d1-491c-9798-56a34c1d24f2" --password-stdin
docker pull api.magalu.cloud/react-app:canary
docker stop react-app-canary || true
docker rm react-app-canary || true
docker run -d --name react-app-canary --restart unless-stopped -p 3001:80 api.magalu.cloud/react-app:canary
