#!/bin/bash
echo "${TF_VAR_api_key}" | docker login ${REGISTRY} --username "${TF_VAR_api_key}" --password-stdin
docker pull ${REGISTRY}/${MAGALU_REGION}/front-oda:stable
docker stop front-oda-stable || true
docker rm front-oda-stable || true
docker run -d --name front-oda-stable --restart unless-stopped -p 3001:80 ${REGISTRY}/${MAGALU_REGION}/front-oda:stable
