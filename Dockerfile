# Stage 1 - Install dependencies
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

# Stage 2 - Run the app
FROM node:18-alpine
WORKDIR /app

# Don't run as root - security best practice
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

COPY --from=builder /app/node_modules ./node_modules
COPY src/ ./src/
COPY package.json ./

USER appuser
EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=3s \
  CMD wget -qO- http://localhost:3000/health || exit 1

CMD ["node", "src/index.js"]
