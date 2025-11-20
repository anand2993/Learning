# Node.js Docker Application with Azure DevOps Pipeline

A production-ready Node.js application with Docker containerization and Azure DevOps CI/CD pipeline.

## 🚀 Features

- **Express.js REST API** with sample endpoints
- **Docker containerization** using Alpine Linux base image
- **Multi-stage Docker build** for optimized image size
- **Azure DevOps pipeline** for automated build and deployment
- **Health check endpoints** for monitoring
- **Graceful shutdown** handling
- **Security best practices** (non-root user, minimal base image)

## 📋 Prerequisites

- **Node.js** 18.x or higher
- **Docker** 20.x or higher
- **Docker Compose** (optional, for easier local development)
- **Azure DevOps** account (for pipeline deployment)

## 🛠️ Local Development

### 1. Install Dependencies

```bash
npm install
```

### 2. Run the Application

```bash
npm start
```

The application will be available at `http://localhost:3000`

## 🐳 Docker Deployment

### Option 1: Using Docker Commands

#### Build the Docker Image

```bash
docker build -t nodejs-docker-app .
```

#### Run the Container

```bash
docker run -d \
  --name nodejs-app \
  -p 3000:3000 \
  -e NODE_ENV=production \
  nodejs-docker-app
```

#### Stop the Container

```bash
docker stop nodejs-app
docker rm nodejs-app
```

### Option 2: Using Docker Compose

#### Start the Application

```bash
docker-compose up -d
```

#### View Logs

```bash
docker-compose logs -f
```

#### Stop the Application

```bash
docker-compose down
```

## 🔄 Azure DevOps Pipeline

### Setup Instructions

1. **Create a new pipeline** in Azure DevOps
2. **Connect to your repository** (GitHub, Azure Repos, etc.)
3. **Select existing Azure Pipelines YAML file**: `azure-pipelines.yml`
4. **Configure variables** (optional):
   - `containerRegistry`: Your Azure Container Registry or Docker Hub connection
   - Update the registry settings if you want to push images

### Pipeline Stages

The pipeline consists of three stages:

1. **Build Stage**
   - Installs Node.js dependencies
   - Runs tests
   - Validates the application

2. **Docker Stage**
   - Builds Docker image with multi-stage build
   - Tags image with build ID and 'latest'
   - (Optional) Pushes to container registry

3. **Deploy Stage**
   - Stops existing container
   - Runs new container locally
   - Performs health check
   - Displays deployment status

### Running the Pipeline

The pipeline triggers automatically on commits to:
- `main`
- `master`
- `develop`

You can also trigger it manually from the Azure DevOps UI.

## 📡 API Endpoints

### GET /
Welcome message with application info

**Response:**
```json
{
  "message": "Welcome to Node.js Docker Application!",
  "version": "1.0.0",
  "timestamp": "2025-11-20T04:28:00.000Z"
}
```

### GET /health
Health check endpoint for monitoring

**Response:**
```json
{
  "status": "healthy",
  "uptime": 123.456,
  "timestamp": "2025-11-20T04:28:00.000Z"
}
```

### GET /api/info
Application and system information

**Response:**
```json
{
  "application": "Node.js Docker App",
  "nodeVersion": "v18.x.x",
  "platform": "linux",
  "environment": "production"
}
```

### GET /api/users
Sample user data endpoint

**Response:**
```json
[
  {
    "id": 1,
    "name": "John Doe",
    "email": "john@example.com"
  }
]
```

## 🧪 Testing

### Test the Application Locally

```bash
# Start the application
npm start

# In another terminal, test the endpoints
curl http://localhost:3000
curl http://localhost:3000/health
curl http://localhost:3000/api/info
curl http://localhost:3000/api/users
```

### Test the Docker Container

```bash
# Build and run
docker build -t nodejs-docker-app .
docker run -p 3000:3000 nodejs-docker-app

# Test endpoints
curl http://localhost:3000/health
```

## 🔒 Security Features

- **Non-root user**: Container runs as user `nodejs` (UID 1001)
- **Minimal base image**: Alpine Linux for reduced attack surface
- **Production dependencies only**: No dev dependencies in final image
- **Health checks**: Built-in Docker health monitoring
- **Graceful shutdown**: Proper SIGTERM/SIGINT handling

## 📦 Project Structure

```
.
├── server.js              # Express.js application
├── package.json           # Node.js dependencies and scripts
├── Dockerfile             # Multi-stage Docker build
├── .dockerignore          # Docker build exclusions
├── docker-compose.yml     # Docker Compose configuration
├── azure-pipelines.yml    # Azure DevOps CI/CD pipeline
├── .gitignore            # Git exclusions
└── README.md             # This file
```

## 🚀 Deployment to Azure

To deploy to Azure Container Instances or Azure App Service:

1. **Configure Azure Container Registry** in Azure DevOps
2. **Uncomment the push step** in `azure-pipelines.yml`
3. **Add deployment tasks** for your target Azure service
4. **Update environment variables** as needed

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📝 License

ISC

## 📧 Support

For issues and questions, please create an issue in the repository.

---

**Built with ❤️ using Node.js, Docker, and Azure DevOps**
