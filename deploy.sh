#!/bin/bash
set -e  # Exit on any error

# Parse command line arguments
BUILD_ENV=""
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --prod) BUILD_ENV="prod"; shift ;;
        --local) BUILD_ENV="local"; shift ;;
        *) echo "❌ Unknown parameter: $1"; exit 1 ;;
    esac
done

# Validate build environment
if [ -z "$BUILD_ENV" ]; then
    echo "❌ Error: Please specify --prod or --local"
    echo "Usage: $0 --prod|--local"
    exit 1
fi

echo "🚀 Deploying llm-gateway with BUILD_TAG=$BUILD_ENV"

export BUILD_TAG=$BUILD_ENV  # Export the variable so it's available to docker-stack.yml

# Pull all current images
echo "📥 Pulling current images..."
docker-compose -f docker-stack.yml pull

# (Optional) Clean up dangling images
echo "🧹 Cleaning up unused images..."
docker image prune -f

# Remove the existing stack if it exists
# if docker stack ls | grep -q "llm-gateway"; then
#     echo "🗑️  Removing existing stack..."
#     docker stack rm llm-gateway

#     # Wait for stack to be fully removed (more efficient than sleep)
#     while docker stack ls | grep -q "llm-gateway"; do
#         echo "⏳ Waiting for stack removal..."
#         sleep 2
#     done
# fi

# Deploy the new stack
echo "📦 Deploying new stack..."
docker stack deploy --compose-file docker-stack.yml \
    --with-registry-auth \
    llm-gateway

echo "✅ Deployment complete! Stack: llm-gateway (Build: $BUILD_ENV)"
