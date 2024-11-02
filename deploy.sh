#!/bin/bash

# Remove the existing stack
docker stack rm llm-gateway
echo "[+] Removed existing stack: llm-gateway"

# Wait for the stack to be fully removed
echo "[*] Waiting for services and containers to be fully stopped..."
sleep 10  # Adjust the sleep time as needed

# Deploy the new stack
docker stack deploy --compose-file docker-stack.yml llm-gateway
echo "[+] Finished deploying the stack: llm-gateway"
