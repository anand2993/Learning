# Azure DevOps Pipeline - Step-by-Step Setup Guide

This guide will walk you through setting up Azure DevOps to build and run your Node.js Docker application locally using the pipeline.

## 📋 Prerequisites

- ✅ Node.js installed (v25.2.1) - **DONE**
- ✅ npm installed (v11.6.2) - **DONE**
- ⏳ Docker Desktop installed - **IN PROGRESS**
- 🔲 Azure DevOps account
- 🔲 Git repository (GitHub, Azure Repos, Bitbucket, etc.)

---

## 🚀 Part 1: Prepare Your Local Repository

### Step 1: Initialize Git Repository

```bash
cd /Users/anandprakashmishra/Desktop/Danger/Learning

# Initialize git repository
git init

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit: Node.js Docker app with Azure DevOps pipeline"
```

### Step 2: Push to Remote Repository

**Option A: GitHub**

```bash
# Create a new repository on GitHub (via web interface)
# Then connect your local repo:

git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git
git branch -M main
git push -u origin main
```

**Option B: Azure Repos**

```bash
# Create a new repository in Azure DevOps (via web interface)
# Then connect your local repo:

git remote add origin https://YOUR_ORG@dev.azure.com/YOUR_ORG/YOUR_PROJECT/_git/YOUR_REPO
git push -u origin --all
```

---

## 🔧 Part 2: Set Up Azure DevOps Pipeline

### Step 1: Create Azure DevOps Account

1. Go to https://dev.azure.com/
2. Sign in with your Microsoft account (or create one)
3. Create a new organization (if you don't have one)

### Step 2: Create a New Project

1. Click **"+ New Project"**
2. Enter project details:
   - **Project name**: `nodejs-docker-app`
   - **Visibility**: Private or Public
   - **Version control**: Git
3. Click **"Create"**

### Step 3: Create a New Pipeline

1. In your project, go to **Pipelines** → **Pipelines**
2. Click **"Create Pipeline"** or **"New Pipeline"**
3. Select your repository source:
   - **GitHub** (if using GitHub)
   - **Azure Repos Git** (if using Azure Repos)
   - **Bitbucket Cloud**
   - **Other Git**

### Step 4: Configure the Pipeline

1. **Select your repository** from the list
2. When asked "Configure your pipeline", select:
   - **"Existing Azure Pipelines YAML file"**
3. Select the branch: `main` (or `master`)
4. Path: `/azure-pipelines.yml`
5. Click **"Continue"**

### Step 5: Review and Run

1. Review the pipeline YAML configuration
2. Click **"Run"** to start the pipeline
3. The pipeline will execute with three stages:
   - **Build**: Install dependencies and run tests
   - **Docker**: Build Docker image
   - **Deploy**: Run container locally

---

## 🏃 Part 3: Running Pipeline Locally with Azure DevOps Agent

To run the Azure DevOps pipeline on your **local machine** (not on Azure-hosted agents), you need to set up a **self-hosted agent**.

### Step 1: Install Azure Pipelines Agent

#### On macOS:

```bash
# Create a directory for the agent
mkdir -p ~/azagent && cd ~/azagent

# Download the agent
curl -O https://vstsagentpackage.azureedge.net/agent/3.248.0/vsts-agent-osx-arm64-3.248.0.tar.gz

# Extract the agent
tar zxvf vsts-agent-osx-arm64-3.248.0.tar.gz
```

### Step 2: Configure the Agent

```bash
cd ~/azagent

# Run the configuration script
./config.sh
```

You'll be prompted for:

1. **Server URL**: `https://dev.azure.com/YOUR_ORGANIZATION`
2. **Authentication type**: Press Enter for PAT (Personal Access Token)
3. **Personal Access Token**: 
   - Go to Azure DevOps → User Settings → Personal Access Tokens
   - Click "New Token"
   - Give it **"Agent Pools (Read & Manage)"** permission
   - Copy the token and paste it here
4. **Agent pool**: Press Enter for `Default`
5. **Agent name**: Press Enter (or give it a custom name like `my-mac`)
6. **Work folder**: Press Enter for default `_work`
7. **Run as service**: `N` (No, for local testing)

### Step 3: Run the Agent

```bash
cd ~/azagent

# Run the agent interactively
./run.sh
```

The agent will now listen for jobs from Azure DevOps.

### Step 4: Configure Pipeline to Use Your Local Agent

Update your `azure-pipelines.yml` to use the self-hosted agent:

```yaml
pool:
  name: 'Default'  # Use the pool where your agent is registered
  demands:
    - agent.name -equals my-mac  # Optional: specify your agent name
```

---

## 🎯 Part 4: Running the Pipeline

### Option 1: Trigger via Git Push

```bash
# Make any change to your code
echo "# Test change" >> README.md

# Commit and push
git add .
git commit -m "Trigger pipeline"
git push
```

The pipeline will automatically trigger on push to `main`, `master`, or `develop` branches.

### Option 2: Manual Trigger

1. Go to **Pipelines** → **Pipelines**
2. Select your pipeline
3. Click **"Run pipeline"**
4. Select the branch
5. Click **"Run"**

### Option 3: Run Locally Without Azure DevOps

You can also run the pipeline steps manually on your local machine:

```bash
cd /Users/anandprakashmishra/Desktop/Danger/Learning

# Step 1: Install dependencies
npm install

# Step 2: Run tests
npm test

# Step 3: Build Docker image
docker build -t nodejs-docker-app:latest .

# Step 4: Stop existing container (if any)
docker stop nodejs-app 2>/dev/null || true
docker rm nodejs-app 2>/dev/null || true

# Step 5: Run the container
docker run -d \
  --name nodejs-app \
  -p 3000:3000 \
  -e NODE_ENV=production \
  nodejs-docker-app:latest

# Step 6: Check health
sleep 5
curl http://localhost:3000/health

# Step 7: View logs
docker logs nodejs-app

# Step 8: Test the application
curl http://localhost:3000
curl http://localhost:3000/api/users
```

---

## 📊 Part 5: Monitor Pipeline Execution

### View Pipeline Logs

1. Go to **Pipelines** → **Pipelines**
2. Click on your pipeline run
3. Click on each stage/job to view logs:
   - **Build** stage logs
   - **Docker** stage logs
   - **Deploy** stage logs

### Check Application Status

Once the pipeline completes:

```bash
# Check if container is running
docker ps | grep nodejs-app

# View container logs
docker logs nodejs-app

# Test the application
curl http://localhost:3000/health
```

### Access the Application

Open your browser and go to:
- **Main endpoint**: http://localhost:3000
- **Health check**: http://localhost:3000/health
- **API info**: http://localhost:3000/api/info
- **Users API**: http://localhost:3000/api/users

---

## 🔄 Part 6: Pipeline Workflow Explained

### Stage 1: Build Application

```yaml
- stage: Build
  jobs:
    - job: BuildJob
      steps:
        - Install Node.js 18.x
        - Run: npm install
        - Run: npm test
```

**What happens:**
- Installs Node.js dependencies
- Runs tests (currently a placeholder)
- Validates the application builds successfully

### Stage 2: Build Docker Image

```yaml
- stage: Docker
  jobs:
    - job: DockerJob
      steps:
        - Build Docker image
        - Tag with build ID and 'latest'
        - (Optional) Push to registry
```

**What happens:**
- Builds Docker image using the Dockerfile
- Tags image with unique build ID
- Optionally pushes to container registry

### Stage 3: Deploy Locally

```yaml
- stage: Deploy
  jobs:
    - job: DeployJob
      steps:
        - Stop existing container
        - Run new container
        - Health check
```

**What happens:**
- Stops any existing container
- Starts new container from the built image
- Verifies the application is healthy

---

## 🛠️ Troubleshooting

### Issue: Pipeline fails at Docker stage

**Solution**: Ensure Docker Desktop is running on your local machine

```bash
# Check Docker status
docker --version
docker ps

# Start Docker Desktop if not running
open -a Docker
```

### Issue: Agent not picking up jobs

**Solution**: 
1. Check agent status: `cd ~/azagent && ./run.sh`
2. Verify agent is online in Azure DevOps: **Project Settings** → **Agent pools** → **Default**
3. Check agent capabilities match pipeline requirements

### Issue: Port 3000 already in use

**Solution**: Stop the existing process or use a different port

```bash
# Find process using port 3000
lsof -i :3000

# Kill the process
kill -9 <PID>

# Or use a different port in docker run
docker run -d -p 3001:3000 --name nodejs-app nodejs-docker-app:latest
```

### Issue: Permission denied when running Docker

**Solution**: Ensure your user is in the docker group and Docker Desktop is running

```bash
# Check Docker Desktop is running
docker ps

# If not, start Docker Desktop
open -a Docker
```

---

## 📝 Quick Reference Commands

### Pipeline Management

```bash
# View agent status
cd ~/azagent && ./run.sh

# Stop agent
# Press Ctrl+C in the terminal running the agent
```

### Docker Management

```bash
# View running containers
docker ps

# View all containers
docker ps -a

# View logs
docker logs nodejs-app

# Stop container
docker stop nodejs-app

# Remove container
docker rm nodejs-app

# View images
docker images

# Remove image
docker rmi nodejs-docker-app:latest
```

### Application Testing

```bash
# Health check
curl http://localhost:3000/health

# Main endpoint
curl http://localhost:3000

# API endpoints
curl http://localhost:3000/api/info
curl http://localhost:3000/api/users
```

---

## 🎉 Summary

You now have:

✅ **Local development environment** with Node.js and Docker  
✅ **Azure DevOps pipeline** configured  
✅ **Self-hosted agent** (optional) for running pipelines locally  
✅ **Automated CI/CD** workflow  
✅ **Docker containerization** with health checks  

### Next Steps:

1. ✅ Wait for Docker Desktop installation to complete
2. 🔲 Initialize Git repository
3. 🔲 Push code to remote repository (GitHub/Azure Repos)
4. 🔲 Create Azure DevOps project and pipeline
5. 🔲 (Optional) Set up self-hosted agent
6. 🔲 Run the pipeline and deploy your application!

---

**Need help?** Check the troubleshooting section or refer to the [Azure DevOps documentation](https://docs.microsoft.com/en-us/azure/devops/pipelines/).
