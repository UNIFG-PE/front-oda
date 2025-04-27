#!/bin/bash
echo "${TF_VAR_api_key}" | docker login ${REGISTRY} --username "${TF_VAR_api_key}" --password-stdin
docker pull ${REGISTRY}/${GITHUB_REPOSITORY}:canary
docker stop react-app-canary || true
docker rm react-app-canary || true
docker run -d --name react-app-canary --restart unless-stopped -p 3001:80 ${REGISTRY}/${GITHUB_REPOSITORY}:canary
