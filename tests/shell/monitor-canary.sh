#!/bin/bash

CANARY_IP="201.54.11.145"
STABLE_IP="201.54.12.157"
THRESHOLD=95 # Porcentagem mínima de sucesso

check_health() {
    local ip=$1
    local success=0
    local total=100

    for i in $(seq 1 $total); do
        if curl -s -o /dev/null -w "%{http_code}" "http://$ip:3001" | grep -q "200"; then
            success=$((success + 1))
        fi
        sleep 0.1
    done

    echo $((success * 100 / total))
}

echo "Iniciando monitoramento do Canary..."
canary_health=$(check_health $CANARY_IP)

if [ $canary_health -ge $THRESHOLD ]; then
    echo "Canary está saudável ($canary_health% de sucesso)"
    exit 0
else
    echo "Canary está com problemas ($canary_health% de sucesso)"
    exit 1
fi