# Use a smaller Node.js base image
FROM node:16-alpine AS builder

# Set working directory
WORKDIR /app

# Copy only package files to leverage caching
COPY package*.json ./

# Set npm registry to avoid timeout issues
RUN npm config set registry https://registry.npmjs.org

# Increase the fetch timeout
RUN npm config set fetch-timeout 60000

# Install dependencies
RUN npm install --only=production

# Copy the rest of the application
COPY . .

# Use a smaller final image
FROM node:16-alpine

WORKDIR /app

# Copy only necessary files from the builder stage
COPY --from=builder /app .

# Expose the port (assuming your app runs on port 3000)
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
