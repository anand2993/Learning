# Azure Agent Download - Troubleshooting DNS Issue

## ❌ Problem: DNS Resolution Failed

The error `Could not resolve host: vstsagentpackage.azureedge.net` indicates a DNS issue.

---

## ✅ Solutions (Try in Order)

### Solution 1: Download from GitHub (Recommended)

The Azure Pipelines agent is also available on GitHub:

```bash
cd ~/azagent

# Download from GitHub releases
curl -L -O https://github.com/microsoft/azure-pipelines-agent/releases/download/v3.248.0/vsts-agent-osx-arm64-3.248.0.tar.gz

# Extract
tar zxvf vsts-agent-osx-arm64-3.248.0.tar.gz

# Configure
./config.sh
```

### Solution 2: Use wget Instead of curl

```bash
cd ~/azagent

# Install wget if not available
brew install wget

# Download using wget
wget https://vstsagentpackage.azureedge.net/agent/3.248.0/vsts-agent-osx-arm64-3.248.0.tar.gz

# Extract
tar zxvf vsts-agent-osx-arm64-3.248.0.tar.gz

# Configure
./config.sh
```

### Solution 3: Change DNS Server

Your DNS might be blocking the Microsoft domain. Try using Google DNS:

```bash
# Check current DNS
scutil --dns | grep 'nameserver\[[0-9]*\]'

# Temporarily use Google DNS (8.8.8.8)
# Go to System Preferences → Network → Advanced → DNS
# Add: 8.8.8.8 and 8.8.4.4

# Or use command line (temporary):
sudo networksetup -setdnsservers Wi-Fi 8.8.8.8 8.8.4.4

# Then try curl again
cd ~/azagent
curl -O https://vstsagentpackage.azureedge.net/agent/3.248.0/vsts-agent-osx-arm64-3.248.0.tar.gz

# Restore DNS (optional)
sudo networksetup -setdnsservers Wi-Fi empty
```

### Solution 4: Manual Download via Browser

1. **Open this URL in your browser:**
   ```
   https://github.com/microsoft/azure-pipelines-agent/releases/download/v3.248.0/vsts-agent-osx-arm64-3.248.0.tar.gz
   ```

2. **Save the file to:** `~/azagent/`

3. **Extract and configure:**
   ```bash
   cd ~/azagent
   tar zxvf vsts-agent-osx-arm64-3.248.0.tar.gz
   ./config.sh
   ```

### Solution 5: Use Azure DevOps Direct Link

Try the direct download from Azure DevOps:

```bash
cd ~/azagent

# Try with -L flag to follow redirects
curl -L -O https://vstsagentpackage.azureedge.net/agent/3.248.0/vsts-agent-osx-arm64-3.248.0.tar.gz

# Extract
tar zxvf vsts-agent-osx-arm64-3.248.0.tar.gz
```

---

## 🎯 Recommended: Use GitHub Method

**This is the most reliable method:**

```bash
cd ~/azagent

# Download from GitHub (official Microsoft repository)
curl -L -O https://github.com/microsoft/azure-pipelines-agent/releases/download/v3.248.0/vsts-agent-osx-arm64-3.248.0.tar.gz

# Verify download
ls -lh vsts-agent-osx-arm64-3.248.0.tar.gz

# Extract
tar zxvf vsts-agent-osx-arm64-3.248.0.tar.gz

# Verify extraction
ls -la

# Configure the agent
./config.sh
```

---

## 🔍 Verify Your Download

After downloading, verify the file:

```bash
cd ~/azagent

# Check file size (should be around 150-200 MB)
ls -lh vsts-agent-osx-arm64-3.248.0.tar.gz

# Check file type
file vsts-agent-osx-arm64-3.248.0.tar.gz
```

Expected output:
```
vsts-agent-osx-arm64-3.248.0.tar.gz: gzip compressed data
```

---

## 📋 Complete Setup After Download

Once you have the agent downloaded and extracted:

### 1. Configure the Agent

```bash
cd ~/azagent
./config.sh
```

**You'll need:**
- Azure DevOps URL: `https://dev.azure.com/YOUR_ORGANIZATION`
- Personal Access Token (PAT) - create one in Azure DevOps
- Agent pool: `Default` (press Enter)
- Agent name: `my-local-agent` (or press Enter for default)

### 2. Start the Agent

```bash
cd ~/azagent
./run.sh
```

You should see:
```
Listening for Jobs
```

---

## 🆘 Still Having Issues?

### Check Network/Firewall

```bash
# Test connectivity to GitHub
curl -I https://github.com

# Test connectivity to Azure
curl -I https://dev.azure.com

# Check if behind corporate proxy
echo $HTTP_PROXY
echo $HTTPS_PROXY
```

### Behind Corporate Proxy?

If you're behind a corporate proxy:

```bash
# Set proxy for curl
export HTTP_PROXY=http://proxy.company.com:8080
export HTTPS_PROXY=http://proxy.company.com:8080

# Then try download again
curl -L -O https://github.com/microsoft/azure-pipelines-agent/releases/download/v3.248.0/vsts-agent-osx-arm64-3.248.0.tar.gz
```

---

## 🎉 Quick Start Command

**Copy and paste this complete command:**

```bash
cd ~/azagent && \
curl -L -O https://github.com/microsoft/azure-pipelines-agent/releases/download/v3.248.0/vsts-agent-osx-arm64-3.248.0.tar.gz && \
tar zxvf vsts-agent-osx-arm64-3.248.0.tar.gz && \
echo "✅ Agent downloaded and extracted successfully!" && \
echo "📝 Next step: Run ./config.sh to configure the agent"
```

---

## 📚 Alternative: Skip Agent, Use Cloud-Hosted

If you can't get the self-hosted agent working, you can use Microsoft-hosted agents instead:

**Update `azure-pipelines.yml`:**

```yaml
pool:
  vmImage: 'ubuntu-latest'  # Use Microsoft's cloud agents
```

**Note:** This won't deploy to your local machine, but will run in Azure's cloud environment.

---

## 💡 Summary

**Best approach:**
1. ✅ Use GitHub download link (most reliable)
2. ✅ Or download manually via browser
3. ✅ Extract and configure
4. ✅ Start the agent

**GitHub download command:**
```bash
curl -L -O https://github.com/microsoft/azure-pipelines-agent/releases/download/v3.248.0/vsts-agent-osx-arm64-3.248.0.tar.gz
```
