FROM node:16

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Use the official npm registry instead of Taobao
RUN npm config set registry https://registry.npmjs.org

# Increase the fetch timeout to avoid network issues
RUN npm config set fetch-timeout 60000

# Install dependencies
RUN npm install

# Copy the rest of the application
COPY . .

# Expose the port (assuming your app runs on port 3000)
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
