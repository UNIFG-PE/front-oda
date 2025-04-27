#!/bin/bash
echo "1aec85e6-67d1-491c-9798-56a34c1d24f2" | docker login api.magalu.cloud --username "1aec85e6-67d1-491c-9798-56a34c1d24f2" --password-stdin
docker pull api.magalu.cloud/react-app:stable
docker stop react-app-stable || true
docker rm react-app-stable || true
docker run -d --name react-app-stable --restart unless-stopped -p 3001:80 api.magalu.cloud/react-app:stable
