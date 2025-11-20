#!/bin/bash

# Script to run the Azure DevOps pipeline steps locally
# This simulates what the pipeline does without needing Azure DevOps

set -e  # Exit on error

echo "🚀 Running Azure DevOps Pipeline Locally"
echo "========================================"
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Stage 1: Build
echo -e "${BLUE}📦 Stage 1: Build Application${NC}"
echo "-----------------------------------"

echo "Installing Node.js dependencies..."
npm install
echo -e "${GREEN}✓ Dependencies installed${NC}"
echo ""

echo "Running tests..."
npm test
echo -e "${GREEN}✓ Tests passed${NC}"
echo ""

# Stage 2: Docker
echo -e "${BLUE}🐳 Stage 2: Build Docker Image${NC}"
echo "-----------------------------------"

echo "Building Docker image..."
docker build -t nodejs-docker-app:latest .
echo -e "${GREEN}✓ Docker image built${NC}"
echo ""

echo "Listing Docker images..."
docker images | grep nodejs-docker-app
echo ""

# Stage 3: Deploy
echo -e "${BLUE}🚀 Stage 3: Deploy Locally${NC}"
echo "-----------------------------------"

echo "Stopping existing container (if any)..."
docker stop nodejs-app 2>/dev/null || echo "No existing container to stop"
docker rm nodejs-app 2>/dev/null || echo "No existing container to remove"
echo ""

echo "Starting new container..."
docker run -d \
  --name nodejs-app \
  -p 3000:3000 \
  -e NODE_ENV=production \
  nodejs-docker-app:latest
echo -e "${GREEN}✓ Container started${NC}"
echo ""

echo "Waiting for application to start..."
sleep 5
echo ""

echo "Running health check..."
if curl -f http://localhost:3000/health > /dev/null 2>&1; then
  echo -e "${GREEN}✓ Health check passed${NC}"
else
  echo -e "${RED}✗ Health check failed${NC}"
  exit 1
fi
echo ""

# Summary
echo -e "${GREEN}🎉 Deployment Summary${NC}"
echo "========================================"
docker ps | grep nodejs-app
echo ""
echo -e "${GREEN}✓ Application is running successfully!${NC}"
echo ""
echo "Access your application at:"
echo "  - Main: http://localhost:3000"
echo "  - Health: http://localhost:3000/health"
echo "  - API Info: http://localhost:3000/api/info"
echo "  - Users: http://localhost:3000/api/users"
echo ""
echo "View logs with: docker logs nodejs-app"
echo "Stop container with: docker stop nodejs-app"
