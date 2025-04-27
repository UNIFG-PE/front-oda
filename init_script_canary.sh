#!/bin/bash
REPO_LOWER=$(echo ${GITHUB_REPOSITORY} | tr '[:upper:]' '[:lower:]')
echo "${TF_VAR_api_key}" | docker login ${REGISTRY} --username "${TF_VAR_api_key}" --password-stdin
docker pull ${REGISTRY}/${MAGALU_REGION}/${REPO_LOWER}:canary
docker stop react-app-canary || true
docker rm react-app-canary || true
docker run -d --name react-app-canary --restart unless-stopped -p 3001:80 ${REGISTRY}/${MAGALU_REGION}/${REPO_LOWER}:canary
