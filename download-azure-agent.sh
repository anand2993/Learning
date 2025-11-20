#!/bin/bash

# Azure Pipelines Agent - Correct Download Script
# This script downloads the latest Azure Pipelines agent for macOS ARM64

set -e

echo "🔍 Downloading Azure Pipelines Agent for macOS ARM64..."
echo ""

# Clean up any failed downloads
cd ~/azagent
rm -f vsts-agent-osx-arm64-*.tar.gz

# Get the latest version from GitHub API
echo "📡 Fetching latest version information..."
LATEST_VERSION=$(curl -s https://api.github.com/repos/microsoft/azure-pipelines-agent/releases/latest | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')

if [ -z "$LATEST_VERSION" ]; then
    echo "⚠️  Could not fetch latest version, using known version 4.265.1"
    LATEST_VERSION="4.265.1"
fi

echo "📦 Latest version: $LATEST_VERSION"
echo ""

# Download URL
DOWNLOAD_URL="https://github.com/microsoft/azure-pipelines-agent/releases/download/v${LATEST_VERSION}/vsts-agent-osx-arm64-${LATEST_VERSION}.tar.gz"
FILENAME="vsts-agent-osx-arm64-${LATEST_VERSION}.tar.gz"

echo "⬇️  Downloading from: $DOWNLOAD_URL"
echo ""

# Download with progress
curl -L -o "$FILENAME" "$DOWNLOAD_URL"

# Check file size
FILE_SIZE=$(ls -lh "$FILENAME" | awk '{print $5}')
echo ""
echo "✅ Downloaded: $FILENAME ($FILE_SIZE)"

# Verify it's a valid gzip file
if file "$FILENAME" | grep -q "gzip compressed"; then
    echo "✅ File is valid gzip archive"
    echo ""
    echo "📂 Extracting..."
    tar zxvf "$FILENAME"
    echo ""
    echo "🎉 Success! Agent is ready."
    echo ""
    echo "📝 Next steps:"
    echo "   1. Run: cd ~/azagent"
    echo "   2. Run: ./config.sh"
    echo "   3. Run: ./run.sh"
else
    echo "❌ Error: Downloaded file is not a valid gzip archive"
    echo "File type: $(file $FILENAME)"
    exit 1
fi
