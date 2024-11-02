#!/bin/bash

docker stack deploy --compose-file deploy-stack.yml llm-gateway
echo "[+] Finished deploying the stack"
