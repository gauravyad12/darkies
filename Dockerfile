# Multi-app Dockerfile for December (Bun backend + Next.js frontend)
# Designed for deployment on platforms like Coolify

# Use official Node image so we have full Node.js toolchain available
FROM node:22-bullseye AS runtime

# Install curl (for Bun install script) and CA certificates
RUN apt-get update \
    && apt-get install -y curl ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install Bun via official install script
RUN curl -fsSL https://bun.sh/install | bash \
    && mv /root/.bun /usr/local/bun \
    && ln -s /usr/local/bun/bin/bun /usr/local/bin/bun

# Set working directory
WORKDIR /app

# Copy full repository
COPY . .

# Install dependencies for backend and frontend using Bun
RUN bun install --cwd backend \
    && bun install --cwd frontend \
    && chmod +x start.sh

# Expose ports
# 3000 - Next.js frontend
# 4000 - Express/Bun backend API
EXPOSE 3000 4000

# Start both backend and frontend (see start.sh)
CMD ["./start.sh"]
