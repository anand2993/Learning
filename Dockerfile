# Multi-stage build for optimized production image

# Stage 1: Build stage
FROM node:18-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies (production only)
RUN npm install --omit=dev

# Stage 2: Production stage
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Create non-root user for security
RUN addgroup -g 1001 -S nodejs && \
  adduser -S nodejs -u 1001

# Copy dependencies from builder stage
COPY --from=builder /app/node_modules ./node_modules

# Copy application files
COPY --chown=nodejs:nodejs server.js ./
COPY --chown=nodejs:nodejs package*.json ./

# Switch to non-root user
USER nodejs

# Expose application port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/health', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})"

# Set environment to production
ENV NODE_ENV=production

# Start the application
CMD ["node", "server.js"]
