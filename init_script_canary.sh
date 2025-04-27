#!/bin/bash
echo "${TF_VAR_api_key}" | docker login ${REGISTRY} --username "${TF_VAR_api_key}" --password-stdin
docker pull ${REGISTRY}/${MAGALU_REGION}/front-oda:canary
docker stop front-oda-canary || true
docker rm front-oda-canary || true
docker run -d --name front-oda-canary --restart unless-stopped -p 3001:80 ${REGISTRY}/${MAGALU_REGION}/front-oda:canary
