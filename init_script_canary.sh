#!/bin/bash
echo "${TF_VAR_api_key}" | docker login ${REGISTRY} --username "${TF_VAR_api_key}" --password-stdin
docker pull ${REGISTRY}/${MAGALU_REGION}/dev-oda-fsfg:canary
docker stop dev-oda-fsfg-canary || true
docker rm dev-oda-fsfg-canary || true
docker run -d --name dev-oda-fsfg-canary --restart unless-stopped -p 3001:80 ${REGISTRY}/${MAGALU_REGION}/dev-oda-fsfg:canary
