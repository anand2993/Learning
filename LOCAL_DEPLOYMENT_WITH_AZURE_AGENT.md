# Deploy to Local Machine Using Azure DevOps Self-Hosted Agent

## ✅ Yes! You Can Use Azure Agent to Deploy Locally

This guide shows you how to set up an Azure DevOps **self-hosted agent** on your Mac that will:
- Listen for pipeline jobs from Azure DevOps
- Execute the pipeline on **your local machine**
- Build and deploy the Docker container **locally**

---

## 🎯 How It Works

```
┌─────────────────┐         ┌──────────────────┐         ┌─────────────────┐
│  Azure DevOps   │────────▶│  Self-Hosted     │────────▶│  Your Local     │
│  (Cloud)        │  Sends  │  Agent           │  Runs   │  Machine        │
│                 │  Jobs   │  (Your Mac)      │  Docker │  (localhost)    │
└─────────────────┘         └──────────────────┘         └─────────────────┘
```

1. You push code to Git (GitHub/Azure Repos)
2. Azure DevOps pipeline is triggered
3. Pipeline job is sent to **your self-hosted agent**
4. Agent runs on **your Mac** and executes:
   - npm install
   - Docker build
   - Docker run (on localhost:3000)
5. Application runs on **your local machine**

---

## 📋 Prerequisites

- ✅ Node.js installed
- ✅ Docker Desktop installed and running
- 🔲 Azure DevOps account (free)
- 🔲 Git repository (GitHub or Azure Repos)

---

## 🚀 Step-by-Step Setup

### Step 1: Create Azure DevOps Account & Project (5 minutes)

1. Go to https://dev.azure.com/
2. Sign in with Microsoft account
3. Click **"+ New Project"**
4. Name it: `nodejs-docker-app`
5. Click **"Create"**

### Step 2: Push Your Code to Repository (5 minutes)

#### Option A: Using GitHub

```bash
cd /Users/anandprakashmishra/Desktop/Danger/Learning

# Initialize git
git init
git add .
git commit -m "Initial commit"

# Create repo on GitHub, then:
git remote add origin https://github.com/YOUR_USERNAME/nodejs-docker-app.git
git branch -M main
git push -u origin main
```

#### Option B: Using Azure Repos

```bash
cd /Users/anandprakashmishra/Desktop/Danger/Learning

# Initialize git
git init
git add .
git commit -m "Initial commit"

# In Azure DevOps, go to Repos → Files → "Initialize" or "Import"
# Then push:
git remote add origin https://YOUR_ORG@dev.azure.com/YOUR_ORG/nodejs-docker-app/_git/nodejs-docker-app
git push -u origin --all
```

### Step 3: Install Self-Hosted Agent on Your Mac (10 minutes)

#### 3.1 Download the Agent

```bash
# Create agent directory
mkdir -p ~/azagent && cd ~/azagent

# Download agent for macOS (ARM64 for M1/M2/M3 Macs)
curl -O https://vstsagentpackage.azureedge.net/agent/3.248.0/vsts-agent-osx-arm64-3.248.0.tar.gz

# Extract
tar zxvf vsts-agent-osx-arm64-3.248.0.tar.gz
```

**Note:** If you have an Intel Mac, use:
```bash
curl -O https://vstsagentpackage.azureedge.net/agent/3.248.0/vsts-agent-osx-x64-3.248.0.tar.gz
```

#### 3.2 Create Personal Access Token (PAT)

1. In Azure DevOps, click your **profile icon** (top right)
2. Go to **Personal access tokens**
3. Click **"+ New Token"**
4. Configure:
   - **Name**: `Local Agent Token`
   - **Organization**: Select your organization
   - **Expiration**: 90 days (or custom)
   - **Scopes**: Select **"Agent Pools (Read & manage)"**
5. Click **"Create"**
6. **Copy the token** (you won't see it again!)

#### 3.3 Configure the Agent

```bash
cd ~/azagent

# Run configuration
./config.sh
```

**Answer the prompts:**

```
Enter server URL > https://dev.azure.com/YOUR_ORGANIZATION
Enter authentication type (press enter for PAT) > [Press Enter]
Enter personal access token > [Paste your PAT token]
Enter agent pool (press enter for default) > [Press Enter]
Enter agent name (press enter for your-mac-name) > my-local-agent
Enter work folder (press enter for _work) > [Press Enter]
Enter run agent as service? (Y/N) (press enter for N) > N
```

✅ Configuration complete!

#### 3.4 Start the Agent

```bash
cd ~/azagent

# Run the agent
./run.sh
```

You should see:
```
Listening for Jobs
```

**Keep this terminal window open!** The agent needs to run to receive jobs.

### Step 4: Create Pipeline in Azure DevOps (5 minutes)

1. In Azure DevOps, go to **Pipelines** → **Pipelines**
2. Click **"New Pipeline"** or **"Create Pipeline"**
3. **Where is your code?**
   - Select **GitHub** or **Azure Repos Git**
4. **Select your repository**
5. **Configure your pipeline:**
   - Select **"Existing Azure Pipelines YAML file"**
6. **Select the YAML file:**
   - Branch: `main`
   - Path: `/azure-pipelines.yml`
7. Click **"Continue"**

### Step 5: Update Pipeline to Use Self-Hosted Agent

The pipeline needs to use your local agent instead of Microsoft-hosted agents.

**Edit your `azure-pipelines.yml`:**

Change this:
```yaml
pool:
  vmImage: 'ubuntu-latest'
```

To this:
```yaml
pool:
  name: 'Default'  # The pool where your agent is registered
```

**Save and commit the change:**

```bash
cd /Users/anandprakashmishra/Desktop/Danger/Learning

# The file will be updated automatically, then:
git add azure-pipelines.yml
git commit -m "Use self-hosted agent"
git push
```

### Step 6: Run the Pipeline! 🚀

The pipeline will automatically trigger on push. You'll see:

**In the agent terminal:**
```
Job started: Build Application
Running: npm install
Running: npm test
Job completed: Build Application

Job started: Docker Build
Running: docker build
Job completed: Docker Build

Job started: Deploy Locally
Running: docker run
Job completed: Deploy Locally
```

**In Azure DevOps:**
- Go to **Pipelines** → **Pipelines**
- Click on your running pipeline
- Watch the live logs!

**On your local machine:**
```bash
# Check the running container
docker ps

# Test the application
curl http://localhost:3000/health
```

---

## 🎮 Managing the Agent

### Start Agent (when needed)
```bash
cd ~/azagent
./run.sh
```

### Stop Agent
Press `Ctrl+C` in the terminal running the agent

### Run Agent as Background Service (Optional)

If you want the agent to run automatically:

```bash
cd ~/azagent

# Install as service
sudo ./svc.sh install

# Start service
sudo ./svc.sh start

# Check status
sudo ./svc.sh status

# Stop service
sudo ./svc.sh stop

# Uninstall service
sudo ./svc.sh uninstall
```

---

## 🔄 Triggering Deployments

### Automatic Trigger (on Git Push)

```bash
cd /Users/anandprakashmishra/Desktop/Danger/Learning

# Make any change
echo "# Update" >> README.md

# Commit and push
git add .
git commit -m "Trigger deployment"
git push
```

The pipeline will automatically run on your local agent!

### Manual Trigger (from Azure DevOps)

1. Go to **Pipelines** → **Pipelines**
2. Select your pipeline
3. Click **"Run pipeline"**
4. Select branch: `main`
5. Click **"Run"**

---

## 📊 Monitoring Your Deployment

### View Agent Status

**In Azure DevOps:**
1. Go to **Project Settings** (bottom left)
2. Click **Agent pools** → **Default**
3. Click **Agents** tab
4. You should see your agent: `my-local-agent` (Online ✅)

### View Pipeline Logs

1. Go to **Pipelines** → **Pipelines**
2. Click on a pipeline run
3. Click on each stage to see logs:
   - Build Application
   - Build Docker Image
   - Deploy Locally

### Check Local Deployment

```bash
# Check running containers
docker ps

# View application logs
docker logs nodejs-app

# Test endpoints
curl http://localhost:3000
curl http://localhost:3000/health
curl http://localhost:3000/api/users

# Or open in browser
open http://localhost:3000
```

---

## 🛠️ Troubleshooting

### Agent Not Showing as Online

**Check agent is running:**
```bash
cd ~/azagent
./run.sh
```

**Verify in Azure DevOps:**
- Project Settings → Agent pools → Default → Agents
- Your agent should show "Online"

### Pipeline Not Using Your Agent

**Update `azure-pipelines.yml`:**
```yaml
pool:
  name: 'Default'
```

**Verify agent capabilities:**
- In Azure DevOps: Agent pools → Default → Agents → [Your Agent] → Capabilities
- Should show: Node, Docker, npm, etc.

### Docker Not Found

**Ensure Docker Desktop is running:**
```bash
# Check Docker
docker --version
docker ps

# Start Docker Desktop if needed
open -a Docker
```

**Add Docker to agent PATH:**
```bash
# Edit your shell profile
nano ~/.zshrc

# Add Docker path
export PATH="/Applications/Docker.app/Contents/Resources/bin:$PATH"

# Reload
source ~/.zshrc

# Restart agent
cd ~/azagent
./run.sh
```

### Port 3000 Already in Use

```bash
# Find and kill process on port 3000
lsof -i :3000
kill -9 <PID>

# Or change port in azure-pipelines.yml
docker run -d -p 3001:3000 ...
```

---

## ✅ Verification Checklist

Before running the pipeline, ensure:

- [ ] Azure DevOps project created
- [ ] Code pushed to Git repository
- [ ] Self-hosted agent installed and configured
- [ ] Agent is running (`./run.sh`)
- [ ] Agent shows "Online" in Azure DevOps
- [ ] Pipeline created and linked to repository
- [ ] `azure-pipelines.yml` uses `pool: name: 'Default'`
- [ ] Docker Desktop is running
- [ ] Port 3000 is available

---

## 🎯 Complete Workflow Example

```bash
# 1. Start the agent (Terminal 1)
cd ~/azagent
./run.sh

# 2. Make code changes (Terminal 2)
cd /Users/anandprakashmishra/Desktop/Danger/Learning
# ... edit files ...

# 3. Commit and push
git add .
git commit -m "Update feature"
git push

# 4. Watch the agent terminal - it will show:
#    - Job received
#    - Building application
#    - Building Docker image
#    - Deploying locally

# 5. Test the deployment
curl http://localhost:3000/health

# 6. View in browser
open http://localhost:3000
```

---

## 📝 Quick Reference

### Agent Commands
```bash
# Start agent
cd ~/azagent && ./run.sh

# Configure agent
cd ~/azagent && ./config.sh

# Remove agent configuration
cd ~/azagent && ./config.sh remove
```

### Docker Commands
```bash
# View running containers
docker ps

# View logs
docker logs nodejs-app

# Stop and remove
docker stop nodejs-app && docker rm nodejs-app

# Rebuild and run
docker build -t nodejs-docker-app . && \
docker run -d -p 3000:3000 --name nodejs-app nodejs-docker-app
```

### Git Commands
```bash
# Push to trigger pipeline
git add .
git commit -m "Deploy changes"
git push
```

---

## 🎉 Summary

**Yes, you can absolutely use Azure DevOps agent to deploy to your local machine!**

The self-hosted agent:
- ✅ Runs on **your Mac**
- ✅ Executes pipeline jobs **locally**
- ✅ Builds Docker images **on your machine**
- ✅ Deploys containers to **localhost:3000**
- ✅ Gives you full control and visibility

**Benefits:**
- 🚀 Automated deployment on every push
- 📊 Full pipeline visibility in Azure DevOps
- 🔄 Consistent deployment process
- 🛡️ Runs in your local environment
- 💰 Free (uses your own hardware)

**Next Steps:**
1. Install the agent (Step 3)
2. Configure the pipeline (Step 4-5)
3. Push code and watch it deploy automatically! 🎉
