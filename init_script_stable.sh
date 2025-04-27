#!/bin/bash
echo "${TF_VAR_api_key}" | docker login ${REGISTRY} --username "${TF_VAR_api_key}" --password-stdin
docker pull ${REGISTRY}/${MAGALU_REGION}/dev-oda-fsfg:stable
docker stop dev-oda-fsfg-stable || true
docker rm dev-oda-fsfg-stable || true
docker run -d --name dev-oda-fsfg-stable --restart unless-stopped -p 3001:80 ${REGISTRY}/${MAGALU_REGION}/dev-oda-fsfg:stable
